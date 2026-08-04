import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';

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
    this.seconds = kSoloCountDown,
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

  SetLevel({
    required this.level,
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

/// Pick Right mode: button tap event (0=left, 1=right)
class PickRightButtonTap extends TurnEvent {
  final int buttonIndex;

  PickRightButtonTap({required this.buttonIndex});
}

/// Seeds a deterministic, `isTutorial:true` state for the in-game rule
/// tutorial. Bypasses `GeneratedRequiredString`'s `Random()`-based generation
/// entirely — a lesson only needs a *known* `expect` string to point at the
/// correct key, not a scripted outcome (every wrong tap already produces the
/// same well-defined "life lost" consequence regardless of which wrong key
/// was pressed).
class SeedTutorialTurn extends TurnEvent {
  final Difficulty difficulty;
  final String requirementString;
  final String expect;
  final int level;
  final int point;
  final int timesCorrect;
  final int lifeRemaining;
  final double? tapTimerSeconds;
  final bool startTimer;
  final List<String>? equations;
  final int? correctIndex;
  final String? questionExpression;

  /// When true, seeds into the real "memorize" phase (`TurnStatus.initial`,
  /// mirroring `TurnBloc._onShowExpect`) instead of straight into
  /// `TurnStatus.playing` — the number/expression is shown for real, then
  /// the bloc itself flips to `playing` after the same
  /// `getTimeShowTarget`-based delay a normal turn uses. Used by the
  /// "watch the number get memorized" lesson.
  final bool showBeforePlaying;

  SeedTutorialTurn({
    required this.difficulty,
    required this.requirementString,
    required this.expect,
    this.level = 1,
    this.point = 0,
    this.timesCorrect = 0,
    this.lifeRemaining = kSoloInitialLives,
    this.tapTimerSeconds,
    this.startTimer = false,
    this.equations,
    this.correctIndex,
    this.questionExpression,
    this.showBeforePlaying = false,
  });
}
