#!/usr/bin/env bash
#
# Capture nucatch store screenshots for every store-required device size, then
# sort them into the folder layouts Fastlane's `deliver` (iOS) and `supply`
# (Android) upload from.
#
# The frames come from integration_test/store_screenshots_test.dart, driven by
# test_driver/screenshot_driver.dart. That run boots the real app but (a) runs
# signed-out and (b) swaps the leaderboard for a curated demo one, so no real
# user data / username / email ever appears — every value on screen is curated
# demo content. See tool/screenshots/README.md.
#
# Usage:
#   tool/screenshots/capture.sh all        # iOS + Android (default)
#   tool/screenshots/capture.sh ios        # iOS simulators only
#   tool/screenshots/capture.sh android    # Android emulators only
#   KEEP_DEVICES=1 tool/screenshots/capture.sh ios   # leave sims/emus running
#
# Prereqs: Flutter, Xcode + simulators (iOS), Android SDK + AVDs (Android).
# See tool/screenshots/README.md for the full runbook + how to upload.
set -euo pipefail

# --------------------------------------------------------------------------
# Config
# --------------------------------------------------------------------------
LOCALE="en-US"                         # English only (per plan)
DRIVER="test_driver/screenshot_driver.dart"
TARGET="integration_test/store_screenshots_test.dart"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RAW_DIR="$REPO_ROOT/build/screenshots"        # per-device raw PNGs land here
IOS_OUT="$REPO_ROOT/ios/fastlane/screenshots/$LOCALE"
AND_META="$REPO_ROOT/android/fastlane/metadata/android/$LOCALE/images"

# iOS device matrix. `deliver` maps each PNG to a display type by its
# resolution, so filenames only need to be unique; we tag them by device on copy.
#   iPhone 13 Pro Max -> 6.7" iPhone slot, 1284 x 2778
#   iPad Pro 13-inch  -> 13"  iPad slot,   2064 x 2752
IOS_DEVICES=(
  "iphone_6_7|iPhone 13 Pro Max"
  "ipad_13|iPad Pro 13-inch (M4)"
)

# Android device matrix — one phone (phoneScreenshots) + one 10" tablet
# (tenInchScreenshots). Format: "bucket|avd_name".
ANDROID_DEVICES=(
  "phone|Pixel_7_Pro"
  "tenInch|Pixel_Tablet"
)

MODE="${1:-all}"
KEEP_DEVICES="${KEEP_DEVICES:-0}"

log()  { printf '\033[1;36m▶ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m⚠ %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[1;31m✖ %s\033[0m\n' "$*" >&2; exit 1; }

# The store test's screenshot names carry the walkthrough's 'portrait_' prefix
# (portrait_01_home.png). Strip it so the uploaded files read cleanly, e.g.
# iphone_6_7_01_home.png / 01_home.png.
strip_prefix() { local b; b="$(basename "$1")"; echo "${b#portrait_}"; }

cd "$REPO_ROOT"

# --------------------------------------------------------------------------
# iOS
# --------------------------------------------------------------------------
ios_udid_for() {
  # Prints the UDID of an available simulator whose name exactly matches $1.
  xcrun simctl list devices available \
    | grep -F "$1 (" \
    | head -n1 \
    | grep -oE '[0-9A-F-]{36}' || true
}

capture_ios() {
  command -v xcrun >/dev/null || die "xcrun not found — Xcode required for iOS."
  mkdir -p "$IOS_OUT"

  # Force the iOS app to rebuild from THIS target. `flutter drive` on iOS
  # reuses an existing build/ios/.../Runner.app when it thinks nothing changed
  # — and a --target change alone often doesn't count, so a prior run of a
  # *different* entrypoint (e.g. screenshot_test_ipad_landscape.dart) would be
  # silently rerun here, producing the wrong screenshots. Removing the built
  # app once, up front, guarantees the correct $TARGET is compiled. Both iOS
  # devices are the iphonesimulator platform, so the second reuses the first's
  # fresh build — same target, correct.
  log "iOS: clearing build/ios so '$TARGET' is rebuilt (not a stale target)"
  rm -rf "$REPO_ROOT/build/ios"

  for entry in "${IOS_DEVICES[@]}"; do
    local tag="${entry%%|*}"; local name="${entry#*|}"
    local udid; udid="$(ios_udid_for "$name")"
    if [[ -z "$udid" ]]; then
      warn "iOS simulator '$name' not found — skipping. Create it in Xcode > Devices, or edit IOS_DEVICES."
      continue
    fi

    log "iOS: booting '$name' ($udid)"
    xcrun simctl boot "$udid" 2>/dev/null || true
    open -a Simulator >/dev/null 2>&1 || true
    xcrun simctl bootstatus "$udid" -b >/dev/null 2>&1 || true

    # Clean marketing status bar (9:41, full battery/signal) — also keeps the
    # real clock/carrier out of frame.
    xcrun simctl status_bar "$udid" override \
      --time "9:41" \
      --batteryState charged --batteryLevel 100 \
      --cellularMode active --cellularBars 4 \
      --dataNetwork wifi --wifiMode active --wifiBars 3 2>/dev/null || true

    local out="$RAW_DIR/$tag"
    rm -rf "$out"; mkdir -p "$out"
    log "iOS: driving screenshots on '$name'"
    NUCATCH_SHOT_DIR="$out" flutter drive \
      --driver="$DRIVER" --target="$TARGET" -d "$udid"

    log "iOS: copying '$tag' frames into $IOS_OUT (device-tagged for uniqueness)"
    for png in "$out"/*.png; do
      [[ -e "$png" ]] || { warn "no PNGs produced for '$name'"; break; }
      cp "$png" "$IOS_OUT/${tag}_$(strip_prefix "$png")"
    done

    xcrun simctl status_bar "$udid" clear 2>/dev/null || true
    [[ "$KEEP_DEVICES" == "1" ]] || xcrun simctl shutdown "$udid" 2>/dev/null || true
  done
}

# --------------------------------------------------------------------------
# Android
# --------------------------------------------------------------------------
# Prints the emulator serial currently running the AVD named $1, or nothing.
# Lets several emulators be attached at once without the bare-`adb` ambiguity
# ("more than one device/emulator") — we always target a specific serial.
android_serial_for_avd() {
  local want="$1" serial name
  for serial in $(adb devices | awk '/^emulator-/{print $1}'); do
    name="$(adb -s "$serial" emu avd name 2>/dev/null | head -n1 | tr -d '\r')"
    [[ "$name" == "$want" ]] && { echo "$serial"; return 0; }
  done
  return 0
}

# Clean status bar via SystemUI demo mode on serial $1 (best-effort; API 23+).
android_demo_statusbar() {
  local s="$1"
  local demo="am broadcast -a com.android.systemui.demo"
  adb -s "$s" shell settings put global sysui_demo_allowed 1 || true
  adb -s "$s" shell $demo -e command enter >/dev/null || true
  adb -s "$s" shell $demo -e command clock -e hhmm 0941 >/dev/null || true
  adb -s "$s" shell $demo -e command battery -e level 100 -e plugged false >/dev/null || true
  adb -s "$s" shell $demo -e command network -e wifi show -e level 4 >/dev/null || true
  adb -s "$s" shell $demo -e command network -e mobile show -e datatype none -e level 4 >/dev/null || true
  adb -s "$s" shell $demo -e command notifications -e visible false >/dev/null || true
}

capture_android() {
  command -v adb >/dev/null || die "adb not found — Android SDK platform-tools required."

  # Same rationale as capture_ios: drop the built app so `flutter drive`
  # compiles THIS target rather than reusing a stale one left by a previous
  # run of a different entrypoint. Cheaper on Android than iOS, but kept
  # symmetric so neither platform can silently capture the wrong screens.
  log "Android: clearing build/app so '$TARGET' is rebuilt (not a stale target)"
  rm -rf "$REPO_ROOT/build/app"

  for entry in "${ANDROID_DEVICES[@]}"; do
    local bucket="${entry%%|*}"; local avd="${entry#*|}"
    local dest="$AND_META/${bucket}Screenshots"

    # Reuse the AVD if it's already running; otherwise boot it ourselves.
    local serial started_here=0
    serial="$(android_serial_for_avd "$avd")" || true
    if [[ -z "$serial" ]]; then
      if ! command -v emulator >/dev/null; then
        warn "'$avd' isn't running and the emulator binary isn't on PATH — start it manually, or skip."
        continue
      fi
      if ! emulator -list-avds | grep -qx "$avd"; then
        warn "AVD '$avd' not found — skipping. Create it in Android Studio's Device Manager, or edit ANDROID_DEVICES."
        continue
      fi
      log "Android: starting AVD '$avd'"
      emulator -avd "$avd" -no-snapshot -no-boot-anim -netdelay none -netspeed full >/dev/null 2>&1 &
      started_here=1
      local tries=0
      while [[ -z "$serial" && $tries -lt 90 ]]; do
        sleep 2; serial="$(android_serial_for_avd "$avd")" || true; tries=$((tries + 1))
      done
    else
      log "Android: reusing already-running AVD '$avd' ($serial)"
    fi
    [[ -n "$serial" ]] || { warn "couldn't get a serial for '$avd' — skipping."; continue; }

    log "Android: waiting for '$avd' ($serial) to finish booting"
    local btries=0
    until [[ "$(adb -s "$serial" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; do
      sleep 2; btries=$((btries + 1)); (( btries < 150 )) || die "'$avd' ($serial) never finished booting."
    done
    android_demo_statusbar "$serial"

    local out="$RAW_DIR/android_$bucket"
    rm -rf "$out"; mkdir -p "$out"
    log "Android: driving screenshots on '$avd' ($serial)"
    NUCATCH_SHOT_DIR="$out" flutter drive \
      --driver="$DRIVER" --target="$TARGET" -d "$serial"

    log "Android: copying '$bucket' frames into $dest"
    rm -rf "$dest"; mkdir -p "$dest"
    for png in "$out"/*.png; do
      [[ -e "$png" ]] || { warn "no PNGs produced for '$avd'"; break; }
      cp "$png" "$dest/$(strip_prefix "$png")"
    done

    adb -s "$serial" shell am broadcast -a com.android.systemui.demo -e command exit >/dev/null || true
    # Only shut down emulators this script started, and only when not asked to keep them.
    if [[ "$started_here" == "1" && "$KEEP_DEVICES" != "1" ]]; then
      adb -s "$serial" emu kill >/dev/null 2>&1 || true
    fi
  done
}

# --------------------------------------------------------------------------
# Report + run
# --------------------------------------------------------------------------
report_dimensions() {
  command -v sips >/dev/null || return 0
  log "Captured frame dimensions:"
  find "$IOS_OUT" "$AND_META" -name '*.png' 2>/dev/null | sort | while read -r f; do
    local dims; dims="$(sips -g pixelWidth -g pixelHeight "$f" 2>/dev/null \
      | awk '/pixelWidth/{w=$2} /pixelHeight/{h=$2} END{print w"x"h}')"
    printf '   %-9s  %s\n' "$dims" "${f#$REPO_ROOT/}"
  done
}

case "$MODE" in
  ios)     capture_ios ;;
  android) capture_android ;;
  all)     capture_ios; capture_android ;;
  *)       die "Unknown mode '$MODE' (use: ios | android | all)" ;;
esac

report_dimensions

cat <<EOF

$(printf '\033[1;32m✓ Screenshots captured.\033[0m')

Review the PNGs before uploading:
  iOS:     ios/fastlane/screenshots/$LOCALE/
  Android: android/fastlane/metadata/android/$LOCALE/images/{phone,tenInch}Screenshots/

Then upload (needs store credentials — see tool/screenshots/README.md):
  iOS:     (cd ios     && bundle exec fastlane ios     upload_screenshots)
  Android: (cd android && bundle exec fastlane android upload_screenshots)
EOF
