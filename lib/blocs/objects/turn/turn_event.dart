import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/models/setting_model.dart';

abstract class TurnEvent {}

class CountDownIntroStarted extends TurnEvent {
  int seconds;
  CountDownIntroStarted({
    required this.seconds,
  });
}

class GameStarted extends TurnEvent {
  // Marking the status transform from initial status to playing status
  int seconds;

  GameStarted({
    this.seconds = 3,
  });
}

class GameEnded extends TurnEvent {
  final bool isCauseGameOver;

  GameEnded({
    this.isCauseGameOver = true,
  });
}

class PlayerTapped extends TurnEvent {
  final KeyboardOption keyValue;

  PlayerTapped({
    required this.keyValue,
  });
}

class LevelChanged extends TurnEvent {
  final int level;
  final int addPoint;

  LevelChanged({
    required this.level,
    this.addPoint = 1,
  });
}

class DifficultyChanged extends TurnEvent {
  final Difficulty difficulty;
  final void Function()? onChanged;

  DifficultyChanged({
    required this.difficulty,
    this.onChanged,
  });
}

class LifeLost extends TurnEvent {
  final int lifeRemaining;

  LifeLost({
    this.lifeRemaining = 1,
  });
}

class PointAdded extends TurnEvent {
  PointAdded();
}

class LifeGained extends TurnEvent {
  final int lifeGained;

  LifeGained({this.lifeGained = 1});
}

class RequiredStringGenerated extends TurnEvent {
  RequiredStringGenerated();
}

class ExpectShown extends TurnEvent {
  final Duration duration;

  ExpectShown(this.duration);
}

class NumberReset extends TurnEvent {
  Duration duration;
  NumberReset({
    required this.duration,
  });
}

class RecordSaved extends TurnEvent {
  final void Function()? callback;

  RecordSaved({this.callback});
}

class SettingApplied extends TurnEvent {
  final SettingModel settingModel;

  SettingApplied({
    required this.settingModel,
  });
}

// Legacy event aliases for backward compatibility
// These should be gradually replaced in the codebase
typedef CountDownIntro = CountDownIntroStarted;
typedef Start = GameStarted;
typedef End = GameEnded;
typedef Tap = PlayerTapped;
typedef SetLevel = LevelChanged;
typedef SetDifficulty = DifficultyChanged;
typedef LostLife = LifeLost;
typedef AddPoint = PointAdded;
typedef GainLife = LifeGained;
typedef GeneratedRequiredString = RequiredStringGenerated;
typedef ShowExpect = ExpectShown;
typedef ResetNewNumber = NumberReset;
typedef SaveRecorded = RecordSaved;
typedef ApplySetting = SettingApplied;
