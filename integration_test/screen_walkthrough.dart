import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show MenuOption, CustomSliverAppBar, AnimatedButton, PreferencesKey;

import 'package:nucatch/main.dart' as app;
import 'package:nucatch/services/ai_greeting_service.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:nucatch/services/fcm_service.dart';
import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_mode_setup_screen.dart';
import 'package:nucatch/screens/menu_screens/player/host_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/join_room_screen.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';

/// Shared body for `screenshot_test.dart` (portrait) and
/// `screenshot_test_landscape.dart` (landscape). Walks every screen
/// reachable on a single device — main menu, solo mode, and the
/// pre-pairing slice of combat mode — confirming each one actually mounts
/// (via `find.byType`, not just "didn't crash") and taking a screenshot
/// along the way.
///
/// Deliberately kept in its OWN file, called from two single-test files
/// rather than two `testWidgets` bodies in one file: `app.main()` sets up
/// process-wide singletons (Firebase, GlobalKey caches, etc.) that don't
/// fully tear down between calls within the same test binary. Two separate
/// files each get their own fresh `flutter test` process, which sidesteps
/// that whole class of bug instead of working around it. (Pattern carried
/// over from the sibling o_an_quan project's integration_test suite, which
/// hit this on-device.)
///
/// Out of reach for a single device, and NOT covered here:
/// - `CombatPlayScreen` / `CombatGameEndScreen` / `CombatRestartConfirmationScreen`
///   (needs an actual BLE peer to pair with and reach `CombatPlayingState`).
/// - `GameOverScreen` (only reached by actually losing a real game — too
///   slow/nondeterministic to force here).
/// - `TopScoreDetailScreen` (only reached by tapping a real leaderboard
///   entry — the dev Firestore project has no seeded data to tap on).
Future<void> runScreenWalkthrough(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding, {
  required bool landscape,
}) async {
  void step(String name) => dev.log('TEST_STEP: $name');
  final prefix = landscape ? 'landscape_' : 'portrait_';

  Future<void> doWait(int seconds) async {
    for (int i = 0; i < seconds * 2; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
  }

  /// Polls until [finder] resolves to at least one widget, or [maxSeconds]
  /// elapses. On-device, widget appearance has repeatedly proven to lag
  /// behind what a single check would suggest — a generous, shared retry
  /// budget absorbs that instead of every call site growing its own
  /// bespoke one-off polling loop.
  Future<bool> waitFor(Finder finder, {int maxSeconds = 8}) async {
    for (int i = 0; i < maxSeconds * 2; i++) {
      if (finder.evaluate().isNotEmpty) return true;
      await tester.pump(const Duration(milliseconds: 500));
    }
    return finder.evaluate().isNotEmpty;
  }

  Future<void> shot(String name) async {
    try {
      await binding.takeScreenshot(name);
      dev.log('Captured screenshot: $name');
    } catch (e) {
      // Screenshot capture is a nice-to-have here, not the point of this
      // test — a platform/emulator quirk taking a screenshot shouldn't fail
      // the "does this screen render" assertion that already ran above it.
      dev.log('Screenshot "$name" failed (non-fatal): $e');
    }
  }

  /// Dismisses the app-wide tour's "Welcome" overlay if it's showing right
  /// now. TourBloc's auto-start decision is async (a delay after its own
  /// SharedPreferences read resolves) — it can land *after* the one-time
  /// startup check clears, anywhere up to a couple of screens into the
  /// walkthrough, so callers that are about to tap something check-and-clear
  /// immediately beforehand rather than trusting a single check made
  /// minutes of test-time earlier.
  Future<void> dismissStrayTourOverlay() async {
    if (find.text('Skip Tour').evaluate().isNotEmpty) {
      await tester.tap(find.text('Skip Tour').first);
      await doWait(2);
    }
  }

  /// Taps [finder], tolerating on-device flakiness: a present-and-visible
  /// match has intermittently failed to register a tap here — confirmed via
  /// a full tree dump where the target existed, fully built, correctly
  /// labelled, and the finder still came up with 0 widgets a beat later.
  /// `ensureVisible` (in case it's off the bottom of a scroll view) plus a
  /// retry loop absorbs that instead of every call site growing its own
  /// bespoke workaround.
  Future<void> tapFinder(Finder finder, String debugLabel) async {
    Object? lastError;
    for (int attempt = 0; attempt < 4; attempt++) {
      // Re-checked on every attempt, not just once up front: TourBloc's
      // auto-start decision is async and can land a tour overlay in
      // between retries, silently swallowing the tap underneath it.
      await dismissStrayTourOverlay();
      bool found = await waitFor(finder);
      if (!found) {
        // In landscape the much shorter viewport means later menu items
        // (e.g. "ABOUT") sit inside a lazily-built SliverList below the
        // fold — they don't exist in the tree at all until scrolled into
        // range, so plain waitFor() never finds them. scrollUntilVisible
        // builds as it scrolls, which a bare find can't. Screens without a
        // Scrollable ancestor (none of our targets need this) just fail
        // this attempt and fall through to the retry loop.
        try {
          await tester.scrollUntilVisible(
            finder,
            200,
            scrollable: find.byType(Scrollable).first,
          );
          found = finder.evaluate().isNotEmpty;
        } catch (e) {
          debugPrint('TEST_DEBUG scrollUntilVisible("$debugLabel") '
              'attempt $attempt failed: $e');
        }
      }
      if (found) {
        try {
          await tester.ensureVisible(finder.first);
          await tester.pump(const Duration(milliseconds: 300));
          await tester.tap(finder.first, warnIfMissed: false);
          return;
        } catch (e) {
          lastError = e;
          debugPrint('TEST_DEBUG tap("$debugLabel") attempt $attempt failed: $e');
        }
      }
      await tester.pump(const Duration(milliseconds: 500));
    }
    throw StateError('tap("$debugLabel") failed after retries: $lastError');
  }

  Future<void> tapText(String text) => tapFinder(find.text(text), text);

  /// Taps a top-level menu option by its visible (uppercase) label — the
  /// menu buttons are built dynamically from `menuArray()` with no
  /// per-button keys, so text is the only stable way to find them.
  Future<void> tapMenuOption(MenuOption option, String upperCaseLabel) async {
    await tapText(upperCaseLabel);
  }

  /// Taps an `OptionCard` by its trailing icon button rather than its title
  /// text or the card as a whole — both of those reliably failed to
  /// register a tap on-device (no thrown error, no warning; the tap just
  /// landed somewhere not wired to `onTap`), most likely because
  /// `OptionCard`'s title/description render as disabled `CustomElevatedButton`
  /// badges (no `onPressed`) that sit in front of the card's own
  /// `GestureDetector` and absorb the tap instead of passing it through.
  /// The icon is rendered by a real `AnimatedButton` with `onPressed: onTap`
  /// wired directly — the same kind of control the in-game menu/back button
  /// taps elsewhere in this walkthrough already tap reliably.
  Future<void> tapOptionCard(FaIconData iconData, String debugLabel) =>
      tapFinder(
        find.byWidgetPredicate((w) => w is FaIcon && w.icon == iconData.data),
        debugLabel,
      );

  /// Taps the app's real back button. Every screen here uses
  /// `CustomSliverAppBar(onBackPressed: ...)`, which renders as a
  /// `FontAwesomeIcons.chevronLeft` `FaIcon` inside a `CustomElevatedButton`
  /// — never Flutter's stock `BackButton` widget, so `find.byType(BackButton)`
  /// would silently find nothing.
  Future<void> tapBack() async {
    final appBarFinder = find.byType(CustomSliverAppBar);
    expect(appBarFinder, findsWidgets,
        reason: 'expected a CustomSliverAppBar to be visible');
    final backIcon = find.descendant(
      of: appBarFinder.first,
      matching: find.byWidgetPredicate(
        (w) => w is FaIcon && w.icon == FontAwesomeIcons.chevronLeft.data,
      ),
    );
    expect(backIcon, findsWidgets,
        reason: 'expected the in-app back button to be visible');
    await tester.tap(backIcon.first, warnIfMissed: false);
    await doWait(2);
  }

  FcmService.disablePermissionRequestForTest = true;
  AiGreetingService.disableForTest = true;
  CombatBleService.disableForTest = true;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  // 1080x2400 physical pixels at a 2.625 device pixel ratio is a real,
  // common phone profile (the same physical resolution class as the test
  // device) — logical size works out to ~411x914, matching what the app's
  // layout code actually assumes. A devicePixelRatio of 1.0 with these
  // physical dimensions (an earlier version of this test used that) makes
  // Flutter treat 1080x2400 as *logical* pixels — over 2.5x wider/taller
  // than the app is designed for, so every fixed-size button/icon renders
  // far smaller relative to the screen than it does on a real device, to
  // the point that unrelated overlays (the quick-settings volume/vibration
  // buttons) visually and functionally overlapped the in-game menu button
  // and silently absorbed taps meant for it.
  const devicePixelRatio = 2.625;
  if (landscape) {
    // Swapped width/height of the portrait profile rather than a synthetic
    // square, so layout code that branches on aspect ratio behaves the same
    // way it would on an actual rotated device.
    step('forcing landscape physical size');
    tester.view.physicalSize = const Size(2400, 1080);
    tester.view.devicePixelRatio = devicePixelRatio;
  } else {
    step('forcing portrait physical size');
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = devicePixelRatio;
  }

  // Prefs must be written BEFORE app.main() — skeleton_core's TourBloc
  // reads `has_completed_tour` asynchronously from its constructor, right
  // as the widget tree is first built. Writing this after app.main() races
  // that read: TourBloc often wins, decides this is a first launch, and
  // auto-starts the tour — whose spotlight overlay then silently absorbs
  // the next tap intended for a menu button.
  step('awaiting SharedPreferences.getInstance()');
  final prefs = await SharedPreferences.getInstance();
  step('clearing prefs');
  await prefs.clear();
  await prefs.setBool(PreferencesKey.IS_MUTED, true);
  // This test is about raw screen navigation, not the tour itself — marking
  // it complete up front means the tour never auto-starts and steals the
  // first tap.
  await prefs.setBool('has_completed_tour', true);

  step('calling app.main()');
  app.main();

  step('waiting for home screen');
  // Wait for the home screen (splash/init can take a moment).
  await waitFor(find.text('ABOUT'), maxSeconds: 30);

  step('checking for stray tour overlay');
  for (int i = 0; i < 10; i++) {
    if (find.text('Skip Tour').evaluate().isNotEmpty) {
      step('dismissing stray tour overlay');
      await tester.tap(find.text('Skip Tour').first);
      await doWait(2);
      break;
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  // ── Home ──────────────────────────────────────────────────
  step('asserting MenuScreen (home)');
  expect(find.byType(MenuScreen), findsOneWidget);
  await shot('${prefix}01_home');

  // ── About ─────────────────────────────────────────────────
  step('tapping About');
  await tapMenuOption(MenuOption.about, 'ABOUT');
  await doWait(2);
  step('asserting AboutScreen');
  expect(find.byType(AboutScreen), findsOneWidget,
      reason: 'About should still be reachable from the menu');
  await shot('${prefix}02_about');
  step('tapping back from About');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from About should return to the menu');

  // ── Settings ──────────────────────────────────────────────
  step('tapping Settings');
  await tapMenuOption(MenuOption.setting, 'SETTING');
  await doWait(2);
  step('asserting SettingScreen');
  expect(find.byType(SettingScreen), findsOneWidget,
      reason: 'Settings should still be reachable from the menu');
  await shot('${prefix}03_settings');
  step('tapping back from Settings');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from Settings should return to the menu');

  // ── Leaderboard ───────────────────────────────────────────
  step('tapping Top Score');
  await tapMenuOption(MenuOption.topScore, 'TOP SCORE');
  await doWait(3);
  step('asserting TopScoreScreen');
  expect(find.byType(TopScoreScreen), findsOneWidget,
      reason: 'Leaderboard should still be reachable from the menu');
  await shot('${prefix}04_leaderboard');
  step('tapping back from Leaderboard');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from the leaderboard should return to the menu');

  // ── Select play mode ──────────────────────────────────────
  step('tapping Start');
  await tapMenuOption(MenuOption.start, 'START');
  await doWait(2);
  step('asserting SelectPlayModeScreen');
  expect(find.byType(SelectPlayModeScreen), findsOneWidget,
      reason: 'Start should reach the play-mode picker');
  await shot('${prefix}05_select_play_mode');

  // ── Solo: difficulty picker ───────────────────────────────
  step('tapping Solo Mode');
  await tapOptionCard(FontAwesomeIcons.user, 'Solo Mode');
  await doWait(2);
  step('asserting SetDifficultScreen');
  expect(find.byType(SetDifficultScreen), findsOneWidget,
      reason: 'Solo Mode should reach the difficulty picker');
  await shot('${prefix}06_set_difficulty');

  // ── Solo: play screen ─────────────────────────────────────
  // Tapping a difficulty card both sets the difficulty AND starts the game
  // in one action — there's no separate "start" button in this flow.
  step('tapping Easy Mode');
  await tapOptionCard(FontAwesomeIcons.faceSmileBeam, 'Easy Mode');

  step('waiting for PlayScreen to mount');
  // The page transition into PlayScreen (SoloNav pushing it after
  // TurnBloc's SetDifficulty -> Start chain resolves) hasn't necessarily
  // happened yet the instant the tap above returns — wait for the screen
  // itself before touching anything that only exists inside it.
  await waitFor(find.byType(PlayScreen), maxSeconds: 10);
  step('waiting for intro countdown to clear');
  final countdownOverlay = find.byType(CountdownOverlay);
  for (int i = 0; i < 20; i++) {
    if (countdownOverlay.evaluate().isEmpty) break;
    await tester.pump(const Duration(milliseconds: 500));
  }
  step('asserting PlayScreen');
  expect(find.byType(PlayScreen), findsOneWidget,
      reason: 'Starting a game should reach the play screen');
  await shot('${prefix}07_play_screen');

  // Leave via the real exit flow (menu key -> confirmation dialog -> Yes),
  // the same path a player actually uses. Scoped to PlayScreen's own
  // subtree since the menu button here is a FontAwesomeIcons.bars icon
  // inside the on-screen keyboard, not a chevron/back button.
  //
  // Tapped as soon as the countdown clears, with no extra idle wait
  // beforehand: this is a live, timed game — sitting idle for several more
  // seconds here risked the per-turn timer running out and losing enough
  // lives to trigger a real game over, which swaps GameOverScreen in as
  // the active page and leaves PlayScreen (and this exact tap) absorbed
  // behind it, matching exactly the "tap lands, nothing happens, no error"
  // symptom this step used to hit.
  step('tapping the in-game menu button');
  final playScreenMenuIcon = find.descendant(
    of: find.byType(PlayScreen),
    matching: find.byWidgetPredicate(
      (w) => w is FaIcon && w.icon == FontAwesomeIcons.bars.data,
    ),
  );
  expect(playScreenMenuIcon, findsWidgets,
      reason: 'expected PlayScreen\'s own menu button to be visible');
  // Tap the enclosing AnimatedButton rather than the small FaIcon glyph
  // itself, for a larger and definitely-interactive hit target.
  final playScreenMenuButton = find.ancestor(
    of: playScreenMenuIcon.first,
    matching: find.byType(AnimatedButton),
  );
  expect(playScreenMenuButton, findsWidgets,
      reason: 'expected the menu FaIcon to be inside an AnimatedButton');
  await tester.tap(playScreenMenuButton.first, warnIfMissed: false);
  await doWait(2);
  step('waiting for exit-confirmation dialog');
  // The dialog may briefly show a LoadingWidget spinner instead of the
  // Yes/No buttons while TurnRecordedListBloc's score-ranking lookup
  // resolves (a real Firestore round trip in this environment) — give it
  // more room than the default budget before concluding it's stuck.
  await waitFor(find.text('Yes'), maxSeconds: 20);
  expect(find.text('Yes'), findsWidgets,
      reason: 'the exit-confirmation dialog should be showing');
  step('tapping Yes to confirm exit');
  await tapText('Yes');
  await doWait(2);
  step('asserting back at MenuScreen after exit');
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'confirming exit should return to the main menu');

  // ── Combat: setup ─────────────────────────────────────────
  step('tapping Start (for combat)');
  await tapMenuOption(MenuOption.start, 'START');
  await doWait(2);
  expect(find.byType(SelectPlayModeScreen), findsOneWidget);
  step('tapping Combat Mode');
  await tapOptionCard(FontAwesomeIcons.userGroup, 'Combat Mode');
  await doWait(2);
  step('asserting CombatModeSetupScreen');
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'Combat Mode should reach the combat setup screen');
  await shot('${prefix}08_combat_setup');

  // ── Combat: host room (no peer — just confirms it renders) ─
  step('tapping Create Room');
  await tapOptionCard(FontAwesomeIcons.userPlus, 'Create Room');
  await doWait(3);
  step('asserting HostRoomScreen');
  expect(find.byType(HostRoomScreen), findsOneWidget,
      reason: 'Create Room should reach the host room screen');
  await shot('${prefix}09_combat_host_room');
  step('tapping back from host room');
  await tapBack();
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'back from hosting should return to combat setup');

  // ── Combat: join room (no peer — just confirms it renders) ─
  step('tapping Join Room');
  await tapOptionCard(FontAwesomeIcons.rightToBracket, 'Join Room');
  await doWait(3);
  step('asserting JoinRoomScreen');
  expect(find.byType(JoinRoomScreen), findsOneWidget,
      reason: 'Join Room should reach the join room screen');
  await shot('${prefix}10_combat_join_room');
  step('tapping back from join room');
  await tapBack();
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'back from joining should return to combat setup');

  // ── Back out to the main menu ─────────────────────────────
  step('tapping back from combat setup');
  await tapBack(); // combat setup -> select play mode
  expect(find.byType(SelectPlayModeScreen), findsOneWidget);
  step('tapping back from select play mode');
  await tapBack(); // select play mode -> menu
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'should be able to navigate all the way back to the menu');
  step('done');
}
