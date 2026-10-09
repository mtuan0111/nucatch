import 'dart:developer' as dev;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OffsetLayer;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show
        BlocProvider,
        CoreLocalizations,
        PreferencesKey,
        TourBloc,
        TourState,
        TourStep;

import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/main.dart' as app;
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tour_progress.dart';
import 'package:nucatch/helpers/tutorial_localization.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/services/ai_greeting_service.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:nucatch/services/fcm_service.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_play_screen.dart';
import 'package:nucatch/widgets/global_tour_wrapper.dart';
import 'package:nucatch/widgets/tour_card.dart';

/// Walks the whole onboarding tour — the main-menu part
/// (`GlobalTourWrapper`) and the hands-on Regular / Pick Right / Combat
/// practice (`TutorialCubit` + `TutorialOverlay`) — forwards AND backwards,
/// checking layout and behaviour at every step:
///
/// - **Every step**: the card shows the right title and "Part · n / N"
///   label, sits fully on screen with its buttons tappable, and (where the
///   step points at something) the spotlight target is on screen and not
///   covered by the card. Any RenderFlex overflow fails the test outright.
/// - **Every step after the first**: Previous lands where it should
///   (`TourProgress.previousBefore` / `TutorialCubit.previousSeededIndex`),
///   that step is checked the same way, then the test plays forward again.
/// - **Every lesson that sets the game up**: the real `TurnBloc` /
///   `CombatBloc` holds that lesson's seeded number/question, whether it
///   was reached with Next or Previous.
///
/// Lessons are completed the way a player would, driven by
/// `TutorialScript` itself (tap Next, tap the required key or answer, or
/// wait for a real timer/scripted opponent), so adding or reordering
/// lessons needs no change here.
///
/// Deliberately in its own single-test file, same reasoning as
/// `screen_walkthrough.dart`: `app.main()` sets up process-wide singletons
/// that don't fully tear down between calls within one test binary. Unlike
/// that test, `has_completed_tour` is left unset so the tour auto-starts.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full tour: every step forwards and back, layout + behaviour',
      (tester) async {
    void step(String name) => dev.log('TEST_STEP: $name');

    // Language via --dart-define=NUCATCH_LOCALE=<code> (default English):
    // pinned onto the app below (PreferencesKey.LOCALE) and used for every
    // label this test taps, so each language drives the identical flow.
    const localeCode =
        String.fromEnvironment('NUCATCH_LOCALE', defaultValue: 'en');
    final appL10n = await AppLocalizations.delegate.load(Locale(localeCode));
    final coreL10n = await CoreLocalizations.delegate.load(Locale(localeCode));
    final nextText = appL10n.tourNext;
    final previousText = appL10n.tourPrevious;
    final finishText = appL10n.tourFinish;

    // --dart-define=SHOT_DIR=<absolute host path>: save a PNG of every card
    // this test checks (iOS simulators can write host paths directly).
    const shotDir = String.fromEnvironment('SHOT_DIR', defaultValue: '');
    var shotCount = 0;
    Future<void> saveShot(String label) async {
      if (shotDir.isEmpty) return;
      final renderView = tester.binding.renderViews.first;
      final image = await (renderView.debugLayer! as OffsetLayer)
          .toImage(renderView.paintBounds, pixelRatio: 1);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      shotCount++;
      final name =
          '${shotCount.toString().padLeft(3, '0')}_${label.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}';
      File('$shotDir/$name.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    }

    Future<void> doWait(double seconds) async {
      final ticks = (seconds * 10).ceil();
      for (int i = 0; i < ticks; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<bool> waitUntil(bool Function() condition,
        {double maxSeconds = 20}) async {
      for (int i = 0; i < maxSeconds * 10; i++) {
        if (condition()) return true;
        await tester.pump(const Duration(milliseconds: 100));
      }
      return condition();
    }

    Future<bool> waitFor(Finder finder, {double maxSeconds = 20}) =>
        waitUntil(() => finder.evaluate().isNotEmpty, maxSeconds: maxSeconds);

    // ── App state ───────────────────────────────────────────
    /// Null until the app has mounted.
    BuildContext? rootContext() {
      final wrapper = find.byType(GlobalTourWrapper);
      return wrapper.evaluate().isEmpty ? null : tester.element(wrapper);
    }

    TourState tour() {
      final context = rootContext();
      return context == null
          ? const TourState()
          : BlocProvider.of<TourBloc>(context).state;
    }

    TutorialState tutorial() {
      final context = rootContext();
      return context == null
          ? const TutorialState()
          : BlocProvider.of<TutorialCubit>(context).state;
    }

    /// A real update-check (`AppVersionBloc`/`UpdateNoticeDialog`) can land
    /// a modal dialog on top of the app; dismiss it whenever it's actually
    /// on top.
    Future<void> dismissUpdateDialog() async {
      final later = find.text(coreL10n.later).hitTestable();
      if (later.evaluate().isNotEmpty) {
        step('dismissing update-available dialog');
        await tester.tap(later.first, warnIfMissed: false);
        await doWait(1);
      }
    }

    // ── The card on screen ─────────────────────────────────
    /// The tour card on the screen that's actually showing — a lesson
    /// hosted on GameOverScreen also builds a card on the PlayScreen
    /// beneath it, which the player can't see.
    Finder currentCard() => find.byElementPredicate(
        (e) => e.widget is TourCard && (ModalRoute.of(e)?.isCurrent ?? true));

    Finder inCard(String text) => find
        .descendant(of: currentCard(), matching: find.text(text))
        .hitTestable();

    Rect screen() {
      final view = tester.view;
      return Offset.zero & (view.physicalSize / view.devicePixelRatio);
    }

    /// Waits until the card has stopped moving — its screen may still be
    /// sliding in, or the card fading/settling into place.
    Future<void> settleCard() async {
      Rect? last;
      var still = 0;
      for (int i = 0; i < 50 && still < 3; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (currentCard().evaluate().isEmpty) return;
        final rect = tester.getRect(currentCard());
        still = rect == last ? still + 1 : 0;
        last = rect;
      }
    }

    Rect currentTarget() {
      if (currentCard().evaluate().isEmpty) return Rect.zero;
      final layer = find.ancestor(
          of: currentCard(), matching: find.byType(TourSpotlightLayer));
      if (layer.evaluate().isEmpty) return Rect.zero;
      return tester.widget<TourSpotlightLayer>(layer.first).measureTarget();
    }

    /// Waits for the step's highlighted element to be on screen — a result
    /// card can appear a moment before the screen it points at (e.g.
    /// GameOverScreen taking over from the game) has settled.
    Future<void> settleTarget() async {
      await waitUntil(() => currentTarget() != Rect.zero, maxSeconds: 5);
      await settleCard();
    }

    /// Layout of the card now showing: fully on screen, its buttons
    /// tappable, and — when [expectTarget] — the spotlight target on
    /// screen and not hidden behind the card.
    void checkLayout(String label, {required bool expectTarget}) {
      expect(currentCard(), findsOneWidget,
          reason: '$label: exactly one visible card');
      final card = tester.getRect(currentCard());
      expect(screen().inflate(1).contains(card.topLeft), isTrue,
          reason: '$label: card $card starts off screen ${screen()}');
      expect(screen().inflate(1).contains(card.bottomRight), isTrue,
          reason: '$label: card $card ends off screen ${screen()}');

      final cardWidget = tester.widget<TourCard>(currentCard());
      if (cardWidget.onPrevious != null) {
        expect(inCard(previousText), findsOneWidget,
            reason: '$label: Previous button not tappable');
      }
      if (cardWidget.onNext != null) {
        expect(inCard(cardWidget.nextLabel ?? nextText), findsOneWidget,
            reason: '$label: Next button not tappable');
      }

      if (!expectTarget) return;
      final target = currentTarget();
      expect(target, isNot(Rect.zero),
          reason: '$label: nothing is highlighted');
      expect(screen().overlaps(target), isTrue,
          reason: '$label: highlighted element $target is off screen');
      final overlap = card.intersect(target);
      final covered = overlap.width <= 0 || overlap.height <= 0
          ? 0.0
          : overlap.width * overlap.height / (target.width * target.height);
      expect(covered, lessThan(0.5),
          reason: '$label: card $card covers ${(covered * 100).round()}% '
              'of the highlighted element $target');
    }

    Future<void> tapInCard(String text, String label) async {
      await dismissUpdateDialog();
      expect(await waitFor(inCard(text), maxSeconds: 10), isTrue,
          reason: '$label: "$text" not tappable');
      await tester.tap(inCard(text).first);
      await tester.pump(const Duration(milliseconds: 300));
    }

    // ── Menu part ──────────────────────────────────────────
    Future<void> checkMenuStep(TourStep expected) async {
      final label = 'menu ${expected.name}';
      expect(
          await waitUntil(() =>
              tour().isTourActive &&
              tour().currentTourStep == expected &&
              currentCard().evaluate().isNotEmpty),
          isTrue,
          reason: '$label: expected this menu card, '
              'tour is at ${tour().currentTourStep}');
      // Let navigation (e.g. into Select Play Mode) and the card settle.
      await settleCard();
      final card = tester.widget<TourCard>(currentCard());
      expect(card.progress,
          TourProgress.menuLabel(tester.element(currentCard()), expected),
          reason: '$label: progress label');
      expect(card.title, isNotEmpty, reason: '$label: title');
      if (expected != TourStep.welcome) await settleTarget();
      checkLayout(label, expectTarget: expected != TourStep.welcome);
      await saveShot(label);
      step('checked $label');
    }

    // ── Practice part ──────────────────────────────────────
    String lessonKey(int i) => TutorialScript.lessons[i].key;

    bool atLesson(int index, TutorialPhase phase) {
      final t = tutorial();
      return t.isActive && t.lessonIndex == index && t.phase == phase;
    }

    /// At lesson [index] in [phase] or a later phase of it, or past it.
    bool reached(int index, TutorialPhase phase) {
      final t = tutorial();
      if (!t.isActive) return false;
      return t.lessonIndex > index ||
          (t.lessonIndex == index && t.phase.index >= phase.index);
    }

    /// The seeded data a lesson's real game must hold right after it's set
    /// up — checked whether it was reached with Next or Previous.
    Future<void> checkSeed(int index) async {
      final lesson = TutorialScript.lessons[index];
      final label = 'lesson ${lesson.key}';
      if (lesson.turnSeed case final seed?) {
        final ok = await waitUntil(() {
          final screen = find.byType(PlayScreen);
          if (screen.evaluate().isEmpty) return false;
          final s =
              BlocProvider.of<TurnBloc>(tester.element(screen.first)).state;
          return s.isTutorial &&
              s.requirementString == seed.requirementString &&
              s.expect == seed.expect &&
              s.questionExpression == seed.questionExpression;
        }, maxSeconds: 10);
        expect(ok, isTrue,
            reason: '$label: game not set up with "${seed.requirementString}"');
      }
      if (lesson.combatSeed case final seed?) {
        final ok = await waitUntil(() {
          final screen = find.byType(CombatPlayScreen);
          if (screen.evaluate().isEmpty) return false;
          final s =
              BlocProvider.of<CombatBloc>(tester.element(screen.first)).state;
          return s.isTutorial &&
              s.requirementString == seed.requirementString &&
              s.expect == seed.expect &&
              s.opponentLives == seed.opponentLives;
        }, maxSeconds: 10);
        expect(ok, isTrue,
            reason:
                '$label: match not set up with "${seed.requirementString}"');
      }
    }

    /// Checks the card of lesson [index] in [phase] — skipped (and logged)
    /// if the lesson already moved on by itself, which one that only watches
    /// a short real timer can do before there's a stable card to check.
    Future<void> checkLesson(int index, TutorialPhase phase) async {
      final lesson = TutorialScript.lessons[index];
      final label = 'lesson ${lesson.key} (${phase.name})';
      final arrived = await waitUntil(
          () => atLesson(index, phase) && currentCard().evaluate().isNotEmpty);
      if (!arrived) {
        final t = tutorial();
        expect(reached(index, phase) || !t.isActive, isTrue,
            reason: '$label: expected this card, tutorial is at '
                '${lessonKey(t.lessonIndex)} (${t.phase.name})');
        step('skipped $label — it already moved on by itself');
        return;
      }
      await settleCard();
      if (!atLesson(index, phase) || currentCard().evaluate().isEmpty) {
        step('skipped $label — it moved on while settling');
        return;
      }
      final context = tester.element(currentCard());
      final card = tester.widget<TourCard>(currentCard());
      expect(card.title, tutorialLessonTitle(context, lesson),
          reason: '$label: title');
      expect(card.progress, TourProgress.lessonLabel(context, index),
          reason: '$label: progress label');
      final spotlight = phase == TutorialPhase.result
          ? lesson.resultSpotlight ?? lesson.spotlight
          : lesson.spotlight;
      final expectTarget = spotlight != TutorialSpotlight.wholeScreen;
      if (expectTarget) await settleTarget();
      if (!atLesson(index, phase)) {
        step('skipped $label — it moved on while settling');
        return;
      }
      checkLayout(label, expectTarget: expectTarget);
      await saveShot(label);
      step('checked $label');
    }

    /// Does what the current lesson card asks — tap Next/Finish, tap the
    /// required key or answer, or wait for a real timer / scripted
    /// opponent — and waits for the tutorial to move on.
    Future<void> playOneStep() async {
      final before = tutorial();
      final lesson = before.lesson;
      final label = '${lesson.key} (${before.phase.name})';
      step('playing $label');
      if (before.phase == TutorialPhase.result ||
          (before.phase == TutorialPhase.explain &&
              lesson.interaction == TutorialInteraction.next)) {
        await tapInCard(before.isLastLesson ? finishText : nextText, label);
      } else if (before.phase == TutorialPhase.explain &&
          lesson.interaction == TutorialInteraction.tapKey) {
        final key =
            find.byKey(TourKeys.keypadKeys[lesson.requiredKey]!).hitTestable();
        expect(await waitFor(key, maxSeconds: 10), isTrue,
            reason: '$label: highlighted key not tappable');
        await tester.tap(key.first);
      } else if (before.phase == TutorialPhase.explain &&
          lesson.interaction == TutorialInteraction.tapButton) {
        final button = find
            .byKey(TourKeys.pickRightButtonKeys[lesson.requiredButtonIndex!])
            .hitTestable();
        expect(await waitFor(button, maxSeconds: 10), isTrue,
            reason: '$label: highlighted answer not tappable');
        await tester.tap(button.first);
      }
      // `watch` lessons / `acting`: the real game moves the tutorial on.
      final moved = await waitUntil(() {
        final t = tutorial();
        return !t.isActive ||
            t.lessonIndex != before.lessonIndex ||
            t.phase != before.phase ||
            t.seedToken != before.seedToken;
      }, maxSeconds: 25);
      expect(moved, isTrue, reason: '$label: tutorial never moved on');
    }

    /// Plays forward until lesson [index] is in [phase] — or in a later
    /// phase of it: a lesson that only watches a short real timer can be
    /// past its explain card before there's a chance to see it.
    Future<void> playTo(int index, TutorialPhase phase) async {
      for (int guard = 0; guard < 40; guard++) {
        final t = tutorial();
        if (t.isActive &&
            t.lessonIndex == index &&
            t.phase.index >= phase.index) {
          return;
        }
        expect(t.isActive, isTrue,
            reason: 'practice ended before reaching ${lessonKey(index)}');
        expect(t.lessonIndex <= index, isTrue,
            reason: 'went past ${lessonKey(index)} (${phase.name}) to '
                '${lessonKey(t.lessonIndex)}');
        await playOneStep();
      }
      fail('never reached ${lessonKey(index)} (${phase.name})');
    }

    /// The card a lesson rests on long enough to press Previous on: its
    /// explain card, unless it only watches a real timer/opponent (that
    /// card moves on by itself) — then its result card, if it has one.
    TutorialPhase? restingPhase(TutorialLessonData lesson) {
      if (lesson.interaction != TutorialInteraction.watch) {
        return TutorialPhase.explain;
      }
      return lesson.hasResultBeat ? TutorialPhase.result : null;
    }

    // ── Setup ──────────────────────────────────────────────
    FcmService.disablePermissionRequestForTest = true;
    AiGreetingService.disableForTest = true;
    CombatBleService.disableForTest = true;
    TourKeys.reset();

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetDisplayFeatures();
    });

    // Device / orientation / font-size come in via --dart-define so the whole
    // matrix (phone|ipad|fold cover × portrait|landscape × min|max font) runs
    // from this one file. Defaults are a phone in portrait, default font.
    const ipad = bool.fromEnvironment('IPAD', defaultValue: false);
    const landscape = bool.fromEnvironment('LANDSCAPE', defaultValue: false);
    const injectedFontSize = int.fromEnvironment('FONT_SIZE', defaultValue: -1);

    // FOLD_COVER: a Galaxy Z Fold7 closed, on its 1080x2520 cover screen —
    // the one foldable posture the Android emulator can't show natively (its
    // "closed" posture keeps reporting the inner display to the app).
    const foldCover = bool.fromEnvironment('FOLD_COVER', defaultValue: false);

    final portraitSize = ipad
        ? const Size(1640, 2360)
        : foldCover
            ? const Size(1080, 2520)
            : const Size(1080, 2400);
    step('forcing ${ipad ? 'ipad' : foldCover ? 'fold cover' : 'phone'} '
        '${landscape ? 'landscape' : 'portrait'} physical size');
    tester.view.physicalSize = landscape ? portraitSize.flipped : portraitSize;
    tester.view.devicePixelRatio = ipad
        ? 2.0
        : foldCover
            ? 2.8125
            : 2.625;
    // The forced size is a different screen from the device's own, so its
    // real hinge (e.g. a foldable emulator's inner-screen fold) doesn't
    // apply — and would otherwise split this window into panes.
    tester.view.displayFeatures = const [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool(PreferencesKey.IS_MUTED, true);
    await prefs.setString(PreferencesKey.LOCALE, localeCode);
    if (injectedFontSize >= 0) {
      await prefs.setInt(PreferencesKey.FONT_SIZE, injectedFontSize);
    }
    // Deliberately NOT marking has_completed_tour — the tour must auto-start.

    step('calling app.main()');
    app.main();

    // ── Part 1: main menu, forwards and back ───────────────
    const menuSteps = TourProgress.menuSteps;
    for (int k = 0; k < menuSteps.length; k++) {
      await checkMenuStep(menuSteps[k]);
      if (k > 0) {
        step('menu ${menuSteps[k].name}: Previous');
        await tapInCard(previousText, menuSteps[k].name);
        await checkMenuStep(TourProgress.previousBefore(menuSteps[k])!);
        await tapInCard(nextText, menuSteps[k - 1].name);
        await checkMenuStep(menuSteps[k]);
      }
      step('menu ${menuSteps[k].name}: Next');
      await tapInCard(nextText, menuSteps[k].name);
    }

    // ── Parts 2-4: practice, every lesson forwards and back ─
    expect(await waitFor(find.byType(PlayScreen), maxSeconds: 20), isTrue,
        reason: 'entering the practice should land on PlayScreen');

    for (int i = 0; i < TutorialScript.length; i++) {
      final lesson = TutorialScript.lessons[i];
      await playTo(i, TutorialPhase.explain);
      await checkSeed(i);
      await checkLesson(i, TutorialPhase.explain);

      final resting = restingPhase(lesson);
      if (resting == TutorialPhase.result) {
        await playTo(i, TutorialPhase.result);
        await checkLesson(i, TutorialPhase.result);
      }

      if (resting != null) {
        step('lesson ${lesson.key}: Previous');
        await tapInCard(previousText, lesson.key);
        if (i == 0) {
          // Back out of the practice into the last menu step, then in again.
          await checkMenuStep(TourProgress.menuSteps.last);
          await tapInCard(nextText, 'menu ${TourProgress.menuSteps.last.name}');
        } else {
          final back = TutorialCubit.previousSeededIndex(i);
          // Lands on [back] — a short timer lesson may already be past its
          // explain card, but never past where Previous was pressed.
          expect(
              await waitUntil(() =>
                  reached(back, TutorialPhase.explain) &&
                  tutorial().lessonIndex <= back),
              isTrue,
              reason: 'Previous from ${lesson.key} should land on '
                  '${lessonKey(back)}, is at '
                  '${lessonKey(tutorial().lessonIndex)}');
          await checkSeed(back);
          await checkLesson(back, TutorialPhase.explain);
        }
        // Play forward again to where Previous was pressed.
        await playTo(i, resting);
        await checkLesson(i, resting);
      }

      // Finish this lesson the normal way.
      if (i == TutorialScript.length - 1) {
        await playTo(i, TutorialPhase.explain);
        await tapInCard(finishText, lesson.key);
      } else {
        await playTo(i + 1, TutorialPhase.explain);
      }
    }

    // ── Teardown ───────────────────────────────────────────
    step('asserting a clean return to SelectPlayModeScreen');
    expect(await waitUntil(() => !tutorial().isActive), isTrue,
        reason: 'Finish should end the practice');
    expect(await waitFor(find.byType(SelectPlayModeScreen), maxSeconds: 15),
        isTrue,
        reason: 'Finish should return to the play-mode picker');
    expect(await waitUntil(() => !tour().isTourActive), isTrue,
        reason: 'Finish should complete the tour');
    expect(find.text(appL10n.tourSkip), findsNothing,
        reason: 'no tour card should be left behind');
    step('done');
  });
}
