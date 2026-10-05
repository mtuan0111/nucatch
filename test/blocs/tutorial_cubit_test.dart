import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/tutorial_script.dart';

void main() {
  group('TutorialCubit', () {
    test('initial state is inactive at lesson 0', () {
      final cubit = TutorialCubit();
      expect(cubit.state.isActive, isFalse);
      expect(cubit.state.lessonIndex, 0);
      expect(cubit.state.phase, TutorialPhase.explain);
      cubit.close();
    });

    test('start() activates the tutorial at the first lesson and bumps seedToken', () {
      final cubit = TutorialCubit();
      final initialToken = cubit.state.seedToken;
      cubit.start();
      expect(cubit.state.isActive, isTrue);
      expect(cubit.state.lessonIndex, 0);
      expect(cubit.state.phase, TutorialPhase.explain);
      expect(cubit.state.seedToken, initialToken + 1);
      cubit.close();
    });

    test('next() advances the lesson pointer and resets phase to explain', () {
      final cubit = TutorialCubit();
      cubit.start();
      cubit.next();
      expect(cubit.state.lessonIndex, 1);
      expect(cubit.state.phase, TutorialPhase.explain);
      cubit.close();
    });

    test('next() bumps seedToken when crossing into a lesson with a turnSeed', () {
      final cubit = TutorialCubit();
      cubit.start();
      final tokenAfterStart = cubit.state.seedToken;
      // Lesson 0 -> 1 (RegularWelcome -> RegularMemorize) reseeds since
      // RegularMemorize carries its own turnSeed.
      cubit.next();
      expect(TutorialScript.lessons[1].turnSeed, isNotNull);
      expect(cubit.state.seedToken, greaterThan(tokenAfterStart));
      cubit.close();
    });

    test('next() does not bump seedToken for a lesson with no seed and same arc', () {
      // The first lesson that has no seed of its own and stays in the same
      // arc as the one before it (e.g. RegularMemorize -> RegularTypeBack).
      final lessons = TutorialScript.lessons;
      final target = [
        for (var i = 1; i < lessons.length; i++)
          if (lessons[i].turnSeed == null &&
              lessons[i].combatSeed == null &&
              lessons[i].arc == lessons[i - 1].arc)
            i,
      ].first;
      final cubit = TutorialCubit();
      cubit.start();
      for (var i = 0; i < target - 1; i++) {
        cubit.next();
      }
      final tokenBefore = cubit.state.seedToken;
      cubit.next();
      expect(cubit.state.lessonIndex, target);
      expect(cubit.state.seedToken, tokenBefore);
      cubit.close();
    });

    test('next() on the last lesson finishes the tutorial', () {
      final cubit = TutorialCubit();
      cubit.start();
      for (var i = 0; i < TutorialScript.length - 1; i++) {
        cubit.next();
      }
      expect(cubit.state.isLastLesson, isTrue);
      cubit.next();
      expect(cubit.state.isActive, isFalse);
      cubit.close();
    });

    test('previous() is a no-op on the first lesson', () {
      final cubit = TutorialCubit();
      cubit.start();
      cubit.previous();
      expect(cubit.state.lessonIndex, 0);
      expect(cubit.state.isActive, isTrue);
      cubit.close();
    });

    test('previous() moves back a lesson once past the first', () {
      final cubit = TutorialCubit();
      cubit.start();
      cubit.next();
      cubit.next();
      cubit.previous();
      expect(cubit.state.lessonIndex, 1);
      cubit.close();
    });

    test('finish() resets to a fresh inactive state', () {
      final cubit = TutorialCubit();
      cubit.start();
      cubit.next();
      cubit.finish();
      expect(cubit.state.isActive, isFalse);
      expect(cubit.state.lessonIndex, 0);
      cubit.close();
    });

    test('onActionResolved() moves straight to result phase for lessons with a result beat', () {
      final cubit = TutorialCubit();
      cubit.start();
      final index =
          TutorialScript.lessons.indexWhere((l) => l.hasResultBeat);
      expect(index, greaterThanOrEqualTo(0));
      for (var i = 0; i < index; i++) {
        cubit.next();
      }
      expect(cubit.state.lesson.hasResultBeat, isTrue);
      cubit.onActionResolved();
      expect(cubit.state.phase, TutorialPhase.result);
      expect(cubit.state.lessonIndex, index);
      cubit.close();
    });

    test('onActionResolved() advances directly for lessons with no result beat', () {
      final cubit = TutorialCubit();
      cubit.start();
      final index = TutorialScript.lessons
          .indexWhere((l) => !l.hasResultBeat && l.key != TutorialScript.lessons.last.key);
      for (var i = 0; i < index; i++) {
        cubit.next();
      }
      expect(cubit.state.lesson.hasResultBeat, isFalse);
      cubit.onActionResolved();
      expect(cubit.state.lessonIndex, index + 1);
      expect(cubit.state.phase, TutorialPhase.explain);
      cubit.close();
    });

    test('onActionResolved() is a no-op once already in result phase', () {
      final cubit = TutorialCubit();
      cubit.start();
      final index =
          TutorialScript.lessons.indexWhere((l) => l.hasResultBeat);
      for (var i = 0; i < index; i++) {
        cubit.next();
      }
      cubit.onActionResolved();
      expect(cubit.state.phase, TutorialPhase.result);
      cubit.onActionResolved();
      expect(cubit.state.lessonIndex, index);
      expect(cubit.state.phase, TutorialPhase.result);
      cubit.close();
    });

    test('onActionStarted() moves explain -> acting while active', () {
      final cubit = TutorialCubit();
      cubit.start();
      cubit.onActionStarted();
      expect(cubit.state.phase, TutorialPhase.acting);
      cubit.close();
    });

    test('onActionStarted()/onActionResolved()/next()/previous() are no-ops when inactive', () {
      final cubit = TutorialCubit();
      cubit.onActionStarted();
      cubit.onActionResolved();
      cubit.next();
      cubit.previous();
      expect(cubit.state.isActive, isFalse);
      expect(cubit.state.lessonIndex, 0);
      cubit.close();
    });
  });

  group('TutorialState', () {
    test('lesson resolves via TutorialScript.at', () {
      const state = TutorialState(lessonIndex: 3);
      expect(state.lesson, TutorialScript.lessons[3]);
    });

    test('displayNumber and totalLessons are 1-indexed / full-length', () {
      const state = TutorialState(lessonIndex: 0);
      expect(state.displayNumber, 1);
      expect(state.totalLessons, TutorialScript.length);
    });

    test('isFirstLesson / isLastLesson bounds', () {
      const first = TutorialState(lessonIndex: 0);
      final last = TutorialState(lessonIndex: TutorialScript.length - 1);
      expect(first.isFirstLesson, isTrue);
      expect(last.isLastLesson, isTrue);
    });
  });
}
