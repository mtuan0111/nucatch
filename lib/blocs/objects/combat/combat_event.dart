import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

abstract class CombatEvent {}

class CombatGameStarted extends CombatEvent {
  final Difficulty difficulty;
  final bool isHost;
  
  CombatGameStarted({required this.difficulty, required this.isHost});
}

class TurnStarted extends CombatEvent {
  final bool isMyTurn;
  
  TurnStarted({required this.isMyTurn});
}

class TurnCompleted extends CombatEvent {
  final bool wasCorrect;
  final String playerInput;
  final int pointsScored;
  final int livesRemaining;
  
  TurnCompleted({
    required this.wasCorrect, 
    required this.playerInput,
    required this.pointsScored,
    required this.livesRemaining,
  });
}

class OpponentMoveReceived extends CombatEvent {
  final String opponentInput;
  final bool wasOpponentCorrect;
  final int opponentScore;
  final int opponentLives;
  
  OpponentMoveReceived({
    required this.opponentInput,
    required this.wasOpponentCorrect,
    required this.opponentScore,
    required this.opponentLives,
  });
}

class GameEnded extends CombatEvent {
  final bool isWinner;
  final String reason; // "opponent_lives_out", "my_lives_out", "opponent_disconnected"
  
  GameEnded({required this.isWinner, required this.reason});
}

class OpponentDisconnected extends CombatEvent {}

class DifficultySelected extends CombatEvent {
  final Difficulty difficulty;
  
  DifficultySelected({required this.difficulty});
}

class InputUpdated extends CombatEvent {
  final String input;
  
  InputUpdated({required this.input});
}