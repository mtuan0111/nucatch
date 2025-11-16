import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

abstract class GameEvent {}

class GameEnded extends GameEvent {
  final bool isCauseGameOver;

  GameEnded({this.isCauseGameOver = true});
}

class PlayerTapped extends GameEvent {
  final KeyboardOption keyValue;

  PlayerTapped({required this.keyValue});
}

class LevelSet extends GameEvent {
  final int level;
  final int addPoint;

  LevelSet({
    required this.level,
    this.addPoint = 1,
  });
}

class DifficultySet extends GameEvent {
  final Difficulty difficulty;
  final void Function()? onChanged;

  DifficultySet({
    required this.difficulty,
    this.onChanged,
  });
}

class LifeLost extends GameEvent {
  final int lifeRemaining;

  LifeLost({this.lifeRemaining = 1});
}

class PointAdded extends GameEvent {}

class LifeGained extends GameEvent {}

class RequiredStringGenerated extends GameEvent {}

class ExpectShown extends GameEvent {}

class NumberReset extends GameEvent {
  final Duration duration;

  NumberReset({required this.duration});
}

class CountdownIntroStarted extends GameEvent {
  final int seconds;

  CountdownIntroStarted({required this.seconds});
}
