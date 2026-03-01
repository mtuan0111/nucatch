import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/models/turn_record_model.dart';

enum GameStatus {
  intro,
  initial,
  correct,
  playing,
  rest,
  gameOver,
}

class GameState {
  final int level;
  final int timesCorrect;
  final int point;
  final DifficultyModel? difficultyModel;
  final int lifeRemaining;
  final String? requirementString;
  final String? expect;
  final String typing;
  final GameStatus status;
  final int countDown;
  final TurnRecordedModel? recordedItem;
  final bool isLoading;

  const GameState({
    this.level = 0,
    this.timesCorrect = 0,
    this.point = 0,
    this.difficultyModel,
    this.lifeRemaining = kSoloInitialLives,
    this.requirementString,
    this.expect,
    this.status = GameStatus.initial,
    this.typing = "",
    this.countDown = 0,
    this.recordedItem,
    this.isLoading = false,
  });

  GameState copyWith({
    int? level,
    int? timesCorrect,
    int? point,
    DifficultyModel? difficultyModel,
    int? lifeRemaining,
    String? requirementString,
    String? expect,
    String? typing,
    GameStatus? status,
    int? countDown,
    TurnRecordedModel? recordedItem,
    bool? isLoading,
  }) {
    return GameState(
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
    );
  }

  // Game logic getters
  String get levelAndTimeCorrect => "$level - ${timesCorrect + 1}";

  int get currentTypingIndex => typing.length;

  bool get isFinishTarget => expect == typing;

  bool get isExpectNotEmpty => expect?.isNotEmpty ?? false;

  bool get isTypingNotEmpty => typing.isNotEmpty;

  bool get isShowExpect =>
      status == GameStatus.initial && isExpectNotEmpty && !isTypingNotEmpty;

  bool get isTimeForTyping =>
      (status == GameStatus.playing) && (isExpectNotEmpty || isTypingNotEmpty);

  bool get isCorrectAnimate => isFinishTarget;

  bool get isAbleToTap => isExpectNotEmpty && !isFinishTarget;

  bool get isAbleToReset => status == GameStatus.playing && lifeRemaining > 1;

  bool get isAbleToContinue => lifeRemaining > 0;

  bool get isAbleToLevelUp =>
      timesCorrect >= (difficultyModel?.numberTurnEachLevel ?? 3);
}
