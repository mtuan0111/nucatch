#!/usr/bin/env bash
#
# Capture nucatch store screenshots for every store-required device size, in
# every marketing localization (English + Vietnamese), then sort them into the
# folder layouts Fastlane's `deliver` (iOS) and `supply` (Android) upload from —
# one localized set per language.
#
# The frames come from integration_test/store_screenshots_test.dart, driven by
# test_driver/screenshot_driver.dart. That run boots the real app but (a) runs
# signed-out and (b) swaps the leaderboard for a curated demo one, so no real
# user data / username / email ever appears — every value on screen is curated
# demo content. The UI language is pinned per run via
# `--dart-define=NUCATCH_LOCALE=<code>` (the walkthrough seeds it onto
# PreferencesKey.LOCALE before app.main() and taps widgets by their translated
# labels), so an English pass and a Vietnamese pass render the same flow in each
# language. See tool/screenshots/README.md.
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
# Localizations to capture. Format: "fastlane_dir|dart_locale".
#   fastlane_dir — the folder deliver (iOS) / supply (Android) upload from.
#                  App Store Connect and Play both key US English as "en-US"
#                  and Vietnamese as "vi".
#   dart_locale  — the code handed to the app via --dart-define=NUCATCH_LOCALE,
#                  which pins both the UI locale and the widget-finder language
#                  in the walkthrough. To add a language, add a row (the
#                  fastlane_dir must be the store's locale code, e.g. "ja").
LOCALES=(
  "en-US|en"
  "vi|vi"
)
DRIVER="test_driver/screenshot_driver.dart"
TARGET="integration_test/store_screenshots_test.dart"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RAW_DIR="$REPO_ROOT/build/screenshots"        # per-device/-locale raw PNGs land here
IOS_SHOTS="$REPO_ROOT/ios/fastlane/screenshots"             # <locale>/ appended per run
AND_META_ROOT="$REPO_ROOT/android/fastlane/metadata/android" # <locale>/images/... appended

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
#
# IMPORTANT — Google Play rejects any screenshot whose long side is more than
# TWICE its short side (max 2:1 aspect ratio). Most modern phones are 19.5:9 or
# 20:9 (~2.17:1), so a full-resolution portrait grab from e.g. a Pixel 7 Pro
# (1440x3120) is REJECTED. The phone AVD MUST be <= 2:1. `flutter_emulator`
# (device "pixel", 1080x1920 = 1.78:1) is the default — it's the AVD
# `flutter emulators --create` makes, and it matches Play's recommended
# 1080x1920 phone shape. A `Pixel_2` or a custom 1080x2160 (2.0:1) AVD also
# work. The 10" `Pixel_Tablet` (2560x1600 = 1.6:1) is already compliant.
# report_dimensions() flags any frame that slips over 2:1.
ANDROID_DEVICES=(
  "phone|flutter_emulator"
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

    # Boot the sim once, then drive it once per locale — booting is the slow
    # part, so it's reused across every language.
    for loc in "${LOCALES[@]}"; do
      local fdir="${loc%%|*}"; local dloc="${loc#*|}"
      local ios_out="$IOS_SHOTS/$fdir"
      mkdir -p "$ios_out"

      local out="$RAW_DIR/${tag}_${dloc}"
      rm -rf "$out"; mkdir -p "$out"
      log "iOS: driving '$name' screenshots for '$fdir' (NUCATCH_LOCALE=$dloc)"
      NUCATCH_SHOT_DIR="$out" flutter drive \
        --driver="$DRIVER" --target="$TARGET" -d "$udid" \
        --dart-define=NUCATCH_LOCALE="$dloc"

      log "iOS: copying '$tag'/'$fdir' frames into $ios_out (device-tagged for uniqueness)"
      for png in "$out"/*.png; do
        [[ -e "$png" ]] || { warn "no PNGs produced for '$name' ($fdir)"; break; }
        cp "$png" "$ios_out/${tag}_$(strip_prefix "$png")"
      done
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

    # Boot the emulator once, then drive it once per locale — booting is the
    # slow part, so it's reused across every language.
    for loc in "${LOCALES[@]}"; do
      local fdir="${loc%%|*}"; local dloc="${loc#*|}"
      local dest="$AND_META_ROOT/$fdir/images/${bucket}Screenshots"

      local out="$RAW_DIR/android_${bucket}_${dloc}"
      rm -rf "$out"; mkdir -p "$out"
      log "Android: driving '$avd' ($serial) screenshots for '$fdir' (NUCATCH_LOCALE=$dloc)"
      NUCATCH_SHOT_DIR="$out" flutter drive \
        --driver="$DRIVER" --target="$TARGET" -d "$serial" \
        --dart-define=NUCATCH_LOCALE="$dloc"

      log "Android: copying '$bucket'/'$fdir' frames into $dest"
      rm -rf "$dest"; mkdir -p "$dest"
      for png in "$out"/*.png; do
        [[ -e "$png" ]] || { warn "no PNGs produced for '$avd' ($fdir)"; break; }
        cp "$png" "$dest/$(strip_prefix "$png")"
      done
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
# Prints each captured frame's dimensions, and loudly flags any Android frame
# whose long side exceeds 2x its short side — Google Play rejects those (see the
# ANDROID_DEVICES note). iOS has no such rule, so its frames are only reported.
report_dimensions() {
  command -v sips >/dev/null || return 0
  log "Captured frame dimensions:"
  local violations=0
  while read -r f; do
    [[ -n "$f" ]] || continue
    local w h dims ratio flag
    w="$(sips -g pixelWidth  "$f" 2>/dev/null | awk '/pixelWidth/{print $2}')"
    h="$(sips -g pixelHeight "$f" 2>/dev/null | awk '/pixelHeight/{print $2}')"
    dims="${w}x${h}"
    flag=""
    if [[ "$f" == "$AND_META_ROOT/"* && -n "$w" && -n "$h" ]]; then
      # long/short > 2.0 ? (awk handles the float compare)
      if awk -v a="$w" -v b="$h" 'BEGIN{lo=(a<b?a:b); hi=(a>b?a:b); exit !(hi>2*lo)}'; then
        flag="  ✖ PLAY-REJECT: aspect > 2:1"
        violations=$((violations + 1))
      fi
    fi
    printf '   %-10s  %s%s\n' "$dims" "${f#$REPO_ROOT/}" "$flag"
  done < <(find "$IOS_SHOTS" "$AND_META_ROOT" -name '*.png' 2>/dev/null | sort)

  if (( violations > 0 )); then
    warn "$violations Android frame(s) exceed Play's 2:1 aspect limit and will be REJECTED — use a <= 2:1 phone AVD (see ANDROID_DEVICES) and re-run."
  fi
}

case "$MODE" in
  ios)     capture_ios ;;
  android) capture_android ;;
  all)     capture_ios; capture_android ;;
  *)       die "Unknown mode '$MODE' (use: ios | android | all)" ;;
esac

report_dimensions

# Human-readable list of the locales just captured (fastlane dir names).
LOCALE_DIRS=("${LOCALES[@]%%|*}")
locale_csv="$(IFS=,; printf '%s' "${LOCALE_DIRS[*]}")"

cat <<EOF

$(printf '\033[1;32m✓ Screenshots captured for: %s\033[0m' "${LOCALE_DIRS[*]}")

Review the PNGs before uploading (one folder per language):
  iOS:     ios/fastlane/screenshots/{$locale_csv}/
  Android: android/fastlane/metadata/android/{$locale_csv}/images/{phone,tenInch}Screenshots/

Then upload (needs store credentials — see tool/screenshots/README.md):
  iOS:     (cd ios     && bundle exec fastlane ios     upload_screenshots)
  Android: (cd android && bundle exec fastlane android upload_screenshots)
EOF
