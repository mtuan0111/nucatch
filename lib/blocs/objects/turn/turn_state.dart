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
  final List<String>? equations; // List of 3 equations in display order

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
