import 'package:nucatch/helpers/tutorial_script.dart';

enum TutorialPhase { explain, acting, result }

/// State for the in-game rule tutorial (see `tutorial_cubit.dart`).
///
/// Deliberately holds no bloc references — `TurnBloc`/`PlayerNavCubit`/
/// `CombatNavCubit` only exist while inside the "Play" branch of the menu,
/// and `CombatBloc` is recreated from scratch every time combat mode is
/// entered, so this state can be provided once at the app root and survive
/// every navigation transition unmodified. Actual bloc-seeding is done by
/// small per-screen listener widgets that watch this state (see
/// `play_screen.dart`/`combat_play_screen.dart`), not by the cubit itself.
class TutorialState {
  final bool isActive;

  /// Index into the single flat `TutorialScript.lessons` list spanning all
  /// three arcs (regular, pick-right, combat).
  final int lessonIndex;
  final TutorialPhase phase;

  /// Bumped every time a lesson is (re-)seeded into a real bloc, so screen
  /// listeners can distinguish "the same lesson was reseeded" from "an
  /// unrelated rebuild happened".
  final int seedToken;

  /// True when the practice was left with Previous on its first lesson —
  /// back into the main-menu tour, which is still running — rather than
  /// finished or skipped. Teardown listeners use it to reset the game
  /// without marking the whole tour as completed.
  final bool backedOutToMenuTour;

  const TutorialState({
    this.isActive = false,
    this.lessonIndex = 0,
    this.phase = TutorialPhase.explain,
    this.seedToken = 0,
    this.backedOutToMenuTour = false,
  });

  TutorialLessonData get lesson => TutorialScript.at(lessonIndex);
  bool get isFirstLesson => lessonIndex == 0;
  bool get isLastLesson => lessonIndex == TutorialScript.length - 1;
  int get displayNumber => lessonIndex + 1;
  int get totalLessons => TutorialScript.length;

  TutorialState copyWith({
    bool? isActive,
    int? lessonIndex,
    TutorialPhase? phase,
    int? seedToken,
    bool? backedOutToMenuTour,
  }) {
    return TutorialState(
      isActive: isActive ?? this.isActive,
      lessonIndex: lessonIndex ?? this.lessonIndex,
      phase: phase ?? this.phase,
      seedToken: seedToken ?? this.seedToken,
      backedOutToMenuTour: backedOutToMenuTour ?? this.backedOutToMenuTour,
    );
  }
}
