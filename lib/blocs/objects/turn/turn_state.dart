import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/models/turn_record_model.dart';

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

  TurnState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 0,
    this.lifeRemaining = 3,
    this.expect,
    this.status = TurnStatus.initial,
    this.typing = "",
    this.countDown = 0,
    this.recordedItem,
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
    TurnRecordedModel? recordedItem,
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
        recordedItem: recordedItem);
  }

  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => expect == typing;
  int get getTimeShowTarget {
    // Unit ratio for each level : 0.2
    return int.parse((1000 + level * diffShowLevelMilisecond).toString());
  }

  bool get isExpectNotEmpty => (expect != null && expect!.isNotEmpty);
  bool get isTypingNotEmpty => (typing.isNotEmpty);

  bool get isShowExpect => status == TurnStatus.initial && isExpectNotEmpty;
  bool get isTimeForTyping => status == TurnStatus.playing && isExpectNotEmpty;
  bool get isCorrectAnimate => isFinishTarget;
  bool get isAbleToTap =>
      (status == TurnStatus.playing) && isExpectNotEmpty && !isFinishTarget;
  bool get isAbleToReset => lifeRemaining > 1;
  bool get isAbleToContinue => lifeRemaining > 0;
}

// class InitialState extends TurnState {}

// class RestState extends TurnState {}

// class PlayingState extends TurnState {}
