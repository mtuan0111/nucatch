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
      backedOutToMenuTour: false,
    ));
  }

  /// Leaves the practice from its first lesson with Previous, back into the
  /// main-menu tour (which the caller points at its last step). Like
  /// [finish] it ends the practice, but flagged so teardown listeners reset
  /// the game without completing the tour; the menu tour's Next calls
  /// [start] again.
  void backToMenuTour() {
    emit(const TutorialState(backedOutToMenuTour: true));
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
  /// button routes back to the main-menu walkthrough instead, matching how
  /// the main-menu tour's own Previous button behaves.
  ///
  /// Lands on the nearest earlier lesson that sets the game up itself (has
  /// a `turnSeed`/`combatSeed`). A lesson without one continues from the
  /// state the lesson before it left behind — Type It Back needs the number
  /// Memorize It just flashed, Opponent's Turn needs your turn to have just
  /// passed, a wrap-up needs the game that just ended — so stepping back
  /// into it directly would leave the game showing the data of the lesson
  /// the player came from (a different number, a different question).
  void previous() {
    if (!state.isActive || state.isFirstLesson) return;
    emit(state.copyWith(
      lessonIndex: previousSeededIndex(state.lessonIndex),
      phase: TutorialPhase.explain,
      seedToken: state.seedToken + 1,
    ));
  }

  /// The lesson [previous] goes back to from [lessonIndex]; see there.
  static int previousSeededIndex(int lessonIndex) {
    var target = lessonIndex - 1;
    while (target > 0 && !_setsUpGame(TutorialScript.lessons[target])) {
      target--;
    }
    return target;
  }

  static bool _setsUpGame(TutorialLessonData lesson) =>
      lesson.turnSeed != null || lesson.combatSeed != null;

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
