import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/models/turn_record_model.dart';

enum TurnStatus {
  intro,
  initial,
  correct,
  playing,

  rest,

  gameOver,
}

class TurnState {
  final int level;
  final int timesCorrect;
  final int point;
  final DifficultyModel? difficultyModel; // Default difficulty

  final int lifeRemaining;

  final String? requirementString;
  final String? expect;
  final String typing;
  final TurnStatus status;
  final int countDown;
  final TurnRecordedModel? recordedItem;

  final bool isLoading;
  final String? message;
  final bool saveSuccess;

  final double tapTimerRemaining; // Remaining time in seconds (0-20)
  final bool isTimerPaused;

  // Pick Right mode fields
  final String? trueEquation; // The correct equation
  final String? falseEquation; // The incorrect equation (backward compatible)
  final bool?
      isLeftCorrect; // True if left button has correct answer (backward compatible)
  final int?
      selectedOption; // 0, 1, or 2 for selected button, null=not selected
  final int? correctIndex; // Index of correct button (0, 1, or 2)
  final List<String>? equations; // List of 3 result options in display order
  final String? questionExpression; // Shared calculation question (e.g. '5 + 3 = ?')
  final bool pickRightJustCorrect; // Animation flag: scale+fade-out on correct
  final bool pickRightShowCorrect; // Flag: show correct answer after wrong pick

  /// True while a scripted lesson from the in-game rule tutorial is
  /// playing. Suppresses the real Firestore leaderboard write in
  /// `TurnBloc._onSaveRecorded` — the engine itself is never forked (a
  /// tutorial lesson's timer/tap/reset/game-over consequences are all real),
  /// only the persistence side effect is skipped.
  final bool isTutorial;

  /// Bumped every `SeedTutorialTurn`. Lets a real event's own delayed
  /// continuation (e.g. `_onResetNewNumber`'s post-reset `SetLevel` call)
  /// detect that a *later* tutorial lesson has already reseeded the state
  /// out from under it, and bail instead of clobbering that reseed —
  /// otherwise a lesson whose real consequence lands fast enough to
  /// auto-advance the tutorial (no result beat to wait for) can race a
  /// slower-maturing side effect from the tap that triggered it.
  final int tutorialGeneration;

  const TurnState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 0,
    this.difficultyModel,
    this.lifeRemaining = kSoloInitialLives,
    this.requirementString,
    this.expect,
    this.status = TurnStatus.initial,
    this.typing = "",
    this.countDown = 0,
    this.recordedItem,
    this.isLoading = false,
    this.message,
    this.saveSuccess = false,
    this.tapTimerRemaining = tapTimerDuration,
    this.isTimerPaused = false,
    this.trueEquation,
    this.falseEquation,
    this.isLeftCorrect,
    this.selectedOption,
    this.correctIndex,
    this.equations,
    this.questionExpression,
    this.pickRightJustCorrect = false,
    this.pickRightShowCorrect = false,
    this.isTutorial = false,
    this.tutorialGeneration = 0,
  });

  TurnState copyWith({
    int? level,
    int? timesCorrect,
    int? point,
    DifficultyModel? difficultyModel,
    int? lifeRemaining,
    String? requirementString,
    String? expect,
    String? typing,
    TurnStatus? status,
    int? countDown,
    TurnRecordedModel? recordedItem,
    bool? isLoading,
    String? message,
    bool? saveSuccess,
    double? tapTimerRemaining,
    bool? isTimerPaused,
    String? trueEquation,
    String? falseEquation,
    bool? isLeftCorrect,
    int? selectedOption,
    int? correctIndex,
    List<String>? equations,
    String? questionExpression,
    bool? pickRightJustCorrect,
    bool? pickRightShowCorrect,
    bool? isTutorial,
    int? tutorialGeneration,
  }) {
    return TurnState(
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      point: point ?? this.point,
      difficultyModel: difficultyModel ?? this.difficultyModel,
      lifeRemaining: lifeRemaining != null
          ? (lifeRemaining < 0 ? 0 : lifeRemaining)
          : this.lifeRemaining,
      requirementString: requirementString ?? this.requirementString,
      expect: expect ?? this.expect,
      typing: typing ?? this.typing,
      status: status ?? this.status,
      countDown: countDown ?? this.countDown,
      recordedItem: recordedItem ?? this.recordedItem,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      tapTimerRemaining: tapTimerRemaining ?? this.tapTimerRemaining,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      trueEquation: trueEquation ?? this.trueEquation,
      falseEquation: falseEquation ?? this.falseEquation,
      isLeftCorrect: isLeftCorrect ?? this.isLeftCorrect,
      selectedOption: selectedOption ?? this.selectedOption,
      correctIndex: correctIndex ?? this.correctIndex,
      equations: equations ?? this.equations,
      questionExpression: questionExpression ?? this.questionExpression,
      pickRightJustCorrect: pickRightJustCorrect ?? this.pickRightJustCorrect,
      pickRightShowCorrect: pickRightShowCorrect ?? this.pickRightShowCorrect,
      isTutorial: isTutorial ?? this.isTutorial,
      tutorialGeneration: tutorialGeneration ?? this.tutorialGeneration,
    );
  }

  String get levelAndTimeCorrect {
    return "$level - ${timesCorrect + 1}";
  }

  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => (expect?.isNotEmpty ?? false) && expect == typing;

  int get getTimeShowTarget => 1000 + level * diffShowLevelMilisecond;

  bool get isExpectNotEmpty => expect?.isNotEmpty ?? false;
  bool get isTypingNotEmpty => typing.isNotEmpty;

  bool get isShowExpect =>
      status == TurnStatus.initial && isExpectNotEmpty && !isTypingNotEmpty;

  bool get isTimeForTyping =>
      (status == TurnStatus.playing
      // || !isShowExpect
      ) &&
      (isExpectNotEmpty || isTypingNotEmpty);

  bool get isCorrectAnimate => isFinishTarget;

  // bool get isAbleToTap => isExpectNotEmpty && !isFinishTarget;

  bool get isAbleToTap =>
      // -> let user able to quick tap
      // (status == TurnStatus.playing) &&
      isExpectNotEmpty && !isFinishTarget;

  bool get isAbleToReset => status == TurnStatus.playing && lifeRemaining > 1;
  bool get isAbleToContinue => lifeRemaining > 0;

  bool get isAbleToLevelUp =>
      timesCorrect >= difficultyModel!.numberTurnEachLevel;

  double get tapTimerPercent {
    // log("Calculating tap timer percent: remaining $tapTimerRemaining / duration $tapTimerDuration");
    // Use a small epsilon to handle floating-point precision errors
    const epsilon = 0.1;
    if (tapTimerRemaining <= epsilon) {
      return 0.0;
    }

    return tapTimerRemaining / effectiveTimerDuration * 100;
  }

  /// Get the effective timer duration from DifficultyModel, or fallback to global constant
  double get effectiveTimerDuration =>
      difficultyModel?.timeLimitPerTurn.toDouble() ?? tapTimerDuration;
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
