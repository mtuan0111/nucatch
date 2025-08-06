abstract class PlayerNavState {}

enum Difficulty {
  easy,
  medium,
  hard,
  extreme,
}

class PlayerNavInitial extends PlayerNavState {}

class PlayingState extends PlayerNavState {}

class GameOverState extends PlayerNavState {}

class SetDifficultyState extends PlayerNavState {
  // final Difficulty difficulty;

  SetDifficultyState();
}

class DifficultyModel {
  final Difficulty difficulty;
  final int pointEachTurn; // Points awarded for each turn
  final int numberTurnEachLevel;
  final int timeLimitPerTurn; // in seconds
  final int numberOfCharacters;

  const DifficultyModel({
    required this.difficulty,
    this.pointEachTurn = 1,
    this.numberTurnEachLevel = 3,
    required this.timeLimitPerTurn,
    required this.numberOfCharacters,
  });

  static Map<Difficulty, DifficultyModel> models = {
    Difficulty.easy: const DifficultyModel(
      difficulty: Difficulty.easy,
      pointEachTurn: 1,
      timeLimitPerTurn: 30,
      numberOfCharacters: 4,
    ),
    Difficulty.medium: const DifficultyModel(
      difficulty: Difficulty.medium,
      pointEachTurn: 2,
      numberTurnEachLevel: 5,
      timeLimitPerTurn: 20,
      numberOfCharacters: 6,
    ),
    Difficulty.hard: const DifficultyModel(
      difficulty: Difficulty.hard,
      pointEachTurn: 4,
      timeLimitPerTurn: 10,
      numberOfCharacters: 8,
    ),
    Difficulty.extreme: const DifficultyModel(
      difficulty: Difficulty.extreme,
      pointEachTurn: 8,
      timeLimitPerTurn: 5,
      numberOfCharacters: 10,
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
/// print(model.timeLimitPerTurn); // 20
/// print(model.numberOfCharacters); // 6
/// ```