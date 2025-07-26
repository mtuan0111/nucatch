import 'package:flutter/material.dart';
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
  final int lifeRemaining;

  final String? expect;
  final String typing;
  final TurnStatus status;
  final int countDown;
  final TurnRecordedModel? recordedItem;

  final bool isLoading;
  final BuildContext context;

  TurnState(
    this.context, {
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 0,
    this.lifeRemaining = 3,
    this.expect,
    this.status = TurnStatus.initial,
    this.typing = "",
    this.countDown = 0,
    this.recordedItem,
    this.isLoading = false,
  });

  TurnState copyWith({
    BuildContext? context,
    int? level,
    int? timesCorrect,
    int? point,
    int? lifeRemaining,
    // int? currentTypingIndex,
    String? expect,
    String? typing,
    TurnStatus? status,
    int? countDown,
    TurnRecordedModel? recordedItem,
    bool? isLoading,
  }) {
    return TurnState(
      context ?? this.context,
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      point: point ?? this.point,
      lifeRemaining: lifeRemaining != null
          ? (lifeRemaining < 0 ? 0 : lifeRemaining)
          : this.lifeRemaining,
      // currentTypingIndex: currentTypingIndex ?? this.currentTypingIndex,
      expect: expect ?? this.expect,
      typing: typing ?? this.typing,
      status: status ?? this.status,
      countDown: countDown ?? this.countDown,
      recordedItem: recordedItem ?? this.recordedItem,
      isLoading: isLoading ?? this.isLoading,
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
      (status == TurnStatus.playing || !isShowExpect) &&
      (isExpectNotEmpty || isTypingNotEmpty);

  bool get isCorrectAnimate => isFinishTarget;

  // bool get isAbleToTap => isExpectNotEmpty && !isFinishTarget;

  bool get isAbleToTap =>
      // -> let user able to quick tap
      // (status == TurnStatus.playing) &&
      isExpectNotEmpty && !isFinishTarget;

  bool get isAbleToReset => status == TurnStatus.playing && lifeRemaining > 1;
  bool get isAbleToContinue => lifeRemaining > 0;
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
