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
