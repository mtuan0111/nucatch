abstract class PlayerNavState {}

enum Difficulty {
  easy,
  medium,
  hard,
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
  final int timeLimitPerTurn; // in seconds
  final int numberOfCharacters;

  const DifficultyModel({
    required this.difficulty,
    required this.timeLimitPerTurn,
    required this.numberOfCharacters,
  });

  static const Map<Difficulty, DifficultyModel> models = {
    Difficulty.easy: DifficultyModel(
      difficulty: Difficulty.easy,
      timeLimitPerTurn: 30,
      numberOfCharacters: 4,
    ),
    Difficulty.medium: DifficultyModel(
      difficulty: Difficulty.medium,
      timeLimitPerTurn: 20,
      numberOfCharacters: 6,
    ),
    Difficulty.hard: DifficultyModel(
      difficulty: Difficulty.hard,
      timeLimitPerTurn: 10,
      numberOfCharacters: 8,
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