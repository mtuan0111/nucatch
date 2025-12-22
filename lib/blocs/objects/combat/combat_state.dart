import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/models/turn_record_model.dart';

class CombatState extends TurnState {
  // Combat-specific properties
  final bool isHost;
  final bool isMyTurn;
  final bool isGameActive;

  // Opponent state
  final int opponentScore;
  final int opponentLives;

  // Current turn info
  final String myInput;
  final String? opponentInput;
  final bool isWaitingForOpponent;

  // Game status
  final CombatStatus combatStatus;
  final bool? isWinner; // null = ongoing, true = won, false = lost
  final String? gameEndReason;

  const CombatState({
    // Combat-specific parameters
    this.isHost = false,
    this.isMyTurn = false,
    this.isGameActive = false,
    this.opponentScore = 0,
    this.opponentLives = 3,
    this.myInput = '',
    this.opponentInput,
    this.isWaitingForOpponent = false,
    this.combatStatus = CombatStatus.waiting,
    this.isWinner,
    this.gameEndReason,
    // TurnState parameters
    super.level = 0,
    super.timesCorrect = 0,
    super.point = 0,
    super.difficultyModel,
    super.lifeRemaining = 3,
    super.requirementString,
    super.expect,
    super.status = TurnStatus.initial,
    super.typing = "",
    super.countDown = 0,
    super.recordedItem,
    super.isLoading = false,
    super.message,
    super.saveSuccess = false,
    super.tapTimerRemaining = 20.0,
    super.isTimerPaused = false,
  });

  @override
  CombatState copyWith({
    // Combat-specific parameters
    bool? isHost,
    bool? isMyTurn,
    bool? isGameActive,
    int? opponentScore,
    int? opponentLives,
    String? myInput,
    String? opponentInput,
    bool? isWaitingForOpponent,
    CombatStatus? combatStatus,
    bool? isWinner,
    String? gameEndReason,
    // TurnState parameters
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
    return CombatState(
      // Combat-specific
      isHost: isHost ?? this.isHost,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      isGameActive: isGameActive ?? this.isGameActive,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentLives: opponentLives ?? this.opponentLives,
      myInput: myInput ?? this.myInput,
      opponentInput: opponentInput ?? this.opponentInput,
      isWaitingForOpponent: isWaitingForOpponent ?? this.isWaitingForOpponent,
      combatStatus: combatStatus ?? this.combatStatus,
      isWinner: isWinner ?? this.isWinner,
      gameEndReason: gameEndReason ?? this.gameEndReason,
      // TurnState
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      point: point ?? this.point,
      difficultyModel: difficultyModel ?? this.difficultyModel,
      lifeRemaining: lifeRemaining ?? this.lifeRemaining,
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

  // Combat-specific computed properties
  bool get canTap => isMyTurn && isGameActive && expect != null;
  bool get isComplete => myInput == expect;
  bool get hasGameEnded => isWinner != null;
  bool get isOpponentActive => !isMyTurn && isGameActive;

  // Convenience getters for clarity
  int get myScore => point;
  int get myLives => lifeRemaining;
  String? get currentRequirement => requirementString;
  String? get currentTarget => expect;
}

enum CombatStatus {
  waiting, // Waiting for game to start
  hostSelecting, // Host is selecting difficulty
  intro, // Countdown before game starts
  starting, // Game is starting (countdown)
  playing, // Game in progress
  ended, // Game finished
}
