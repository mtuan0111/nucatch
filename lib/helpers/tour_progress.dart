import 'package:skeleton_core/skeleton_core.dart' show TourStep;
import 'package:nucatch/helpers/tutorial_script.dart';

/// Numbering for the onboarding tour as one continuous sequence: the menu
/// tour's dialog steps (Welcome .. History & Rules), then the in-game rule
/// tutorial's lessons — "1 / 34" through "10 / 34" on the menu, carrying on
/// at "11 / 34" in-game, rather than "x / 16" (which counted skeleton_core's
/// unused `gameTutorial*` placeholder steps) restarting at "1 / 24".
abstract final class TourProgress {
  /// Every [TourStep] before `gameTutorialStep1` is a menu dialog step; the
  /// whole in-game tutorial then occupies that single slot.
  static int get menuStepCount => TourStep.gameTutorialStep1.index;

  static int get totalSteps => menuStepCount + TutorialScript.length;

  /// Label for menu-tour step [stepIndex] (0-based `TourState.currentStep`).
  static String menuLabel(int stepIndex) => '${stepIndex + 1} / $totalSteps';

  /// Label for in-game lesson [lessonIndex] (0-based).
  static String lessonLabel(int lessonIndex) =>
      '${menuStepCount + lessonIndex + 1} / $totalSteps';
}
