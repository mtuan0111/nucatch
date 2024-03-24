import 'package:nucatch_with_bloc/helpers/const.dart';

enum TurnStatus {
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
  final int _lifeRemaining;

  final String? expect;
  final String typing;
  final TurnStatus status;

  TurnState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 1,
    int lifeRemaining = 3,
    this.expect,
    this.status = TurnStatus.initial,
    this.typing = "",
  }) : _lifeRemaining = lifeRemaining;

  TurnState copyWith({
    int? level,
    int? timesCorrect,
    int? point,
    int? lifeRemaining,
    // int? currentTypingIndex,
    String? expect,
    String? typing,
    TurnStatus? status,
  }) {
    return TurnState(
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      point: point ?? this.point,
      lifeRemaining: lifeRemaining ?? _lifeRemaining,
      // currentTypingIndex: currentTypingIndex ?? this.currentTypingIndex,
      expect: expect ?? this.expect,
      typing: typing ?? this.typing,
      status: status ?? this.status,
    );
  }

  int get lifeRemaining => _lifeRemaining < 0 ? 0 : _lifeRemaining;
  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => expect == typing;
  int get getTimeShowTarget {
    // Unit ratio for each level : 0.2
    return int.parse((1000 + level * DIFF_SHOW_LEVEL_MILISECOND).toString());
  }

  bool get isShowExpect => status == TurnStatus.initial && expect != null;
  bool get isCorrectAnimate => isFinishTarget;
  bool get isAbleToTap =>
      (status != TurnStatus.gameOver) && (expect != null && expect!.isNotEmpty);
  bool get isAbleToReset => lifeRemaining > 1;
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
