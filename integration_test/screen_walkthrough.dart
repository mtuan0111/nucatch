import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OffsetLayer, RenderParagraph;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show
        MenuOption,
        CustomSliverAppBar,
        PreferencesKey,
        MenuBloc,
        SelectOption,
        OptionCard,
        DeviceWrapper,
        AnimatedButton,
        AdMobBanner,
        CoreLocalizations,
        CustomElevatedButton;

import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/main.dart' as app;
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart'
    show GameEndReason;
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart'
    show SeedDemoLeaderboard;
import 'package:nucatch/helpers/const.dart' show KeyboardOption;
import 'package:nucatch/helpers/preferences_key.dart'
    show NucatchPreferencesKey;
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/services/ai_greeting_service.dart';
import 'package:nucatch/widgets/mode_card.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:nucatch/services/fcm_service.dart';
import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_mode_setup_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_game_end_screen.dart';
import 'package:nucatch/screens/menu_screens/player/host_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/join_room_screen.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';

/// Shared body for `screenshot_test.dart` (portrait) and
/// `screenshot_test_landscape.dart` (landscape). Walks every screen
/// reachable on a single device — main menu, solo mode, and combat mode —
/// confirming each one actually mounts (via `find.byType`, not just "didn't
/// crash") and taking a store-ready screenshot along the way. Screens that
/// only exist mid-game (Game Over, Combat Play, Combat Game End) are reached
/// by seeding an attractive, deterministic state directly onto the real
/// bloc — the same `SeedTutorialTurn`/`SeedTutorialCombat`/real end-game
/// events the in-game rule tutorial uses (see `tour_guide_test.dart`) —
/// rather than waiting on real timers or random gameplay, so the resulting
/// screenshots are reproducible run to run.
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
/// Still out of reach for a single device, and NOT covered here:
/// - `CombatRestartConfirmationScreen` — dead code today: nothing in the
///   app actually dispatches `CombatNavCubit.showRestartConfirmation()`.
/// - `TopScoreDetailScreen` (only reached by tapping a real leaderboard
///   entry — the dev Firestore project has no seeded data to tap on).
/// - `LevelSelectScreen` — dead code, not wired into any navigator.
Future<void> runScreenWalkthrough(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding, {
  required bool landscape,
  // Physical size/DPR default to the phone profile the two existing
  // (portrait/landscape) entry points already use — passing neither keeps
  // this function's behavior, including screenshot names, byte-identical
  // to before this parameterization existed.
  Size physicalSize = const Size(1080, 2400),
  double devicePixelRatio = 2.625,
  // '' keeps the existing 'portrait_'/'landscape_' screenshot names; the
  // iPad entry points pass 'ipad_' so their shots never collide with the
  // phone suite's.
  String devicePrefix = '',
  // Store-screenshot capture (`store_screenshots_test.dart`) passes true so the
  // app renders at the real simulator/emulator's native resolution — App Store
  // Connect requires exact per-device pixel dimensions, and `deliver` maps each
  // PNG to a display type by its resolution. The internal smoke-test callers
  // leave this false and keep forcing a fixed viewport as before.
  bool nativeViewport = false,
  // When non-null, only screenshots whose base name (the part after [prefix])
  // is in this set are actually written; every screen is still navigated to and
  // asserted. Store runs pass the curated ≤8 marketing subset (stores cap the
  // count); smoke-test callers leave it null and capture everything.
  Set<String>? captureOnly,
  // When true, swap the real leaderboard for a curated demo one before its shot
  // so no real player's username reaches a public store frame. Only the store
  // run sets this; smoke-test output stays byte-identical.
  bool seedDemoData = false,
}) async {
  void step(String name) => debugPrint('TEST_STEP: $name');
  // Layout-only matrix runs pass --dart-define=SKIP_SHOTS=true: the pure
  // overflow/geometry assertions are the whole point there, and the screenshot
  // machinery (convertFlutterSurfaceToImage + the per-shot settle loops) is
  // both the slow part and, on the iOS simulator, an intermittent hang.
  // Skipping it keeps every assertNoOverflow / assertDeviceWrapperWidth check
  // but drops the image capture. Defaults false, so the store/CI entry points
  // that don't pass it behave exactly as before.
  const skipShots = bool.fromEnvironment('SKIP_SHOTS', defaultValue: false);
  final prefix = '$devicePrefix${landscape ? 'landscape_' : 'portrait_'}';
  // Only the iPad entry points pass a non-empty devicePrefix — gate the new
  // iPad-only layout assertions on it rather than re-deriving device class
  // from physicalSize, so their intent stays explicit at each call site.
  final isIpadRun = devicePrefix.isNotEmpty;

  // Which localization to render/capture, set per run by
  // tool/screenshots/capture.sh via `--dart-define=NUCATCH_LOCALE=<code>`
  // (defaults to English). It is pinned onto the app below by writing
  // `PreferencesKey.LOCALE` before `app.main()` — skeleton_core's SettingBloc
  // reads it at construction (the same pre-main() seeding the FONT_SIZE stress
  // relies on) and SkeletonApp sets `MaterialApp.locale` from it. The labels
  // the navigation taps by are then loaded from that *same* locale, so an
  // English pass and a Vietnamese pass drive the identical flow without any
  // English string leaking into a non-English frame.
  const localeCode =
      String.fromEnvironment('NUCATCH_LOCALE', defaultValue: 'en');
  final locale = Locale(localeCode);
  final coreL10n = await CoreLocalizations.delegate.load(locale);
  final appL10n = await AppLocalizations.delegate.load(locale);
  // Menu buttons render their label uppercased (menu_screen.dart) and `tapText`
  // matches `AnimatedButton.text` exactly, so uppercase these to match.
  final menuStartLabel = coreL10n.start.toUpperCase();
  final menuTopScoreLabel = coreL10n.topScore.toUpperCase();
  final menuSettingLabel = coreL10n.setting.toUpperCase();
  final menuAboutLabel = coreL10n.about.toUpperCase();
  final skipTourLabel = appL10n.tourSkip;
  final updateLaterLabel = coreL10n.later;
  final mainMenuLabel = coreL10n.mainMenu;
  final returnToMenuLabel = coreL10n.returnToMenu;

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

  // Tracks every screenshot captured so far so `shot()` can detect a stale
  // capture (see below) rather than guessing a fixed warm-up delay.
  final seenScreenshots = <List<int>>[];

  // Readability / localization audit (--dart-define=AUDIT_TEXT=true): logs
  // every visible text on each captured screen as
  // `TEXTAUDIT|<screen>|<rendered size>|<text>`, where the size is what the
  // player actually sees — the style's font size × text scale × any
  // shrink-to-fit transform above it (FittedBox, Transform.scale). Walks the
  // tree the way semantics does, so covered routes, offstage and fully
  // transparent subtrees are skipped.
  const auditText = bool.fromEnvironment('AUDIT_TEXT', defaultValue: false);
  void auditTexts(String name) {
    if (!auditText) return;
    final view = tester.view;
    final screen = Offset.zero & (view.physicalSize / view.devicePixelRatio);
    void visit(RenderObject node) {
      if (node is RenderParagraph && node.attached && node.hasSize) {
        final text = node.text.toPlainText().replaceAll('\n', ' ').trim();
        if (text.isNotEmpty) {
          // In logical points already (the root's pixel-ratio transform
          // isn't part of it), so any scale here is a real shrink/grow.
          final transform = node.getTransformTo(null);
          final rect =
              MatrixUtils.transformRect(transform, Offset.zero & node.size);
          if (rect.width > 0.5 && rect.height > 0.5 && rect.overlaps(screen)) {
            double fontSize = node.text.style?.fontSize ?? 14;
            node.text.visitChildren((span) {
              final size = span.style?.fontSize;
              if (size != null && size < fontSize) fontSize = size;
              return true;
            });
            final scale = transform.getMaxScaleOnAxis();
            final rendered = node.textScaler.scale(fontSize) * scale;
            debugPrint('TEXTAUDIT|$name|${rendered.toStringAsFixed(1)}|$text'
                '|font=${fontSize.toStringAsFixed(1)}'
                ' textScale=${node.textScaler.scale(1).toStringAsFixed(2)}'
                ' transform=${scale.toStringAsFixed(2)}');
          }
        }
      }
      node.visitChildrenForSemantics(visit);
    }

    for (final renderView in tester.binding.renderViews) {
      visit(renderView);
    }
  }

  // Direct capture (--dart-define=SHOT_DIR=<absolute host path>): renders
  // the screen's layer tree to a PNG inside the test and writes it there —
  // no `flutter drive` screenshot channel (which intermittently hangs on the
  // iOS simulator), so it works under plain `flutter test`. iOS simulators
  // can write host paths directly.
  const shotDir = String.fromEnvironment('SHOT_DIR', defaultValue: '');
  Future<void> layerShot(String name) async {
    await doWait(2); // let transitions and fades finish
    final renderView = tester.binding.renderViews.first;
    final image = await (renderView.debugLayer! as OffsetLayer)
        .toImage(renderView.paintBounds, pixelRatio: 1);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$shotDir/$name.png')..createSync(recursive: true);
    file.writeAsBytesSync(png!.buffer.asUint8List());
    debugPrint('📸 Captured screenshot: ${file.path}');
  }

  // Android: render frames in Dart instead of `binding.takeScreenshot`. The
  // plugin's native capture (PixelCopy) can hit "Window doesn't have a
  // backing surface!" — a fatal native crash Dart can't catch — while the
  // play screen is grabbed over and over (its animated background never
  // settles). Rendering the layer tree at the device's pixel ratio gives the
  // same full-resolution frame of the app.
  final renderInDart = Platform.isAndroid;
  Future<List<int>> grab(String name) async {
    if (!renderInDart) return binding.takeScreenshot(name);
    await tester.pump();
    final renderView = tester.binding.renderViews.first;
    // paintBounds is already in physical pixels (the root layer carries the
    // device-pixel-ratio transform), so pixelRatio stays 1. Scaling by the
    // DPR again made 2835x5040 phone / 5120x3200 tablet frames, which Play
    // rejects (no side may exceed 3840 px).
    final image = await (renderView.debugLayer! as OffsetLayer)
        .toImage(renderView.paintBounds, pixelRatio: 1);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    return png!.buffer.asUint8List();
  }

  /// Hands a Dart-rendered frame to the `flutter drive` driver the same way
  /// `takeScreenshot` does (`reportData['screenshots']`), once per shot.
  void reportShot(String name, List<int> bytes) {
    if (!renderInDart) return; // takeScreenshot already reported it
    binding.reportData ??= <String, dynamic>{};
    (binding.reportData!['screenshots'] ??= <dynamic>[]) as List<dynamic>;
    (binding.reportData!['screenshots'] as List<dynamic>)
        .add(<String, dynamic>{'screenshotName': name, 'bytes': bytes});
  }

  Future<void> shot(String name) async {
    auditTexts(name);
    if (shotDir.isNotEmpty) {
      await layerShot(name);
      return;
    }
    // Layout-only run: no images at all, just the assertions around each shot.
    if (skipShots) return;
    // Store runs limit output to a curated subset — skip the capture (but not
    // the navigation/assertions that precede it) for anything not in the set.
    if (captureOnly != null) {
      final base =
          name.startsWith(prefix) ? name.substring(prefix.length) : name;
      if (!captureOnly.contains(base)) return;
    }
    try {
      List<int> bytes = await grab(name);
      // Re-grab until the frame is BOTH settled and distinct, or the budget
      // runs out:
      //
      //  • settled — two consecutive grabs are byte-identical, so the screen
      //    has stopped changing. This is what defeats the *mid-animation*
      //    captures a single grab returns on this simulator: the intro "Go"
      //    countdown overlay on the play screen, a spinner, or a frame taken
      //    while a navigation/seed is still painting (which is how the combat
      //    play/end shots previously came out as the setup screen or a
      //    half-seeded "…/ null" state).
      //
      //  • distinct — the frame doesn't byte-match a screenshot already taken
      //    of a *different* screen. `takeScreenshot()` here has been observed
      //    to return a stale frame from 2–4 calls back (confirmed by diffing
      //    output PNGs), and every shot in this walkthrough follows a real
      //    navigation to a genuinely different screen, so a match means the
      //    grab is stale.
      //
      // Falls through after the budget so a screen that genuinely never
      // settles (a persistent looping animation) still yields a frame rather
      // than looping forever.
      for (int attempt = 0; attempt < 15; attempt++) {
        if (seenScreenshots.any((seen) => listEquals(bytes, seen))) {
          await doWait(1);
          bytes = await grab(name);
          continue;
        }
        await doWait(1);
        final again = await grab(name);
        if (listEquals(again, bytes)) break; // settled AND distinct
        bytes = again; // still painting — keep waiting
      }
      seenScreenshots.add(bytes);
      reportShot(name, bytes);
      debugPrint('📸 Captured screenshot: $name');
    } catch (e) {
      // Screenshot capture is a nice-to-have here, not the point of this
      // test — a platform/emulator quirk taking a screenshot shouldn't fail
      // the "does this screen render" assertion that already ran above it.
      debugPrint('📸 Screenshot "$name" failed (non-fatal): $e');
    }
  }

  // ── iPad layout-correctness assertions ──────────────────────
  // Genuinely new category for this suite: every assertion above only ever
  // confirmed "does this screen's widget type exist," never "did it render
  // without error" or "does its geometry look right." These three do.

  /// Fails if the widget tree produced an uncaught rendering exception
  /// (e.g. a RenderFlex overflow) since the last check.
  ///
  /// COLLECT_OVERFLOWS=true flips this from fail-fast to gather-all: it records
  /// every overflow (with its screen label) and keeps going, so a single run
  /// enumerates every offending screen instead of stopping at the first. The
  /// end-of-run summary (OVERFLOW_SUMMARY) prints the full list.
  const collectOverflows =
      bool.fromEnvironment('COLLECT_OVERFLOWS', defaultValue: false);
  final overflowReports = <String>[];
  void assertNoOverflow(String label) {
    final exception = tester.takeException();
    if (exception == null) return;
    if (collectOverflows) {
      overflowReports.add('$label: $exception');
      debugPrint('OVERFLOW_FOUND >> $label: $exception');
      return;
    }
    expect(exception, isNull,
        reason: '$label produced a render exception: $exception');
  }

  /// iPad-only (no-op on phone runs): confirms this screen's DeviceWrapper
  /// content width doesn't exceed [expectedMax]. Measures the `SizedBox`
  /// DeviceWrapper wraps its content in, not DeviceWrapper's own render box
  /// — DeviceWrapper builds a `Center`, which (per `RenderPositionedBox`)
  /// sizes itself to fill its parent's full bounded width regardless of its
  /// child's width, so measuring DeviceWrapper directly would always report
  /// the screen width, not the actual capped content width.
  void assertDeviceWrapperWidth(String label, double expectedMax) {
    if (!isIpadRun) return;
    final wrapperFinder = find.byType(DeviceWrapper);
    if (wrapperFinder.evaluate().isEmpty) return;
    final sizedBoxFinder = find.descendant(
      of: wrapperFinder.first,
      matching: find.byType(SizedBox),
    );
    if (sizedBoxFinder.evaluate().isEmpty) return;
    final width = tester.getSize(sizedBoxFinder.first).width;
    expect(width, lessThanOrEqualTo(expectedMax + 1.0),
        reason: '$label: DeviceWrapper content width $width exceeds cap '
            '$expectedMax');
  }

  /// iPad-only: confirms a numeric keypad button stays roughly square
  /// rather than stretching into an elongated rectangle.
  void assertKeypadButtonAspectRatio(String label) {
    if (!isIpadRun) return;
    final key = TourKeys.keypadKeys[KeyboardOption.one];
    if (key == null) return;
    final buttonFinder = find.byKey(key);
    if (buttonFinder.evaluate().isEmpty) return;
    final size = tester.getSize(buttonFinder);
    final ratio = size.width / size.height;
    expect(ratio, inInclusiveRange(0.5, 2.0),
        reason: '$label: keypad button ratio $ratio looks stretched '
            '(${size.width}x${size.height})');
  }

  /// iPad-only: confirms two option cards (found by their icon)
  /// share the same vertical position, i.e. `ResponsiveGrid` genuinely laid
  /// them out side-by-side in a row rather than stacked.
  void assertGridSideBySide(String label, FaIconData iconA, FaIconData iconB) {
    if (!isIpadRun) return;
    final findA =
        find.byWidgetPredicate((w) => w is FaIcon && w.icon == iconA.data);
    final findB =
        find.byWidgetPredicate((w) => w is FaIcon && w.icon == iconB.data);
    if (findA.evaluate().isEmpty || findB.evaluate().isEmpty) return;
    // Compare the cards' tops, not the icons': a ModeCard centres its icon
    // vertically, so a longer description in one card would shift it.
    double topOf(Finder icon) {
      final card =
          find.ancestor(of: icon.first, matching: find.byType(ModeCard));
      return tester
          .getTopLeft(card.evaluate().isNotEmpty ? card.first : icon.first)
          .dy;
    }

    final dyA = topOf(findA);
    final dyB = topOf(findB);
    expect(dyA, closeTo(dyB, 1.0),
        reason: '$label: expected ResponsiveGrid to lay cards out '
            'side-by-side (dyA=$dyA, dyB=$dyB)');
  }

  /// Dismisses the app-wide tour's "Welcome" overlay if it's showing right
  /// now. TourBloc's auto-start decision is async (a delay after its own
  /// SharedPreferences read resolves) — it can land *after* the one-time
  /// startup check clears, anywhere up to a couple of screens into the
  /// walkthrough, so callers that are about to tap something check-and-clear
  /// immediately beforehand rather than trusting a single check made
  /// minutes of test-time earlier.
  Future<void> dismissStrayTourOverlay() async {
    if (find.text(skipTourLabel).evaluate().isNotEmpty) {
      await tester.tap(find.text(skipTourLabel).first);
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
          debugPrint(
              'TEST_DEBUG tap("$debugLabel") attempt $attempt failed: $e');
        }
      }
      await tester.pump(const Duration(milliseconds: 500));
    }
    throw StateError('tap("$debugLabel") failed after retries: $lastError');
  }

  /// Taps a widget by its visible text, preferring to invoke a matching
  /// `AnimatedButton`/`CustomElevatedButton`'s `onPressed` callback
  /// directly rather than a real synthetic tap — the same reliability fix
  /// applied to `tapBack`/`tapOptionCard` above, for the same class of
  /// confirmed on-device flakiness (a real tap "succeeds" with no thrown
  /// error, yet the app never reacts).
  Future<void> tapText(String text) async {
    final animatedButtonFinder =
        find.byWidgetPredicate((w) => w is AnimatedButton && w.text == text);
    if (animatedButtonFinder.evaluate().isNotEmpty) {
      final button = tester.widget<AnimatedButton>(animatedButtonFinder.first);
      button.onPressed();
      await doWait(1);
      return;
    }
    final elevatedButtonFinder = find
        .byWidgetPredicate((w) => w is CustomElevatedButton && w.text == text);
    if (elevatedButtonFinder.evaluate().isNotEmpty) {
      final button =
          tester.widget<CustomElevatedButton>(elevatedButtonFinder.first);
      final onPressed = button.onPressed;
      if (onPressed != null) {
        onPressed();
        await doWait(1);
        return;
      }
    }
    // Fallback for text that isn't an AnimatedButton/CustomElevatedButton
    // label (e.g. "Skip Tour").
    await tapFinder(find.text(text), text);
  }

  /// Taps a top-level menu option by its visible (uppercase) label — the
  /// menu buttons are built dynamically from `menuArray()` with no
  /// per-button keys, so text is the only stable way to find them.
  Future<void> tapMenuOption(MenuOption option, String upperCaseLabel) async {
    await tapText(upperCaseLabel);
  }

  /// Taps a top-level menu option and confirms [screenFinder] appears,
  /// retrying (with a fresh stray-tour-overlay dismissal) and finally
  /// falling back to dispatching `SelectOption` directly on `MenuBloc` if
  /// the tap keeps silently failing to register. Confirmed on-device (both
  /// a physical iPhone and the iPad Simulator): `tester.tap()` here can
  /// return with no thrown error yet the app never navigates — most likely
  /// a stray tour-overlay race (see `dismissStrayTourOverlay`'s doc
  /// comment) that a single attempt doesn't always survive.
  Future<void> tapMenuOptionAndWait(
    MenuOption option,
    String upperCaseLabel,
    Finder screenFinder,
  ) async {
    for (int attempt = 0; attempt < 3; attempt++) {
      step('tapping $upperCaseLabel (attempt $attempt)');
      await tapMenuOption(option, upperCaseLabel);
      if (await waitFor(screenFinder, maxSeconds: 10)) return;
      await dismissStrayTourOverlay();
    }
    if (screenFinder.evaluate().isEmpty) {
      debugPrint('TEST_DEBUG dispatching SelectOption($option) directly, '
          'bypassing the tap entirely');
      tester
          .element(find.byType(MenuScreen))
          .read<MenuBloc>()
          .add(SelectOption(option: option));
      await waitFor(screenFinder, maxSeconds: 10);
    }
  }

  /// Taps an `OptionCard`, identified by its trailing icon. A real
  /// synthetic tap here — whether on the title text, the card as a whole,
  /// or even the icon's own `AnimatedButton` — has proven unreliable
  /// on-device across this walkthrough (confirmed on both a physical
  /// iPhone and the iPad Simulator: the tap "succeeds", no thrown error,
  /// yet the app never reacts). `OptionCard.onTap` is a plain
  /// `VoidCallback` with no gesture/hit-testing involved — both the card's
  /// `GestureDetector` and the icon's `AnimatedButton` invoke the exact
  /// same callback, so fetching the `OptionCard` widget instance and
  /// calling it directly is exactly equivalent to a real tap landing
  /// anywhere on the card, and sidesteps the flakiness entirely.
  Future<void> tapOptionCard(FaIconData iconData, String debugLabel) async {
    final iconFinder =
        find.byWidgetPredicate((w) => w is FaIcon && w.icon == iconData.data);
    await waitFor(iconFinder);
    final cardFinder =
        find.ancestor(of: iconFinder.first, matching: find.byType(OptionCard));
    if (cardFinder.evaluate().isNotEmpty) {
      final card = tester.widget<OptionCard>(cardFinder.first);
      card.onTap();
      await doWait(1);
      return;
    }
    // The play-mode screens use the app's own ModeCard (same reasoning).
    final modeCardFinder =
        find.ancestor(of: iconFinder.first, matching: find.byType(ModeCard));
    if (modeCardFinder.evaluate().isNotEmpty) {
      tester.widget<ModeCard>(modeCardFinder.first).onTap();
      await doWait(1);
      return;
    }
    // Fallback for the unlikely case an OptionCard ancestor isn't found.
    await tapFinder(iconFinder, debugLabel);
  }

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
    // A real synthetic tap here has proven unreliable on-device (confirmed
    // on both a physical iPhone and the iPad Simulator: the tap "succeeds"
    // — no thrown error — yet the app never navigates). `onBackPressed` is
    // a plain `VoidCallback` with no gesture/hit-testing involved, so
    // invoking it directly is both more reliable and exactly equivalent to
    // what a real tap would have triggered.
    final appBar = tester.widget<CustomSliverAppBar>(appBarFinder.first);
    appBar.onBackPressed?.call();
    await doWait(2);
  }

  FcmService.disablePermissionRequestForTest = true;
  AiGreetingService.disableForTest = true;
  CombatBleService.disableForTest = true;
  // Store runs suppress the AdMob banners on the leaderboard and game-over
  // screens — a live (or "Test mode") ad has no place in a marketing frame,
  // and its async network load is exactly the kind of non-determinism this
  // walkthrough otherwise fights. Gated on [seedDemoData] so the smoke suites'
  // captured output stays byte-identical.
  if (seedDemoData) AdMobBanner.disableForTest = true;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    // Static flag on a shared widget — reset so it can't leak into another
    // suite that reuses the same process.
    AdMobBanner.disableForTest = false;
  });

  // 1080x2400 physical pixels at a 2.625 device pixel ratio (the default
  // [physicalSize]/[devicePixelRatio]) is a real, common phone profile (the
  // same physical resolution class as the test device) — logical size works
  // out to ~411x914, matching what the app's layout code actually assumes.
  // A devicePixelRatio of 1.0 with these physical dimensions (an earlier
  // version of this test used that) makes Flutter treat 1080x2400 as
  // *logical* pixels — over 2.5x wider/taller than the app is designed for,
  // so every fixed-size button/icon renders far smaller relative to the
  // screen than it does on a real device, to the point that unrelated
  // overlays (the quick-settings volume/vibration buttons) visually and
  // functionally overlapped the in-game menu button and silently absorbed
  // taps meant for it.
  if (nativeViewport) {
    // Store capture: leave the viewport alone so the frame comes out at the
    // real device's native pixel dimensions (required for store upload).
    step('using native device viewport (no override)');
  } else if (landscape) {
    // Swapped width/height of the portrait profile rather than a synthetic
    // square, so layout code that branches on aspect ratio behaves the same
    // way it would on an actual rotated device.
    step('forcing landscape physical size');
    tester.view.physicalSize = Size(physicalSize.height, physicalSize.width);
    tester.view.devicePixelRatio = devicePixelRatio;
  } else {
    step('forcing portrait physical size');
    tester.view.physicalSize = physicalSize;
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
  // Pin the UI language for this run (default 'en'). Must be set before
  // app.main(): SettingBloc reads PreferencesKey.LOCALE at construction and
  // SkeletonApp drives MaterialApp.locale from it.
  await prefs.setString(PreferencesKey.LOCALE, localeCode);

  // Font-size stress dimension: min (0) / max (10) come in via
  // `--dart-define=FONT_SIZE=N`, written here (before app.main()) so
  // skeleton_core's SettingBloc reads it at construction. Absent (-1) keeps
  // the app's default (8) — and this suite's prior behaviour — unchanged.
  const injectedFontSize = int.fromEnvironment('FONT_SIZE', defaultValue: -1);
  if (injectedFontSize >= 0) {
    await prefs.setInt(PreferencesKey.FONT_SIZE, injectedFontSize);
    // Seed a last-used difficulty so the difficulty screen actually renders its
    // "Last played" Smart Default badge under this font-stress run — otherwise
    // prefs.clear() above hides it and the matrix never exercises it. Gated on
    // the same font injection so default/store runs stay byte-identical.
    await prefs.setString(
        NucatchPreferencesKey.LAST_USED_DIFFICULTY, Difficulty.medium.name);
  }

  // The menu prints the platform's version, which a `flutter drive` debug
  // build takes from pubspec (it lags the released one). Store runs pass the
  // released version (tool/screenshots/capture.sh reads it from the latest
  // CHANGELOG build command) so frames don't advertise a stale number.
  const releasedVersion = String.fromEnvironment('NUCATCH_VERSION');
  if (releasedVersion.isNotEmpty) {
    final real = await PackageInfo.fromPlatform();
    PackageInfo.setMockInitialValues(
      appName: real.appName,
      packageName: real.packageName,
      version: releasedVersion,
      buildNumber: const String.fromEnvironment('NUCATCH_BUILD_NUMBER',
          defaultValue: '0'),
      buildSignature: real.buildSignature,
      installerStore: real.installerStore,
    );
  }

  step('calling app.main()');
  app.main();

  step('waiting for home screen');
  // Wait for the home screen (splash/init can take a moment). Gated on the
  // MenuScreen widget type rather than a menu label so it stays correct in
  // every locale.
  await waitFor(find.byType(MenuScreen), maxSeconds: 30);

  // Android renders Flutter to a `SurfaceView` by default, which the
  // platform screenshot channel can't read pixels from — `takeScreenshot()`
  // throws "Bad state: Call convertFlutterSurfaceToImage()..." for every
  // single call until this runs once, switching to a screenshot-able
  // texture-backed view. A no-op on iOS/other platforms.
  // Not needed when frames are rendered in Dart (Android, see `grab`), and
  // the surface swap is one more moving part around the native capture.
  if (!skipShots && !Platform.isAndroid) {
    step('switching to a screenshot-able Flutter surface');
    await binding.convertFlutterSurfaceToImage();
    await doWait(1);
  }

  step('checking for stray tour overlay');
  for (int i = 0; i < 10; i++) {
    if (find.text(skipTourLabel).evaluate().isNotEmpty) {
      step('dismissing stray tour overlay');
      await tester.tap(find.text(skipTourLabel).first);
      await doWait(2);
      break;
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  // A real update-check (`AppVersionBloc`/`UpdateNoticeDialog`) can land a
  // modal dialog on top of the whole app shortly after launch — it doesn't
  // block widget-tree lookups (the screen underneath stays mounted, so
  // `find.byType`/direct-callback taps still work through it), but it does
  // visually cover every screenshot taken after it appears if left
  // undismissed. Dismiss it once, up front, the same way as the tour
  // overlay above.
  step('checking for an update-available dialog');
  for (int i = 0; i < 6; i++) {
    if (find.text(updateLaterLabel).evaluate().isNotEmpty) {
      step('dismissing update-available dialog');
      await tapText(updateLaterLabel);
      break;
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  // ── Home ──────────────────────────────────────────────────
  step('asserting MenuScreen (home)');
  expect(find.byType(MenuScreen), findsOneWidget);
  await shot('${prefix}01_home');
  assertNoOverflow('01_home');
  assertDeviceWrapperWidth('01_home', 800);

  // ── About ─────────────────────────────────────────────────
  await tapMenuOptionAndWait(
      MenuOption.about, menuAboutLabel, find.byType(AboutScreen));
  step('asserting AboutScreen');
  expect(find.byType(AboutScreen), findsOneWidget,
      reason: 'About should still be reachable from the menu');
  await shot('${prefix}02_about');
  assertNoOverflow('02_about');
  step('tapping back from About');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from About should return to the menu');

  // ── Settings ──────────────────────────────────────────────
  await tapMenuOptionAndWait(
      MenuOption.setting, menuSettingLabel, find.byType(SettingScreen));
  step('asserting SettingScreen');
  expect(find.byType(SettingScreen), findsOneWidget,
      reason: 'Settings should still be reachable from the menu');
  await shot('${prefix}03_settings');
  assertNoOverflow('03_settings');
  step('tapping back from Settings');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from Settings should return to the menu');

  // ── Leaderboard ───────────────────────────────────────────
  await tapMenuOptionAndWait(
      MenuOption.topScore, menuTopScoreLabel, find.byType(TopScoreScreen));
  step('asserting TopScoreScreen');
  expect(find.byType(TopScoreScreen), findsOneWidget,
      reason: 'Leaderboard should still be reachable from the menu');
  // Redact real players' usernames from the public store frame by swapping in a
  // curated demo leaderboard. Dispatched AFTER the screen has mounted (it kicks
  // off its own real load on init) so the demo rows are what actually render.
  // Gated on [seedDemoData] so the internal smoke passes stay byte-identical.
  if (seedDemoData) {
    step('seeding demo leaderboard');
    tester
        .element(find.byType(TopScoreScreen))
        .read<TurnRecordedListBloc>()
        .add(SeedDemoLeaderboard());
    await doWait(2);
  }
  await shot('${prefix}04_leaderboard');
  assertNoOverflow('04_leaderboard');
  assertDeviceWrapperWidth('04_leaderboard', 1200);
  step('tapping back from Leaderboard');
  await tapBack();
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'back from the leaderboard should return to the menu');

  // ── Select play mode ──────────────────────────────────────
  await tapMenuOptionAndWait(
      MenuOption.start, menuStartLabel, find.byType(SelectPlayModeScreen));
  step('asserting SelectPlayModeScreen');
  expect(find.byType(SelectPlayModeScreen), findsOneWidget,
      reason: 'Start should reach the play-mode picker');
  await shot('${prefix}05_select_play_mode');
  assertNoOverflow('05_select_play_mode');
  assertGridSideBySide('05_select_play_mode', FontAwesomeIcons.solidUser,
      FontAwesomeIcons.userGroup);

  // ── Solo: difficulty picker ───────────────────────────────
  step('tapping Solo Mode');
  await tapOptionCard(FontAwesomeIcons.solidUser, 'Solo Mode');
  step('asserting SetDifficultScreen');
  await waitFor(find.byType(SetDifficultScreen), maxSeconds: 10);
  expect(find.byType(SetDifficultScreen), findsOneWidget,
      reason: 'Solo Mode should reach the difficulty picker');
  await shot('${prefix}06_set_difficulty');
  assertNoOverflow('06_set_difficulty');

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
  // Store runs freeze an attractive, deterministic gameplay state before the
  // shot. A real game leaves a running countdown timer — the frame never
  // settles, so the settle guard in `shot()` can't lock on and it captures
  // whatever transient (often the intro "Go" overlay) is on screen. The same
  // `SeedTutorialTurn` the game-over shot uses, with `startTimer: false`,
  // renders the real keypad at a memorable level/score and holds it still.
  // Gated on [seedDemoData] so the smoke suites keep exercising real gameplay.
  if (seedDemoData) {
    step('seeding a frozen play state for the store shot');
    tester.element(find.byType(PlayScreen)).read<TurnBloc>().add(
          SeedTutorialTurn(
            difficulty: Difficulty.medium,
            requirementString: '347',
            expect: '347',
            level: 3,
            point: 60,
            startTimer: false,
          ),
        );
    await doWait(1);
    // Type the first two digits through the real keypad path, so the frame
    // shows a round in progress ("3 4 _") — empty slots alone don't show a
    // store visitor what the game is.
    final playTurnBloc =
        tester.element(find.byType(PlayScreen)).read<TurnBloc>();
    playTurnBloc.add(Tap(keyValue: KeyboardOption.three));
    await doWait(1);
    playTurnBloc.add(Tap(keyValue: KeyboardOption.four));
    // A tap restarts the turn timer; hold it again so the frame settles
    // (the game-over seed below clears the hold).
    playTurnBloc.add(TapTimerPause());
    await doWait(1);
  }
  await shot('${prefix}07_play_screen');
  assertNoOverflow('07_play_screen');
  assertDeviceWrapperWidth('07_play_screen', landscape ? 1200 : 800);
  assertKeypadButtonAspectRatio('07_play_screen');

  // ── Solo: game over screen ────────────────────────────────
  // Seeded rather than played out for real: `SeedTutorialTurn` (built for
  // the in-game rule tutorial, see `tour_guide_test.dart`) lets this land
  // an attractive, reproducible score directly onto the real `TurnBloc`,
  // then the real `End(isCauseGameOver: true)` event — the same one a real
  // timeout/life-loss dispatches — takes it the rest of the way for real.
  step('seeding an attractive game-over state');
  final turnBloc = tester.element(find.byType(PlayScreen)).read<TurnBloc>();
  turnBloc.add(SeedTutorialTurn(
    difficulty: Difficulty.medium,
    requirementString: '478',
    expect: '478',
    level: 6,
    point: 145,
  ));
  await doWait(1);
  turnBloc.add(End(isCauseGameOver: true));
  step('waiting for GameOverScreen');
  await waitFor(find.byType(GameOverScreen), maxSeconds: 10);
  expect(find.byType(GameOverScreen), findsOneWidget,
      reason: 'seeding an ended game should reach the game over screen');
  await shot('${prefix}08_game_over');
  assertNoOverflow('08_game_over');
  step('tapping Main Menu from Game Over');
  await tapText(mainMenuLabel);
  step('asserting back at MenuScreen after Game Over');
  await waitFor(find.byType(MenuScreen), maxSeconds: 10);
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'Main Menu from Game Over should return to the menu');

  // ── Combat: setup ─────────────────────────────────────────
  await tapMenuOptionAndWait(
      MenuOption.start, menuStartLabel, find.byType(SelectPlayModeScreen));
  expect(find.byType(SelectPlayModeScreen), findsOneWidget);
  step('tapping Combat Mode');
  await tapOptionCard(FontAwesomeIcons.userGroup, 'Combat Mode');
  step('asserting CombatModeSetupScreen');
  await waitFor(find.byType(CombatModeSetupScreen), maxSeconds: 10);
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'Combat Mode should reach the combat setup screen');
  await shot('${prefix}09_combat_setup');
  assertNoOverflow('09_combat_setup');

  // ── Combat: host room (no peer — just confirms it renders) ─
  step('tapping Create Room');
  await tapOptionCard(FontAwesomeIcons.userPlus, 'Create Room');
  step('asserting HostRoomScreen');
  await waitFor(find.byType(HostRoomScreen), maxSeconds: 10);
  expect(find.byType(HostRoomScreen), findsOneWidget,
      reason: 'Create Room should reach the host room screen');
  await shot('${prefix}10_combat_host_room');
  assertNoOverflow('10_combat_host_room');
  step('tapping back from host room');
  await tapBack();
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'back from hosting should return to combat setup');

  // ── Combat: join room (no peer — just confirms it renders) ─
  step('tapping Join Room');
  await tapOptionCard(FontAwesomeIcons.rightToBracket, 'Join Room');
  step('asserting JoinRoomScreen');
  await waitFor(find.byType(JoinRoomScreen), maxSeconds: 10);
  expect(find.byType(JoinRoomScreen), findsOneWidget,
      reason: 'Join Room should reach the join room screen');
  await shot('${prefix}11_combat_join_room');
  assertNoOverflow('11_combat_join_room');
  step('tapping back from join room');
  await tapBack();
  expect(find.byType(CombatModeSetupScreen), findsOneWidget,
      reason: 'back from joining should return to combat setup');

  // ── Combat: play screen ────────────────────────────────────
  // Same seeding approach as Game Over: `CombatNavCubit.showPlaying()`
  // (skipping the real BLE pairing flow) then `SeedTutorialCombat` for an
  // attractive, reproducible mid-match state directly on the real
  // `CombatBloc` — no peer device needed.
  step('seeding an attractive combat-playing state');
  final combatNavCubit =
      tester.element(find.byType(CombatModeSetupScreen)).read<CombatNavCubit>();
  final combatBloc =
      tester.element(find.byType(CombatModeSetupScreen)).read<CombatBloc>();
  combatNavCubit.showPlaying();
  await doWait(1);
  combatBloc.add(SeedTutorialCombat(
    difficulty: Difficulty.medium,
    requirementString: '58',
    expect: '58',
    level: 4,
    point: 6,
    lifeRemaining: 2,
    opponentLives: 1,
    opponentScore: 4,
  ));
  step('waiting for CombatPlayScreen');
  await waitFor(find.byType(CombatPlayScreen), maxSeconds: 10);
  expect(find.byType(CombatPlayScreen), findsOneWidget,
      reason: 'seeding a combat match should reach the combat play screen');
  if (seedDemoData) {
    // Same as the solo shot: one digit typed for real, then the timer held,
    // so the frame shows a match in progress and settles.
    step('typing the first digit for the store shot');
    combatBloc.add(CombatTap(keyValue: KeyboardOption.five));
    await doWait(1);
    combatBloc.add(CombatTapTimerPause());
    await doWait(1);
  }
  await shot('${prefix}12_combat_play');
  assertNoOverflow('12_combat_play');
  assertDeviceWrapperWidth('12_combat_play', landscape ? 1200 : 800);
  assertKeypadButtonAspectRatio('12_combat_play');

  // ── Combat: game end screen ────────────────────────────────
  // The real `CombatGameEnded` event — same one a real win dispatches —
  // takes the seeded match the rest of the way for real.
  step('seeding a real combat win');
  combatBloc.add(CombatGameEnded(
    isWinner: true,
    reason: GameEndReason.opponentLivesOut,
    sendMessage: false,
  ));
  step('waiting for CombatGameEndScreen');
  await waitFor(find.byType(CombatGameEndScreen), maxSeconds: 10);
  expect(find.byType(CombatGameEndScreen), findsOneWidget,
      reason: 'a real win should reach the combat game end screen');
  await shot('${prefix}13_combat_game_end');
  assertNoOverflow('13_combat_game_end');

  // ── Back out to the main menu ─────────────────────────────
  step('tapping Return to Menu from Combat Game End');
  await tapText(returnToMenuLabel);
  step('asserting SelectPlayModeScreen after Combat Game End');
  await waitFor(find.byType(SelectPlayModeScreen), maxSeconds: 10);
  expect(find.byType(SelectPlayModeScreen), findsOneWidget,
      reason: 'Return to Menu from Combat Game End should land on the '
          'play-mode picker');
  step('tapping back from select play mode');
  await tapBack(); // select play mode -> menu
  expect(find.byType(MenuScreen), findsOneWidget,
      reason: 'should be able to navigate all the way back to the menu');
  step('done');
  if (collectOverflows) {
    debugPrint('OVERFLOW_SUMMARY count=${overflowReports.length}');
    for (final r in overflowReports) {
      debugPrint('OVERFLOW_SUMMARY_ITEM >> $r');
    }
    // Still fail at the end so the exit code reflects "layout not clean", but
    // only after every screen has been visited and logged.
    expect(overflowReports, isEmpty,
        reason: 'overflows on: '
            '${overflowReports.map((r) => r.split(':').first).join(', ')}');
  }
}
