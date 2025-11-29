import 'dart:developer';

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

  const TurnState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 0,
    this.difficultyModel,
    this.lifeRemaining = 3,
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
    );
  }

  String get levelAndTimeCorrect {
    return "$level - ${timesCorrect + 1}";
  }

  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => expect == typing;

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

    return tapTimerRemaining / tapTimerDuration * 100;
  }
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
