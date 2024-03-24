import 'package:nucatch_with_bloc/helpers/const.dart';

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

  TurnState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 1,
    this.lifeRemaining = 3,
    this.expect,
    this.status = TurnStatus.initial,
    this.typing = "",
    this.countDown = 0,
  });

  TurnState copyWith({
    int? level,
    int? timesCorrect,
    int? point,
    int? lifeRemaining,
    // int? currentTypingIndex,
    String? expect,
    String? typing,
    TurnStatus? status,
    int? countDown,
  }) {
    return TurnState(
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
    );
  }

  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => expect == typing;
  int get getTimeShowTarget {
    // Unit ratio for each level : 0.2
    return int.parse((1000 + level * DIFF_SHOW_LEVEL_MILISECOND).toString());
  }

  bool get isShowExpect => status == TurnStatus.initial && expect != null;
  bool get isTimeForTyping => status == TurnStatus.playing && expect != null;
  bool get isCorrectAnimate => isFinishTarget;
  bool get isAbleToTap =>
      (status == TurnStatus.playing) &&
      (expect != null && expect!.isNotEmpty) &&
      !isFinishTarget;
  bool get isAbleToReset => lifeRemaining > 1;
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
