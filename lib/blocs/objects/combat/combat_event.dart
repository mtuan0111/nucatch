import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';

abstract class CombatEvent {}

// ===== Core Game Events (matching TurnEvent) =====

class CombatGameStarted extends CombatEvent {
  final int seconds;
  final Difficulty difficulty;
  final bool isHost;
  final CombatStatus? combatStatus;

  CombatGameStarted({
    this.seconds = 4,
    required this.difficulty,
    required this.isHost,
    this.combatStatus,
  });
}

class CombatGameEnded extends CombatEvent {
  final bool isCauseGameOver;
  final bool isWinner;
  final String reason;
  final bool sendMessage;

  CombatGameEnded({
    this.isCauseGameOver = true,
    required this.isWinner,
    required this.reason,
    this.sendMessage = true,
  });
}

class CombatTap extends CombatEvent {
  final KeyboardOption keyValue;

  CombatTap({required this.keyValue});
}

class CombatLevelChanged extends CombatEvent {
  final int level;

  CombatLevelChanged({required this.level});
}

class CombatDifficultyChanged extends CombatEvent {
  final Difficulty difficulty;
  final void Function()? onChanged;

  CombatDifficultyChanged({
    required this.difficulty,
    this.onChanged,
  });
}

class CombatLostLife extends CombatEvent {
  final int lifeRemaining;

  CombatLostLife({this.lifeRemaining = 1});
}

class CombatAddPoint extends CombatEvent {
  CombatAddPoint();
}

class CombatLifeGained extends CombatEvent {
  final int lifeGained;

  CombatLifeGained({this.lifeGained = 1});
}

class CombatRequiredStringGenerated extends CombatEvent {}

class CombatExpectShown extends CombatEvent {
  final Duration duration;

  CombatExpectShown(this.duration);
}

class CombatNumberReset extends CombatEvent {
  final Duration duration;

  CombatNumberReset({required this.duration});
}

class CombatRecordSaved extends CombatEvent {
  final void Function()? callback;

  CombatRecordSaved({this.callback});
}

class CombatTapTimerTick extends CombatEvent {
  final double remainingTime;

  CombatTapTimerTick(this.remainingTime);
}

class CombatTapTimerTimeout extends CombatEvent {}

class CombatTapTimerPause extends CombatEvent {}

class CombatTapTimerResume extends CombatEvent {}

class CombatTapTimerReset extends CombatEvent {}

// ===== Combat-Specific Network Events =====

class CombatTurnStarted extends CombatEvent {
  final bool isMyTurn;

  CombatTurnStarted({required this.isMyTurn});
}

class CombatTurnReceived extends CombatEvent {
  final bool isMyTurn;
  final String requirement;
  final String expect;

  CombatTurnReceived({
    required this.isMyTurn,
    required this.requirement,
    required this.expect,
  });
}

class CombatOpponentMoveReceived extends CombatEvent {
  final String opponentInput;
  final bool wasOpponentCorrect;
  final int opponentScore;
  final int opponentLives;

  CombatOpponentMoveReceived({
    required this.opponentInput,
    required this.wasOpponentCorrect,
    required this.opponentScore,
    required this.opponentLives,
  });
}

class CombatOpponentTypingUpdate extends CombatEvent {
  final String currentInput;

  CombatOpponentTypingUpdate({required this.currentInput});
}

class CombatOpponentDisconnected extends CombatEvent {}

class CombatRestartRequested extends CombatEvent {}

class CombatRestartReady extends CombatEvent {
  final bool isReady;

  CombatRestartReady({required this.isReady});
}

class CombatRestartReadyReceived extends CombatEvent {
  final bool opponentReady;

  CombatRestartReadyReceived({required this.opponentReady});
}

class CombatBlocReset extends CombatEvent {}

// ===== Legacy aliases for backward compatibility =====
typedef TurnStarted = CombatTurnStarted;
typedef TurnReceived = CombatTurnReceived;
typedef OpponentMoveReceived = CombatOpponentMoveReceived;
typedef OpponentDisconnected = CombatOpponentDisconnected;
typedef GameEnded = CombatGameEnded;
typedef DifficultySelected = CombatDifficultyChanged;
typedef InputUpdated = CombatTap; // Map to tap event
typedef CombatReset = CombatGameStarted; // Reset by restarting
