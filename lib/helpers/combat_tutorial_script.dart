/// Pure, scripted "opponent" transcript for the combat tutorial arc.
///
/// NuCatch has no bot/AI opponent anywhere — combat is inherently two real
/// devices. To teach combat mechanics solo, `CombatTutorialDriver` (see
/// `lib/blocs/objects/combat/combat_tutorial_driver.dart`) plays one of
/// these scripts into a live `CombatBloc` by dispatching the exact same
/// events `CombatBloc`'s real BLE message-handling would dispatch had a
/// message actually arrived from a peer — the transport (BLE) is bypassed,
/// not the game logic. No Flutter/bloc imports here, mirroring
/// `tutorial_scenarios.dart`'s pure-data pattern in the sibling o_an_quan
/// project, so this file is directly unit-testable.
sealed class CombatOpponentAction {
  /// Realistic pacing before this action fires, relative to the previous
  /// one in the script.
  final Duration delay;

  const CombatOpponentAction({required this.delay});
}

/// The opponent is typing their answer; `partialInput` is what they've
/// entered so far.
class OpponentTyping extends CombatOpponentAction {
  final String partialInput;

  const OpponentTyping({required super.delay, required this.partialInput});
}

/// The opponent finished their turn.
class OpponentMoveCompleted extends CombatOpponentAction {
  final String input;
  final bool wasCorrect;
  final int score;
  final int lives;

  const OpponentMoveCompleted({
    required super.delay,
    required this.input,
    required this.wasCorrect,
    required this.score,
    required this.lives,
  });
}

/// The opponent missed a tap (or their timer ran out) and lost a life.
class OpponentLifeLost extends CombatOpponentAction {
  final int lives;
  final int score;

  const OpponentLifeLost({
    required super.delay,
    required this.lives,
    required this.score,
  });
}

/// The match is over.
class OpponentGameEnded extends CombatOpponentAction {
  final bool theyWon;

  const OpponentGameEnded({required super.delay, required this.theyWon});
}

class CombatTutorialScript {
  /// The opponent types their answer digit by digit, then completes it
  /// correctly and hands the turn back.
  static const List<CombatOpponentAction> opponentTypesAndSucceeds = [
    OpponentTyping(delay: Duration(milliseconds: 500), partialInput: '1'),
    OpponentTyping(delay: Duration(milliseconds: 400), partialInput: '12'),
    OpponentMoveCompleted(
      delay: Duration(milliseconds: 400),
      input: '12',
      wasCorrect: true,
      score: 1,
      lives: 3,
    ),
  ];

  /// The opponent misses their tap and loses a life, but the match
  /// continues.
  static const List<CombatOpponentAction> opponentMissesOnce = [
    OpponentTyping(delay: Duration(milliseconds: 500), partialInput: '9'),
    OpponentLifeLost(delay: Duration(milliseconds: 500), lives: 2, score: 1),
    OpponentMoveCompleted(
      delay: Duration(milliseconds: 300),
      input: '9',
      wasCorrect: false,
      score: 1,
      lives: 2,
    ),
  ];

  /// The opponent runs out of lives — the local player wins.
  static const List<CombatOpponentAction> opponentLosesTheMatch = [
    OpponentTyping(delay: Duration(milliseconds: 500), partialInput: '4'),
    OpponentLifeLost(delay: Duration(milliseconds: 500), lives: 0, score: 1),
    OpponentMoveCompleted(
      delay: Duration(milliseconds: 300),
      input: '4',
      wasCorrect: false,
      score: 1,
      lives: 0,
    ),
  ];
}
