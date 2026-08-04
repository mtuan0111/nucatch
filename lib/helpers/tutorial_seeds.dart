import 'package:nucatch/blocs/navs/player/player_nav_state.dart' show Difficulty;

/// Pure seed data for `SeedTutorialTurn` (regular + pick-right arcs). No
/// Flutter/bloc imports — mirrors `tutorial_scenarios.dart`'s "pure,
/// unit-testable data" pattern from the sibling o_an_quan project.
///
/// Every lesson gets a *known* `expect` string rather than a scripted
/// *outcome* — unlike o_an_quan's board scenarios, a wrong tap in NuCatch
/// always collapses to the same well-defined "life lost" consequence
/// regardless of which wrong key was pressed, so nothing here needs to
/// script what happens on a miss, only what the correct answer is.
class TutorialTurnSeed {
  final Difficulty difficulty;
  final String requirementString;
  final String expect;
  final int level;

  /// Set to `numberTurnEachLevel - 1` to make the next real correct tap
  /// trigger a genuine level-up.
  final int timesCorrect;

  /// Set to `1` to make the next real miss a genuine game over.
  final int lifeRemaining;

  /// If non-null, the real `Timer.periodic` starts counting down from this
  /// many seconds instead of the difficulty's normal duration — used to
  /// make a "the timer costs you a life" lesson fire for real in ~1-2s
  /// instead of waiting out the real 20s duration.
  final double? tapTimerSeconds;

  /// `false` keeps the real timer paused (explain-only lessons); `true`
  /// starts it counting down for real.
  final bool startTimer;

  // Pick Right mode only.
  final List<String>? equations;
  final int? correctIndex;
  final String? questionExpression;

  /// True for the "watch the number get memorized" lesson — seeds into the
  /// real `TurnStatus.initial` memorize phase instead of straight into
  /// `playing`, so the display genuinely shows-then-hides on its own before
  /// typing starts.
  final bool showBeforePlaying;

  const TutorialTurnSeed({
    required this.difficulty,
    required this.requirementString,
    required this.expect,
    this.level = 1,
    this.timesCorrect = 0,
    this.lifeRemaining = 3,
    this.tapTimerSeconds,
    this.startTimer = false,
    this.equations,
    this.correctIndex,
    this.questionExpression,
    this.showBeforePlaying = false,
  });
}

/// Pure seed data for `SeedTutorialCombat`.
class TutorialCombatSeed {
  final Difficulty difficulty;
  final String requirementString;
  final String expect;
  final int level;
  final int lifeRemaining;
  final int opponentLives;
  final int opponentScore;
  final double? tapTimerSeconds;
  final bool startTimer;

  const TutorialCombatSeed({
    this.difficulty = Difficulty.easy,
    required this.requirementString,
    required this.expect,
    this.level = 1,
    this.lifeRemaining = 3,
    this.opponentLives = 3,
    this.opponentScore = 0,
    this.tapTimerSeconds,
    this.startTimer = false,
  });
}
