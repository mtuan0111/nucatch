# Store screenshots (App Store + Play Store)

Automated, privacy-safe marketing screenshots for both stores, at each store's
required device sizes, driven by Fastlane.

## How it works

| Stage | What runs | Where |
|---|---|---|
| **Capture** | A Flutter `integration_test` (`integration_test/store_screenshots_test.dart`) navigates the main screens and calls `binding.takeScreenshot()`, driven by `flutter drive` + `test_driver/screenshot_driver.dart`. Run once per device size. | `tool/screenshots/capture.sh` |
| **Organize** | The script sorts the raw PNGs into the folder layouts Fastlane uploads from. | same script |
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

| Store | Device | Simulator / AVD (default) | Native px |
|---|---|---|---|
| iOS | 6.7" iPhone | `iPhone 13 Pro Max` | 1284 × 2778 |
| iOS | 13" iPad | `iPad Pro 13-inch (M4)` | 2064 × 2752 |
| Android | phone | `Pixel_7_Pro` AVD | phone bucket |
| Android | 10" tablet | `Pixel_Tablet` AVD | tenInch bucket |

The **same** test runs on each device — the store run never overrides the
viewport (`nativeViewport: true`), so each device renders at its native
resolution and the wide devices naturally show nucatch's iPad/tablet layouts. To
change devices, edit `IOS_DEVICES` / `ANDROID_DEVICES` at the top of
`capture.sh`.

> The App Store accepts a 6.7" iPhone upload (iPhone 13 Pro Max, 1284×2778) for
> the iPhone slot and derives smaller sizes from it; the 13" iPad covers the iPad
> slot. If App Store Connect asks specifically for a **6.9"** iPhone, swap the
> `iphone_6_7` entry for `iPhone 16 Pro Max` (1320×2868) in `capture.sh`. Android
> requires phone screenshots; the 10" tablet set is needed to be featured on
> tablets.

## Prerequisites

- Flutter (already set up for this repo).
- **iOS:** Xcode + the simulators named above (Xcode ▸ Settings ▸ Components, or Devices window).
- **Android:** Android SDK platform-tools (`adb`) + AVDs named above (Android Studio ▸ Device Manager). `emulator` on `PATH` lets the script boot them for you; otherwise start the AVD yourself first.
- Fastlane gems: `(cd ios && bundle install)` and `(cd android && bundle install)`.

## 1. Capture

```bash
tool/screenshots/capture.sh all      # iOS + Android
tool/screenshots/capture.sh ios      # iOS only
tool/screenshots/capture.sh android  # Android only

KEEP_DEVICES=1 tool/screenshots/capture.sh ios   # leave sims/emulators running
```

Raw per-device PNGs land in `build/screenshots/<device>/` (gitignored). The
script then copies them into the upload folders (stripping the `portrait_`
prefix) and prints each frame's dimensions.

### Review before uploading

```
ios/fastlane/screenshots/en-US/                     # iPhone + iPad (deliver picks size by resolution)
android/fastlane/metadata/android/en-US/images/phoneScreenshots/
android/fastlane/metadata/android/en-US/images/tenInchScreenshots/
```

Open them and confirm: all screens rendered, dimensions match the table above,
and only demo content is visible (demo leaderboard, no signed-in email).

## 2. Credentials (only needed to upload)

**iOS — App Store Connect API key** (App Store Connect ▸ Users and Access ▸ Integrations ▸ App Store Connect API):

```bash
export ASC_KEY_ID="XXXXXXXXXX"
export ASC_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ASC_KEY_FILEPATH="/absolute/path/to/AuthKey_XXXXXXXXXX.p8"
```

**Android — Google Play service account** (Play Console ▸ Setup ▸ API access ▸ create a
service account with the *Release* permission, download its JSON):

```bash
export SUPPLY_JSON_KEY="/absolute/path/to/play-service-account.json"
```

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
