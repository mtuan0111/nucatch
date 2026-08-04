import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/tutorial_script.dart';

/// Drives the in-game rule tutorial's lesson pointer.
///
/// Holds no bloc references at all — see `TutorialState`'s doc comment for
/// why. Public methods are the "events"; screens that host a lesson call
/// these directly in response to real bloc state changes they observe
/// (e.g. "the real turn timer just expired" -> `onActionResolved()`).
class TutorialCubit extends Cubit<TutorialState> {
  TutorialCubit() : super(const TutorialState());

  void start() {
    emit(state.copyWith(
      isActive: true,
      lessonIndex: 0,
      phase: TutorialPhase.explain,
      seedToken: state.seedToken + 1,
    ));
  }

  /// Ends the tutorial. Does not touch any bloc or navigate anywhere —
  /// whichever screen's Skip/Finish button called this is responsible for
  /// its own teardown (real bloc reset + navigation), then dispatches
  /// `TourBloc.add(TourCompleted())` once it observes `isActive` flip to
  /// false (`listenWhen: prev.isActive && !curr.isActive`).
  void finish() {
    emit(const TutorialState());
  }

  void next() {
    if (!state.isActive) return;
    if (state.isLastLesson) {
      finish();
      return;
    }
    final nextIndex = state.lessonIndex + 1;
    final reseed = TutorialScript.lessons[nextIndex].arc != state.lesson.arc ||
        TutorialScript.lessons[nextIndex].turnSeed != null ||
        TutorialScript.lessons[nextIndex].combatSeed != null;
    emit(state.copyWith(
      lessonIndex: nextIndex,
      phase: TutorialPhase.explain,
      seedToken: reseed ? state.seedToken + 1 : state.seedToken,
    ));
  }

  /// No-op on the first lesson — the widget hosting lesson 1's Previous
  /// button routes to `TourBloc.add(TourStepBack())` instead (back to the
  /// main-menu walkthrough), matching how the main-menu dialog tour's own
  /// Previous button behaves.
  void previous() {
    if (!state.isActive || state.isFirstLesson) return;
    emit(state.copyWith(
      lessonIndex: state.lessonIndex - 1,
      phase: TutorialPhase.explain,
      seedToken: state.seedToken + 1,
    ));
  }

  /// Called by a screen listener the instant it observes the real bloc
  /// leave its "waiting for input" state (e.g. the player just tapped the
  /// spotlighted key).
  void onActionStarted() {
    if (!state.isActive || state.phase != TutorialPhase.explain) return;
    emit(state.copyWith(phase: TutorialPhase.acting));
  }

  /// Called by a screen listener once it observes the real consequence has
  /// fully landed (a correct/incorrect answer settled, a timeout's
  /// aftermath finished, a combat turn resolved, ...).
  ///
  /// Accepts calls from either `explain` or `acting` — in practice, most
  /// lessons' consequences resolve quickly enough (a single digit tap, a
  /// ~1.5s seeded timeout) that screens call this directly from `explain`
  /// without ever calling `onActionStarted()` first; the tooltip staying
  /// visible throughout is actually desirable here; the player should be
  /// able to read the explanation *while* watching the timer/consequence
  /// play out, not have it vanish mid-lesson.
  void onActionResolved() {
    if (!state.isActive || state.phase == TutorialPhase.result) return;
    if (state.lesson.hasResultBeat) {
      emit(state.copyWith(phase: TutorialPhase.result));
    } else {
      next();
    }
  }
}
