abstract class PlayerNavState {}

enum PlayMode {
  solo,
  combat,
}

// Belong to Solo
enum Difficulty {
  easy,
  medium,
  hard,
  extreme,
  pickRight,
}

class PlayerNavInitial extends PlayerNavState {}

class SelectPlayModeState extends PlayerNavState {}

class CombatModeSetupState extends PlayerNavState {}

class PairingRoomState extends PlayerNavState {
  final bool isHost;
  final String? roomCode;

  PairingRoomState({required this.isHost, this.roomCode});
}

class PlayingState extends PlayerNavState {
  final PlayMode playMode;

  PlayingState({this.playMode = PlayMode.solo});
}

class GameOverState extends PlayerNavState {}

class SetDifficultyState extends PlayerNavState {
  final PlayMode playMode;
  final Difficulty? difficulty;
  final bool isInstantStart;

  SetDifficultyState({
    this.playMode = PlayMode.solo,
    this.difficulty,
    this.isInstantStart = false,
  });
}

class DifficultyModel {
  final Difficulty difficulty;
  final int pointEachTurn; // Points awarded for each turn
  final int numberTurnEachLevel;
  final int timeLimitPerTurn; // in seconds
  final int numberOfCharacters;
  final bool isPickRightMode; // True for Pick Right mode

  const DifficultyModel({
    required this.difficulty,
    this.pointEachTurn = 1,
    this.numberTurnEachLevel = 3,
    required this.timeLimitPerTurn,
    required this.numberOfCharacters,
    this.isPickRightMode = false,
  });

  static Map<Difficulty, DifficultyModel> models = {
    Difficulty.easy: const DifficultyModel(
      difficulty: Difficulty.easy,
      pointEachTurn: 1,
      timeLimitPerTurn: 20,
      numberOfCharacters: 4,
    ),
    Difficulty.medium: const DifficultyModel(
      difficulty: Difficulty.medium,
      pointEachTurn: 2,
      timeLimitPerTurn: 20,
      numberOfCharacters: 6,
    ),
    Difficulty.hard: const DifficultyModel(
      difficulty: Difficulty.hard,
      pointEachTurn: 4,
      timeLimitPerTurn: 20,
      numberOfCharacters: 8,
    ),
    Difficulty.extreme: const DifficultyModel(
      difficulty: Difficulty.extreme,
      pointEachTurn: 8,
      timeLimitPerTurn: 20,
      numberOfCharacters: 10,
    ),
    Difficulty.pickRight: const DifficultyModel(
      difficulty: Difficulty.pickRight,
      pointEachTurn: 2,
      timeLimitPerTurn: 5,
      numberOfCharacters: 6, // Used for equation complexity
      isPickRightMode: true,
    ),
  };

  static DifficultyModel getModel(Difficulty difficulty) {
    return models[difficulty]!;
  }
}

/// Example usage:
/// 
/// ```dart
/// final model = DifficultyModel.getModel(Difficulty.medium);
/// debugPrint(model.timeLimitPerTurn); // 20
/// debugPrint(model.numberOfCharacters); // 6
/// ```