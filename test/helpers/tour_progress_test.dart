import 'package:flutter_test/flutter_test.dart';
import 'package:skeleton_core/skeleton_core.dart' show TourStep;
import 'package:nucatch/helpers/tour_progress.dart';
import 'package:nucatch/helpers/tutorial_script.dart';

void main() {
  group('TourProgress', () {
    test('the menu part is five steps, counted on its own', () {
      expect(TourProgress.menuSteps.length, 5);
      expect(TourProgress.menuPosition(TourStep.welcome), (1, 5));
      expect(TourProgress.menuPosition(TourStep.leaderboard), (5, 5));
    });

    test('Next walks the menu steps, then enters the practice', () {
      final visited = <TourStep>[TourStep.welcome];
      while (visited.last != TourStep.gameTutorialStep1) {
        visited.add(TourProgress.nextAfter(visited.last));
      }
      expect(visited, [...TourProgress.menuSteps, TourStep.gameTutorialStep1]);
    });

    test('Previous walks back, and stops at the first step', () {
      expect(TourProgress.previousBefore(TourStep.welcome), isNull);
      expect(TourProgress.previousBefore(TourStep.instantStart),
          TourStep.soloMode);
      expect(TourProgress.previousBefore(TourStep.gameTutorialStep1),
          TourProgress.menuSteps.last);
    });

    test('a step no longer in the tour moves on to the next listed one', () {
      // An old tour had already shown Instant Start and Solo by Combat.
      expect(TourProgress.nextAfter(TourStep.combatMode),
          TourStep.leaderboard);
      expect(TourProgress.nextAfter(TourStep.about),
          TourStep.gameTutorialStep1);
    });

    test('each practice part restarts its own count', () {
      final firstOfEachPart = <TutorialArc, int>{};
      for (var i = 0; i < TutorialScript.length; i++) {
        firstOfEachPart.putIfAbsent(TutorialScript.at(i).arc, () => i);
      }
      for (final start in firstOfEachPart.values) {
        expect(TourProgress.lessonPosition(start).$1, 1);
      }
      final (lastPosition, lastCount) =
          TourProgress.lessonPosition(TutorialScript.length - 1);
      expect(lastPosition, lastCount);
    });
  });
}
