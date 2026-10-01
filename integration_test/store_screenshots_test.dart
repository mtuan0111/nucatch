import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screen_walkthrough.dart';

/// Store-listing screenshot capture (App Store + Play Store).
///
/// This is NOT a pass/fail test — it's the source of the marketing frames
/// uploaded to both stores. It reuses the exact same navigation/seeding engine
/// as the post-upgrade smoke suites ([runScreenWalkthrough] in
/// `screen_walkthrough.dart`), but with three store-specific behaviours:
///
///  1. `nativeViewport: true` — no viewport override, so each frame comes out at
///     the real simulator/emulator's native pixel resolution (App Store Connect
///     requires exact per-device dimensions; `deliver` maps a PNG to a display
///     type by its resolution).
///  2. `seedDemoData: true` — the leaderboard is swapped for a curated demo one
///     so no real player's username reaches a public frame. Combined with the
///     walkthrough already running signed-out (it clears prefs before
///     `app.main()`, so the `Signed in as …` row never shows), this is how
///     the "redact sensitive information" requirement is met — by construction.
///  3. `captureOnly: …` — only the curated marketing subset below is written
///     (Play caps at 8 screenshots per device; App Store allows 10). Every other
///     screen is still navigated to and asserted, just not captured.
///
/// Run per device via `tool/screenshots/capture.sh`, which drives it with
/// `test_driver/screenshot_driver.dart` (that driver writes each screenshot's
/// bytes to `$NUCATCH_SHOT_DIR/<name>.png`). Do NOT run it under a plain
/// `flutter test` — `takeScreenshot` needs the `flutter drive` driver to
/// receive the bytes.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures store screenshots of the main screens', (tester) async {
    await runScreenWalkthrough(
      tester,
      binding,
      landscape: false,
      nativeViewport: true,
      seedDemoData: true,
      // Base names (the part after the 'portrait_' prefix). Keep ≤ 8 for Play.
      captureOnly: const {
        '01_home',
        '05_select_play_mode',
        '07_play_screen',
        '08_game_over',
        '04_leaderboard',
        '09_combat_setup',
        '12_combat_play',
        '13_combat_game_end',
      },
    );
  });
}
