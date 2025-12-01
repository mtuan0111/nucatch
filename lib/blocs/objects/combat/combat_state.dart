import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

class CombatState {
  final bool isHost;
  final bool isMyTurn;
  final bool isGameActive;
  final DifficultyModel? difficultyModel;
  
  // Player states
  final int myScore;
  final int myLives;
  final int opponentScore;
  final int opponentLives;
  
  // Current turn info
  final String? currentRequirement; // What both players see (e.g., "25 + 17")
  final String? currentTarget;      // What both players need to type (e.g., "42")
  final String myInput;
  final String? opponentInput;
  final bool isWaitingForOpponent;
  
  // Game status
  final CombatStatus status;
  final bool? isWinner; // null = ongoing, true = won, false = lost
  final String? gameEndReason;
  
  const CombatState({
    this.isHost = false,
    this.isMyTurn = false,
    this.isGameActive = false,
    this.difficultyModel,
    this.myScore = 0,
    this.myLives = 3,
    this.opponentScore = 0,
    this.opponentLives = 3,
    this.currentRequirement,
    this.currentTarget,
    this.myInput = '',
    this.opponentInput,
    this.isWaitingForOpponent = false,
    this.status = CombatStatus.waiting,
    this.isWinner,
    this.gameEndReason,
  });
  
  CombatState copyWith({
    bool? isHost,
    bool? isMyTurn,
    bool? isGameActive,
    DifficultyModel? difficultyModel,
    int? myScore,
    int? myLives,
    int? opponentScore,
    int? opponentLives,
    String? currentRequirement,
    String? currentTarget,
    String? myInput,
    String? opponentInput,
    bool? isWaitingForOpponent,
    CombatStatus? status,
    bool? isWinner,
    String? gameEndReason,
  }) {
    return CombatState(
      isHost: isHost ?? this.isHost,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      isGameActive: isGameActive ?? this.isGameActive,
      difficultyModel: difficultyModel ?? this.difficultyModel,
      myScore: myScore ?? this.myScore,
      myLives: myLives ?? this.myLives,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentLives: opponentLives ?? this.opponentLives,
      currentRequirement: currentRequirement ?? this.currentRequirement,
      currentTarget: currentTarget ?? this.currentTarget,
      myInput: myInput ?? this.myInput,
      opponentInput: opponentInput ?? this.opponentInput,
      isWaitingForOpponent: isWaitingForOpponent ?? this.isWaitingForOpponent,
      status: status ?? this.status,
      isWinner: isWinner ?? this.isWinner,
      gameEndReason: gameEndReason ?? this.gameEndReason,
    );
  }
  
  // Computed properties
  bool get canTap => isMyTurn && isGameActive && currentTarget != null;
  bool get isComplete => myInput == currentTarget;
  bool get hasGameEnded => isWinner != null;
  bool get isOpponentActive => !isMyTurn && isGameActive;
}

enum CombatStatus {
  waiting,        // Waiting for game to start
  hostSelecting,  // Host is selecting difficulty  
  starting,       // Game is starting (countdown)
  playing,        // Game in progress
  ended,          // Game finished
}