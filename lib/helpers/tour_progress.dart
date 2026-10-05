import 'package:flutter/widgets.dart';
import 'package:skeleton_core/skeleton_core.dart' show TourStep, coreLang;
import 'package:nucatch/helpers/const.dart' show lang;
import 'package:nucatch/helpers/tutorial_script.dart';

/// How the onboarding tour is organised: four short parts — the main menu,
/// then hands-on practice of Regular, Pick Right and Combat — each counted
/// on its own ("Regular · 3 / 8"), so the player always knows which part
/// they're in and how much of it is left.
abstract final class TourProgress {
  /// The menu part, in order. skeleton_core's [TourStep] has more values
  /// (Combat / Create Room / Join Room / Settings / About each had their
  /// own card); they're folded into these five so the menu part stays
  /// short — "Play modes" covers both play-mode cards, "More" covers Top
  /// Score, Settings and About together.
  static const List<TourStep> menuSteps = [
    TourStep.welcome,
    TourStep.startButton,
    TourStep.soloMode, // "Two ways to play": Solo + Combat
    TourStep.instantStart,
    TourStep.leaderboard, // "More to explore": Top Score, Settings, About
  ];

  /// Where Next goes from [step]: the following menu step, or the in-game
  /// practice after the last one. A step not in [menuSteps] (e.g. one saved
  /// mid-tour by an older version) moves on to the first listed step that
  /// came after it in that version's order.
  static TourStep nextAfter(TourStep step) {
    final i = menuSteps.indexOf(step);
    if (i >= 0) {
      return i + 1 < menuSteps.length
          ? menuSteps[i + 1]
          : TourStep.gameTutorialStep1;
    }
    return menuSteps.firstWhere(
      (s) => s.index > step.index,
      orElse: () => TourStep.gameTutorialStep1,
    );
  }

  /// Where Previous goes from [step] — the menu step before it, or null on
  /// the first. From the in-game practice that's the last menu step.
  static TourStep? previousBefore(TourStep step) {
    final i = menuSteps.indexOf(step);
    if (i >= 0) return i > 0 ? menuSteps[i - 1] : null;
    if (step.name.startsWith('gameTutorial')) return menuSteps.last;
    for (final s in menuSteps.reversed) {
      if (s.index < step.index) return s;
    }
    return null;
  }

  /// (position, count) of [step] within the menu part, 1-based.
  static (int, int) menuPosition(TourStep step) =>
      (menuSteps.indexOf(step) + 1, menuSteps.length);

  /// (position, count) of lesson [lessonIndex] within its practice part,
  /// 1-based.
  static (int, int) lessonPosition(int lessonIndex) {
    final lesson = TutorialScript.at(lessonIndex);
    final part =
        TutorialScript.lessons.where((l) => l.arc == lesson.arc).toList();
    return (part.indexOf(lesson) + 1, part.length);
  }

  static String menuLabel(BuildContext context, TourStep step) {
    final (position, count) = menuPosition(step);
    return '${coreLang(context).mainMenu} · $position / $count';
  }

  static String lessonLabel(BuildContext context, int lessonIndex) {
    final (position, count) = lessonPosition(lessonIndex);
    final part = switch (TutorialScript.at(lessonIndex).arc) {
      TutorialArc.regular => lang(context).tourChapterRegular,
      TutorialArc.pickRight => lang(context).pickRightTitle,
      TutorialArc.combat => lang(context).combatMode,
    };
    return '$part · $position / $count';
  }
}
