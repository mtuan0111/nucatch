import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/models/setting_model.dart';

abstract class TurnEvent {}

class CountDownIntro extends TurnEvent {
  int seconds;
  CountDownIntro({
    required this.seconds,
  });
}

class Start extends TurnEvent {
  // Marking the status transform from initial status to playing status
  int seconds;

  Start({
    this.seconds = 4,
  });
}

class End extends TurnEvent {
  final bool isCauseGameOver;

  End({
    this.isCauseGameOver = true,
  });
}

class Tap extends TurnEvent {
  final KeyboardOption keyValue;

  Tap({
    required this.keyValue,
  });
}

class SetLevel extends TurnEvent {
  final int level;
  final int addPoint;

  SetLevel({
    required this.level,
    this.addPoint = 1,
  });
}

class SetDifficulty extends TurnEvent {
  final Difficulty difficulty;
  final void Function()? onChanged;

  SetDifficulty({
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

class AddPoint extends TurnEvent {
  AddPoint();
}

class GainLife extends TurnEvent {
  final int lifeGained;

  GainLife({this.lifeGained = 1});
}

class GeneratedRequiredString extends TurnEvent {
  GeneratedRequiredString();
}

class ShowExpect extends TurnEvent {
  final Duration duration;

  ShowExpect(this.duration);
}

class ResetNewNumber extends TurnEvent {
  Duration duration;
  ResetNewNumber({
    required this.duration,
  });
}

class SaveRecorded extends TurnEvent {
  final void Function()? callback;

  SaveRecorded({this.callback});
}

class ApplySetting extends TurnEvent {
  final SettingModel settingModel;

  ApplySetting({
    required this.settingModel,
  });
}

// Legacy event aliases for backward compatibility
// These should be gradually replaced in the codebase
// typedef CountDownIntro = CountDownIntro;
// typedef Start = Start;
// typedef End = End;
// typedef Tap = Tap;
// typedef SetLevel = SetLevel;
// typedef SetDifficulty = SetDifficulty;
// typedef LifeLost = LifeLost;
// typedef AddPoint = AddPoint;
// typedef GainLife = GainLife;
// typedef GeneratedRequiredString = GeneratedRequiredString;
// typedef ShowExpect = ExpectShown;
// typedef ResetNewNumber = ResetNewNumber;
// typedef SaveRecorded = SaveRecorded;
// typedef ApplySetting = ApplySetting;

class TapTimerTick extends TurnEvent {
  final double remainingTime;
  TapTimerTick(this.remainingTime);
}

class TapTimerTimeout extends TurnEvent {}

class TapTimerPause extends TurnEvent {}

class TapTimerResume extends TurnEvent {}

class TapTimerReset extends TurnEvent {}

class Renew extends TurnEvent {}
