# Store screenshots (App Store + Play Store)

Automated, privacy-safe marketing screenshots for both stores, at each store's
required device sizes, in each marketing language (English + Vietnamese), driven
by Fastlane.

## How it works

| Stage | What runs | Where |
|---|---|---|
| **Capture** | A Flutter `integration_test` (`integration_test/store_screenshots_test.dart`) navigates the main screens and calls `binding.takeScreenshot()`, driven by `flutter drive` + `test_driver/screenshot_driver.dart`. Run once per device size **× localization** (`--dart-define=NUCATCH_LOCALE=<code>` pins the UI language and the widget-finder language). | `tool/screenshots/capture.sh` |
| **Organize** | The script sorts the raw PNGs into the per-language folder layouts Fastlane uploads from. | same script |
| **Upload** | `deliver` (iOS) / `supply` (Android), media-only, no binary, **no submit for review**. | `fastlane … upload_screenshots` |

Fastlane's native `snapshot`/`screengrab` are **not** used — they drive native
XCUITest/Espresso, which can't see into Flutter's single-canvas UI. The Flutter
`integration_test` path above is the equivalent that actually works.

The store capture **reuses the same walkthrough engine**
(`integration_test/screen_walkthrough.dart`) as the post-upgrade smoke suites;
`store_screenshots_test.dart` just calls it with `nativeViewport: true`,
`seedDemoData: true`, and a curated `captureOnly` subset.

### Sensitive information is redacted by construction

nucatch has no mock-service layer, so the store run boots the **real** app — but
it's shaped so no real user data can reach a frame:

- The walkthrough **clears `SharedPreferences` and never signs in**, so the
  Settings "Signed in as …" row (`account_setting_row.dart`) never shows — no
  email/account label in frame.
- The **leaderboard is swapped for a curated demo one** before it's captured:
  `store_screenshots_test.dart` passes `seedDemoData: true`, which dispatches
  `SeedDemoLeaderboard` (see `turn_recorded_list_bloc.dart`) so only invented
  usernames + scores render — never real players' `playedUsername` from
  Firestore.
- The device clock/battery/carrier are overridden to a clean marketing state
  (9:41, full battery/signal) by the capture script.

If you add a screen that surfaces other user data, redact it the same way —
prefer construction-time (seed/sign-out) over post-capture blur.

## Device matrix (store minimum)

| Store | Device | Simulator / AVD (default) | Native px | Aspect |
|---|---|---|---|---|
| iOS | 6.7" iPhone | `iPhone 13 Pro Max` | 1284 × 2778 | — |
| iOS | 13" iPad | `iPad Pro 13-inch (M4)` | 2064 × 2752 | — |
| Android | phone | `flutter_emulator` AVD (device "pixel") | 1080 × 1920 | 1.78:1 ✓ |
| Android | 10" tablet | `Pixel_Tablet` AVD | 2560 × 1600 | 1.6:1 ✓ |

The **same** test runs on each device — the store run never overrides the
viewport (`nativeViewport: true`), so each device renders at its native
resolution and the wide devices naturally show nucatch's iPad/tablet layouts. To
change devices, edit `IOS_DEVICES` / `ANDROID_DEVICES` at the top of
`capture.sh`.

> **Android phone AVD must be ≤ 2:1.** Google Play rejects any screenshot whose
> long side is more than twice its short side. Most modern phones are 19.5:9 or
> 20:9 (~2.17:1), so a full-res portrait grab from a `Pixel_7_Pro` (1440×3120)
> is **rejected**. Use `flutter_emulator` (device "pixel", 1080×1920 = 1.78:1,
> the default — created by `flutter emulators --create`) or a custom 1080×2160
> (2.0:1) AVD. `capture.sh`'s dimension report flags any frame that slips over
> 2:1. The `Pixel_Tablet` (1.6:1) is already fine.

> **iPhone size.** This repo captures the **6.7"** iPhone (iPhone 13 Pro Max,
> 1284×2778). Apple now treats **6.9"** (iPhone 16 Pro Max, 1320×2868) as the
> canonical iPhone size and 6.7" as a fallback tier — if App Store Connect
> insists on 6.9", swap the `iphone_6_7` entry for `iPhone 16 Pro Max` in
> `capture.sh` and re-run. The 13" iPad covers the iPad slot.

## Localizations

The script captures a full set per language, defined by the `LOCALES` matrix at
the top of `capture.sh` (format `fastlane_dir|dart_locale`):

| Language | Fastlane folder | `NUCATCH_LOCALE` |
|---|---|---|
| English (US) | `en-US` | `en` |
| Vietnamese | `vi` | `vi` |

Each device boots once and is then driven once per locale (booting is the slow
part). `--dart-define=NUCATCH_LOCALE=<code>` is passed to `flutter drive`; the
walkthrough seeds it onto `PreferencesKey.LOCALE` before `app.main()` so the app
UI is pinned to that language, and it finds every navigation button by its
translated label (loaded from `CoreLocalizations`/`AppLocalizations` for the
locale — see `screen_walkthrough.dart`). To add a language, add a row to
`LOCALES` **and** to `languages [...]` in `ios/fastlane/Deliverfile`; the folder
name must match the store's locale code (`ja` for Japanese, etc.).

## Prerequisites

- Flutter (already set up for this repo).
- **iOS:** Xcode + the simulators named above (Xcode ▸ Settings ▸ Components, or Devices window).
- **Android:** Android SDK platform-tools (`adb`) + AVDs named above (Android Studio ▸ Device Manager). The phone AVD **must be ≤ 2:1** (`Pixel_2` = 1080×1920 is the default). `emulator` on `PATH` lets the script boot them for you; otherwise start the AVD yourself first.
- Fastlane gems: `(cd ios && bundle install)` and `(cd android && bundle install)`.

## 1. Capture

```bash
tool/screenshots/capture.sh all      # iOS + Android
tool/screenshots/capture.sh ios      # iOS only
tool/screenshots/capture.sh android  # Android only

KEEP_DEVICES=1 tool/screenshots/capture.sh ios   # leave sims/emulators running
```

Raw per-device/-locale PNGs land in `build/screenshots/<device>_<locale>/`
(gitignored). The script then copies them into the per-language upload folders
(stripping the `portrait_` prefix), prints each frame's dimensions, and flags any
Android frame that exceeds Play's 2:1 aspect limit.

### Captioned store frames

Each copied shot is composed into a captioned marketing frame by
`frame.swift` (compiled with `swiftc` into `build/screenshots/frame` on first
use): NuCatch's green → teal gradient, a headline in Baloo Bhai ExtraBold, and
the screenshot below it with rounded corners and a shadow, at the raw shot's
exact pixel size (so the stores still map it to the right device slot). It's
the same treatment as the Hanoi Tower listings.

The headlines live in `caption_for` in `capture.sh`, one set per language
(`en`, `vi`), keyed by shot name. A shot with no caption is copied unframed.
To change a headline, edit it there and re-run. To skip framing entirely:

```bash
FRAME=0 tool/screenshots/capture.sh android
```

### Review before uploading

One folder per language (`en-US`, `vi`):

```
ios/fastlane/screenshots/en-US/                     # iPhone + iPad (deliver picks size by resolution)
ios/fastlane/screenshots/vi/
android/fastlane/metadata/android/en-US/images/{phone,tenInch}Screenshots/
android/fastlane/metadata/android/vi/images/{phone,tenInch}Screenshots/
```

Open them and confirm: all screens rendered, each language shows its own copy
(no English leaking into the Vietnamese set), dimensions match the table above
(Android ≤ 2:1), and only demo content is visible (demo leaderboard, no signed-in
email).

## 2. Credentials (only needed to upload)

The upload lanes read the same keys as the release lanes, from the git-ignored
`.env.fastlane` at the repo root (`SUPPLY_JSON_KEY` for Play; `ASC_KEY_ID`,
`ASC_ISSUER_ID`, `ASC_KEY_FILEPATH` for App Store Connect):

```bash
cp .env.fastlane.example .env.fastlane   # then fill it in
(cd android && bundle exec fastlane check_env)
(cd ios     && bundle exec fastlane check_env)
```

How to create each key: `docs/DEPLOYMENT.md` §4. Exported environment variables
still work and take precedence over the file.

> The Play app must already exist with at least one release — `supply` can update
> an existing listing's screenshots but can't bootstrap a brand-new app.

## 3. Upload (media only — never submits for review)

```bash
(cd ios     && bundle exec fastlane ios     upload_screenshots)
(cd android && bundle exec fastlane android upload_screenshots)
```

Both lanes upload **only** screenshots — no app binary, no metadata/changelogs,
and `submit_for_review: false`. Submitting the listing for review stays a manual
step you take in App Store Connect / Play Console.

> **Not covered here:** the Play **feature graphic** (1024×500) is *required* for
> a Play listing but is a designed marketing banner, not a captured screenshot —
> produce it separately and upload it in the Play Console. The App Store needs no
> feature graphic.

## Adding / changing a screen

The screens are captured by `integration_test/screen_walkthrough.dart` (shared
with the smoke suites). To include a new screen in the store set:

1. Make sure the walkthrough navigates to it and calls `shot('NN_name')`.
2. Add `'NN_name'` to the `captureOnly` set in
   `integration_test/store_screenshots_test.dart`. Keep the numeric prefix — it
   sets the display order in both stores — and keep the total ≤ 8 (Play's max;
   App Store allows 10).

## Troubleshooting

- **Android: taps stop working after the first screenshot.** The one-time
  `convertFlutterSurfaceToImage()` (already called in the walkthrough) normally
  lets interaction continue; if a device misbehaves, split the flow so each
  screen re-boots the app (slower but bulletproof).
- **`deliver`/`supply` can't authenticate.** Re-check the env vars in step 2;
  without them the Android lane stops before any network call (by design) and
  the iOS lane falls back to interactive Apple ID login.
- **A simulator/AVD is "not found".** Create it (names must match exactly) or
  edit `IOS_DEVICES` / `ANDROID_DEVICES` in `capture.sh`.
