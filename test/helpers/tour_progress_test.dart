import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/tour_progress.dart';
import 'package:nucatch/helpers/tutorial_script.dart';

void main() {
  test('the menu tour and in-game lessons share one continuous count', () {
    final total = TourProgress.menuStepCount + TutorialScript.length;
    expect(TourProgress.menuStepCount, 10);
    expect(TourProgress.menuLabel(0), '1 / $total');
    expect(TourProgress.menuLabel(9), '10 / $total');
    // The first lesson picks up right after the last menu step.
    expect(TourProgress.lessonLabel(0), '11 / $total');
    expect(TourProgress.lessonLabel(TutorialScript.length - 1),
        '$total / $total');
  });
}
