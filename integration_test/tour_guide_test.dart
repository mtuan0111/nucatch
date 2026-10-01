import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_core/skeleton_core.dart' show PreferencesKey;

import 'package:nucatch/main.dart' as app;
import 'package:nucatch/helpers/const.dart' show KeyboardOption;
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/services/ai_greeting_service.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:nucatch/services/fcm_service.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_play_screen.dart';

/// Full walkthrough of the two-layer onboarding tour: the coarse, dialog-based
/// main-menu tour (`skeleton_core`'s `TourBloc`/`GlobalTourWrapper`) followed
/// by the fine-grained in-game rule tutorial (`TutorialCubit` +
/// `TutorialOverlay`), which drives three real game modes — Regular,
/// Pick Right, and Combat — across four real screens.
///
/// Deliberately in its own single-test file, same reasoning as
/// `screen_walkthrough.dart`: `app.main()` sets up process-wide singletons
/// that don't fully tear down between calls within one test binary.
///
/// Unlike `screen_walkthrough.dart` (which marks `has_completed_tour` true
/// up front so the tour never steals a tap), this test deliberately leaves
/// it unset so the tour auto-starts, and drives every step of it for real —
/// including letting real timers expire, real lives get lost, and a real
/// combat match play out to a real win, exactly as a first-time player would
/// experience it.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full tour: menu walkthrough + in-game rule tutorial',
      (tester) async {
    void step(String name) => dev.log('TEST_STEP: $name');

    Future<void> doWait(double seconds) async {
      final ticks = (seconds * 2).ceil();
      for (int i = 0; i < ticks; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
    }

    Future<bool> waitFor(Finder finder, {int maxSeconds = 20}) async {
      for (int i = 0; i < maxSeconds * 2; i++) {
        if (finder.evaluate().isNotEmpty) return true;
        await tester.pump(const Duration(milliseconds: 500));
      }
      return finder.evaluate().isNotEmpty;
    }

    /// Taps [finder], tolerating on-device flakiness — a present-and-visible
    /// match has intermittently failed to register a tap on this exact
    /// device/environment before (see `screen_walkthrough.dart`'s identical
    /// helper), so this retries a few times rather than trusting one tap.
    Future<void> tapFinder(Finder finder, String debugLabel,
        {int maxSeconds = 20}) async {
      Object? lastError;
      for (int attempt = 0; attempt < 4; attempt++) {
        final found = await waitFor(finder, maxSeconds: maxSeconds);
        if (found) {
          try {
            await tester.ensureVisible(finder.first);
            await tester.pump(const Duration(milliseconds: 300));
            await tester.tap(finder.first, warnIfMissed: false);
            await doWait(1);
            return;
          } catch (e) {
            lastError = e;
          }
        } else {
          lastError = StateError('not found');
        }
        await tester.pump(const Duration(milliseconds: 500));
      }
      throw StateError('tap("$debugLabel") failed after retries: $lastError');
    }

    Future<void> tapText(String text, {int maxSeconds = 20}) =>
        tapFinder(find.text(text), text, maxSeconds: maxSeconds);

    /// Taps the tutorial card's "Next" button.
    Future<void> tapTutorialNext() => tapText('Next');

    /// Taps a specific key on whichever keypad (Regular's or Combat's) is
    /// currently on screen, via the shared `TourKeys.keypadKeys` — text
    /// alone is ambiguous since digits repeat across score/level displays.
    Future<void> tapKeypadKey(KeyboardOption option, String debugLabel) =>
        tapFinder(find.byKey(TourKeys.keypadKeys[option]!), debugLabel);

    Future<void> tapResetKey() =>
        tapFinder(find.byKey(TourKeys.resetKey), 'reset key');

    Future<void> tapPickRightButton(int index) => tapFinder(
        find.byKey(TourKeys.pickRightButtonKeys[index]),
        'pick-right button $index');

    FcmService.disablePermissionRequestForTest = true;
    AiGreetingService.disableForTest = true;
    CombatBleService.disableForTest = true;
    TourKeys.reset();

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Device / orientation / font-size come in via --dart-define so the whole
    // matrix (phone|ipad × portrait|landscape × min|max font) runs from this
    // one file. Defaults reproduce the original phone-portrait, default-font
    // behaviour exactly.
    const ipad = bool.fromEnvironment('IPAD', defaultValue: false);
    const landscape = bool.fromEnvironment('LANDSCAPE', defaultValue: false);
    const injectedFontSize = int.fromEnvironment('FONT_SIZE', defaultValue: -1);

    final portraitSize = ipad ? const Size(1640, 2360) : const Size(1080, 2400);
    step('forcing ${ipad ? 'ipad' : 'phone'} '
        '${landscape ? 'landscape' : 'portrait'} physical size');
    tester.view.physicalSize = landscape ? portraitSize.flipped : portraitSize;
    tester.view.devicePixelRatio = ipad ? 2.0 : 2.625;

    step('awaiting SharedPreferences.getInstance()');
    final prefs = await SharedPreferences.getInstance();
    step('clearing prefs');
    await prefs.clear();
    await prefs.setBool(PreferencesKey.IS_MUTED, true);
    if (injectedFontSize >= 0) {
      await prefs.setInt(PreferencesKey.FONT_SIZE, injectedFontSize);
    }
    // Deliberately NOT marking has_completed_tour — this test wants the
    // tour to actually auto-start, unlike screen_walkthrough.dart.

    step('calling app.main()');
    app.main();

    // ── Menu tour (dialog-based, 10 steps: welcome..about) ─────
    step('waiting for the tour to auto-start (Welcome dialog)');
    expect(await waitFor(find.text('Next'), maxSeconds: 20), isTrue,
        reason: 'the menu tour should auto-start for a first-time user');

    step('walking welcome -> about (9 taps of Next)');
    for (int i = 0; i < 9; i++) {
      await tapTutorialNext();
    }

    step('tapping Next on "about" to enter the in-game tutorial');
    await tapTutorialNext();

    // ── Regular arc ──────────────────────────────────────────
    step('waiting for PlayScreen (Regular arc)');
    expect(await waitFor(find.byType(PlayScreen), maxSeconds: 20), isTrue,
        reason: 'entering the tutorial should land on PlayScreen');

    step('R1 RegularWelcome: Next');
    await tapTutorialNext();
    step('R2 RegularLives: Next');
    await tapTutorialNext();
    step('R3 RegularMemorize: waiting for the real memorize phase to end');
    await doWait(4);
    step('R4 RegularTypeBack: tapping the "8" key');
    await tapKeypadKey(KeyboardOption.eight, '8');
    step('R5 RegularScoring: Next');
    await tapTutorialNext();
    step('R6 RegularTimer: waiting for the real ~1.5s timeout');
    await doWait(4);
    step('R6 result beat: Next');
    await tapTutorialNext();
    step('R7 RegularReset: tapping reset (always costs a life for real)');
    await tapResetKey();
    step('R8 RegularLevelUp: tapping the "2" key (real level-up)');
    await tapKeypadKey(KeyboardOption.two, '2');
    step('R8 result beat: Next');
    await tapTutorialNext();
    step('R9 RegularGameOver: waiting for the real ~1.5s timeout -> Game Over');
    await doWait(4);
    step('waiting for GameOverScreen');
    expect(await waitFor(find.byType(GameOverScreen), maxSeconds: 15), isTrue,
        reason: 'R9\'s seeded timeout should cause a real game over');
    step('R10 RegularWrapUp: Next (hands off into the Pick Right arc)');
    await tapTutorialNext();

    // ── Pick Right arc ───────────────────────────────────────
    step('waiting for PlayScreen (Pick Right arc)');
    expect(await waitFor(find.byType(PlayScreen), maxSeconds: 20), isTrue,
        reason: 'RegularWrapUp should hand off back to PlayScreen');

    step('P1 PickRightWelcome: Next');
    await tapTutorialNext();
    step('P2 PickRightOptions: Next');
    await tapTutorialNext();
    step('P3 PickRightCorrect: tapping the correct option');
    await tapPickRightButton(1);
    step('P3 result beat: Next');
    await tapTutorialNext();
    step('P4 PickRightWrong: tapping a decoy option (real life lost)');
    await tapPickRightButton(0);
    step('P4 result beat: Next');
    await tapTutorialNext();
    step('P5 PickRightTimer: waiting for the real ~1.2s timeout -> Game Over');
    await doWait(4);
    step('waiting for GameOverScreen');
    expect(await waitFor(find.byType(GameOverScreen), maxSeconds: 15), isTrue,
        reason: 'P5\'s seeded timeout should cause a real game over');
    step('P5 result beat: Next');
    await tapTutorialNext();
    step('P6 PickRightWrapUp: Next (hands off into the Combat arc)');
    await tapTutorialNext();

    // ── Combat arc ────────────────────────────────────────────
    // CombatModeSetupScreen is structurally always the base page of
    // CombatNav's Navigator, so it can flash for a frame before the
    // combat-arc entry gate promotes to CombatPlayingState — what matters
    // is that the player never has to interact with it or SetDifficultScreen,
    // which the wait below (landing directly on CombatPlayScreen with no
    // taps in between) already confirms.
    step('waiting for CombatPlayScreen');
    expect(await waitFor(find.byType(CombatPlayScreen), maxSeconds: 20), isTrue,
        reason: 'the combat arc should land directly on CombatPlayScreen');

    step('C1 CombatWelcome: Next');
    await tapTutorialNext();
    step('C2 CombatTurnOrder: Next');
    await tapTutorialNext();
    step('C3 CombatYourTurn: tapping the "4" key');
    await tapKeypadKey(KeyboardOption.four, '4');
    step('C4 CombatOpponentTurn: waiting for the scripted opponent turn');
    await doWait(4);
    step('C4 result beat: Next');
    await tapTutorialNext();
    step('C5 CombatOpponentLifeLost: waiting for the scripted opponent miss');
    await doWait(4);
    step('C5 result beat: Next');
    await tapTutorialNext();
    step('C6 CombatTimer: waiting for the real ~1.5s timeout');
    await doWait(4);
    step('C6 result beat: Next');
    await tapTutorialNext();
    step('C7 CombatWin: waiting for the scripted opponent to lose the match');
    await doWait(4);

    step('waiting for the real win to land');
    expect(
        find.text('Next').evaluate().isNotEmpty ||
            find.text('Finish').evaluate().isNotEmpty,
        isTrue,
        reason: 'the scripted match should end and hand back to the tutorial');
    step('C7 result beat: Next');
    if (find.text('Next').evaluate().isNotEmpty) {
      await tapTutorialNext();
    }

    step('C8 CombatWrapUp: Finish');
    await tapText('Finish');

    // ── Teardown ──────────────────────────────────────────────
    step('asserting a clean return to SelectPlayModeScreen');
    expect(await waitFor(find.byType(SelectPlayModeScreen), maxSeconds: 15),
        isTrue,
        reason: 'Finish should tear the tutorial down and return to the '
            'play-mode picker, matching TourCompleted()\'s usual landing spot');

    step('asserting no tutorial overlay is left behind');
    expect(find.text('Skip Tour'), findsNothing);

    step('done');
  });
}
