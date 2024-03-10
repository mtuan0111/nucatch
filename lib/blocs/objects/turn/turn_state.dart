import 'package:nucatch_with_bloc/helpers/const.dart';

class TurnState {
  final int level;
  final int point;

  final String? expect;
  final String typing;

  final bool isShowExpect;

  TurnState({
    this.level = 1,
    this.point = 0,
    this.expect,
    this.isShowExpect = false,
    this.typing = "",
  });

  TurnState copyWith({
    int? level,
    int? point,
    // int? currentTypingIndex,
    String? expect,
    String? typing,
    bool? isShowExpect,
  }) {
    return TurnState(
      level: level ?? this.level,
      point: point ?? this.point,
      // currentTypingIndex: currentTypingIndex ?? this.currentTypingIndex,
      expect: expect ?? this.expect,
      typing: typing ?? this.typing,
      isShowExpect: isShowExpect ?? this.isShowExpect,
    );
  }

  int get currentTypingIndex => typing.length;
  bool get isFinishTarget => expect == typing;
  int get getTimeShowTarget {
    // Unit ratio for each level : 0.2
    return int.parse((1000 + level * DIFF_SHOW_LEVEL_MILISECOND).toString());
  }
}

class InitialState extends TurnState {}

class PlayingState extends TurnState {}
