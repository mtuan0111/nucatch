import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/helpers/combat_tutorial_script.dart';
import 'package:nucatch/helpers/const.dart' show KeyboardOption;
import 'package:nucatch/helpers/tutorial_seeds.dart';

enum TutorialArc { regular, pickRight, combat }

/// Which screen hosts `TutorialOverlay` for a given lesson. Combat spans two
/// screens (the live match, then the end-game summary); regular/pick-right
/// share `playScreen`/`gameOverScreen` since both live inside `PlayScreen`.
enum TutorialHostScreen {
  playScreen,
  gameOverScreen,
  combatPlayScreen,
  combatGameEndScreen,
}

enum TutorialSpotlight {
  requirementArea,
  typingArea,
  scorePanel,
  lifePanel,
  timerBar,
  keypad,
  keypadKey,
  resetButton,
  pickRightOptions,
  pickRightOption,
  combatHeader,
  statusBadge,
  opponentPanel,
  opponentLifePanel,
  wholeScreen,
}

enum TutorialInteraction { next, tapKey, tapButton, watch }

class TutorialLessonData {
  /// l10n key suffix — full keys are `tourRule<key>Title`/`tourRule<key>Desc`
  /// (+`Result` when [hasResultBeat] is true).
  final String key;
  final TutorialArc arc;
  final TutorialHostScreen hostScreen;
  final TutorialSpotlight spotlight;
  final KeyboardOption? spotlightKey;
  final int? spotlightButtonIndex;
  final TutorialInteraction interaction;
  final KeyboardOption? requiredKey;
  final int? requiredButtonIndex;

  /// Non-null when this lesson (re-)seeds `TurnBloc` (regular + pick-right).
  final TutorialTurnSeed? turnSeed;

  /// Non-null when this lesson (re-)seeds `CombatBloc`.
  final TutorialCombatSeed? combatSeed;

  /// Non-null when this lesson plays a scripted opponent transcript.
  final List<CombatOpponentAction>? opponentScript;

  final bool hasResultBeat;
  final TutorialSpotlight? resultSpotlight;

  /// Extra haptic/audio emphasis for lessons that teach a real setback
  /// (life loss, game over).
  final bool emphasise;

  const TutorialLessonData({
    required this.key,
    required this.arc,
    required this.hostScreen,
    required this.spotlight,
    this.spotlightKey,
    this.spotlightButtonIndex,
    this.interaction = TutorialInteraction.next,
    this.requiredKey,
    this.requiredButtonIndex,
    this.turnSeed,
    this.combatSeed,
    this.opponentScript,
    this.hasResultBeat = false,
    this.resultSpotlight,
    this.emphasise = false,
  });
}

class TutorialScript {
  static const List<TutorialLessonData> _regularLessons = [
    TutorialLessonData(
      key: 'RegularWelcome',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      // Also introduces the 3 lives (formerly a separate RegularLives card).
      spotlight: TutorialSpotlight.lifePanel,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '6',
        expect: '6',
        level: 1,
      ),
    ),
    TutorialLessonData(
      key: 'RegularMemorize',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.requirementArea,
      interaction: TutorialInteraction.watch,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '8',
        expect: '8',
        level: 1,
        showBeforePlaying: true,
      ),
    ),
    TutorialLessonData(
      key: 'RegularTypeBack',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.keypadKey,
      spotlightKey: KeyboardOption.eight,
      interaction: TutorialInteraction.tapKey,
      requiredKey: KeyboardOption.eight,
      // "Correct — that's a point!" on the score panel (formerly a separate
      // RegularScoring card).
      hasResultBeat: true,
      resultSpotlight: TutorialSpotlight.scorePanel,
    ),
    TutorialLessonData(
      key: 'RegularTimer',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.timerBar,
      interaction: TutorialInteraction.watch,
      hasResultBeat: true,
      resultSpotlight: TutorialSpotlight.lifePanel,
      emphasise: true,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '3',
        expect: '3',
        level: 1,
        tapTimerSeconds: 1.5,
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'RegularReset',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.resetButton,
      interaction: TutorialInteraction.tapKey,
      requiredKey: KeyboardOption.reset,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '5',
        expect: '5',
        level: 1,
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'RegularLevelUp',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.keypadKey,
      spotlightKey: KeyboardOption.two,
      interaction: TutorialInteraction.tapKey,
      requiredKey: KeyboardOption.two,
      hasResultBeat: true,
      resultSpotlight: TutorialSpotlight.scorePanel,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '2',
        expect: '2',
        level: 1,
        timesCorrect: 2, // numberTurnEachLevel(3) - 1
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'RegularGameOver',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.lifePanel,
      interaction: TutorialInteraction.watch,
      emphasise: true,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.easy,
        requirementString: '7',
        expect: '7',
        level: 1,
        lifeRemaining: 1,
        tapTimerSeconds: 1.5,
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'RegularWrapUp',
      arc: TutorialArc.regular,
      hostScreen: TutorialHostScreen.gameOverScreen,
      spotlight: TutorialSpotlight.wholeScreen,
    ),
  ];

  static const List<TutorialLessonData> _pickRightLessons = [
    TutorialLessonData(
      key: 'PickRightWelcome',
      arc: TutorialArc.pickRight,
      hostScreen: TutorialHostScreen.playScreen,
      // Also points out the answer choices (formerly a separate
      // PickRightOptions card).
      spotlight: TutorialSpotlight.pickRightOptions,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.pickRight,
        requirementString: '5 | 8 | 6',
        expect: '1',
        level: 1,
        questionExpression: '5 + 3 = ?',
        equations: ['5', '8', '6'],
        correctIndex: 1,
      ),
    ),
    TutorialLessonData(
      key: 'PickRightCorrect',
      arc: TutorialArc.pickRight,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.pickRightOption,
      spotlightButtonIndex: 1,
      interaction: TutorialInteraction.tapButton,
      requiredButtonIndex: 1,
      hasResultBeat: true,
    ),
    TutorialLessonData(
      key: 'PickRightWrong',
      arc: TutorialArc.pickRight,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.pickRightOption,
      spotlightButtonIndex: 0,
      interaction: TutorialInteraction.tapButton,
      requiredButtonIndex: 0,
      hasResultBeat: true,
      emphasise: true,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.pickRight,
        requirementString: '9 | 4 | 7',
        expect: '2',
        level: 1,
        questionExpression: '3 + 4 = ?',
        equations: ['9', '4', '7'],
        correctIndex: 2,
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'PickRightTimer',
      arc: TutorialArc.pickRight,
      hostScreen: TutorialHostScreen.playScreen,
      spotlight: TutorialSpotlight.timerBar,
      interaction: TutorialInteraction.watch,
      hasResultBeat: true,
      resultSpotlight: TutorialSpotlight.lifePanel,
      emphasise: true,
      turnSeed: TutorialTurnSeed(
        difficulty: Difficulty.pickRight,
        requirementString: '9 | 4 | 7',
        expect: '2',
        level: 1,
        questionExpression: '3 + 4 = ?',
        equations: ['9', '4', '7'],
        correctIndex: 2,
        lifeRemaining: 1,
        tapTimerSeconds: 1.2,
        startTimer: true,
      ),
    ),
    TutorialLessonData(
      key: 'PickRightWrapUp',
      arc: TutorialArc.pickRight,
      hostScreen: TutorialHostScreen.gameOverScreen,
      spotlight: TutorialSpotlight.wholeScreen,
    ),
  ];

  static const List<TutorialLessonData> _combatLessons = [
    TutorialLessonData(
      key: 'CombatWelcome',
      arc: TutorialArc.combat,
      hostScreen: TutorialHostScreen.combatPlayScreen,
      // Also explains the turn badge (formerly a separate CombatTurnOrder
      // card).
      spotlight: TutorialSpotlight.statusBadge,
      combatSeed: TutorialCombatSeed(
        requirementString: '4',
        expect: '4',
        level: 1,
      ),
    ),
    TutorialLessonData(
      key: 'CombatYourTurn',
      arc: TutorialArc.combat,
      hostScreen: TutorialHostScreen.combatPlayScreen,
      spotlight: TutorialSpotlight.keypadKey,
      spotlightKey: KeyboardOption.four,
      interaction: TutorialInteraction.tapKey,
      requiredKey: KeyboardOption.four,
    ),
    TutorialLessonData(
      key: 'CombatOpponentTurn',
      arc: TutorialArc.combat,
      hostScreen: TutorialHostScreen.combatPlayScreen,
      spotlight: TutorialSpotlight.opponentPanel,
      interaction: TutorialInteraction.watch,
      hasResultBeat: true,
      opponentScript: CombatTutorialScript.opponentTypesAndSucceeds,
    ),
    TutorialLessonData(
      key: 'CombatWin',
      arc: TutorialArc.combat,
      hostScreen: TutorialHostScreen.combatPlayScreen,
      spotlight: TutorialSpotlight.opponentLifePanel,
      interaction: TutorialInteraction.watch,
      hasResultBeat: true,
      opponentScript: CombatTutorialScript.opponentLosesTheMatch,
      // Re-pins state (and, critically, stops any timer still running from
      // CombatOpponentTurn's real "opponent succeeded, hand turn back to
      // host" consequence) before this lesson's (final) script plays —
      // otherwise that real turn keeps generating fresh real
      // challenges/timeouts that race the script.
      combatSeed: TutorialCombatSeed(
        requirementString: '4',
        expect: '4',
        level: 1,
        opponentLives: 1,
      ),
    ),
    TutorialLessonData(
      key: 'CombatWrapUp',
      arc: TutorialArc.combat,
      hostScreen: TutorialHostScreen.combatGameEndScreen,
      spotlight: TutorialSpotlight.wholeScreen,
    ),
  ];

  static const List<TutorialLessonData> lessons = [
    ..._regularLessons,
    ..._pickRightLessons,
    ..._combatLessons,
  ];

  static int get length => lessons.length;

  static TutorialLessonData at(int index) {
    if (index < 0) return lessons.first;
    if (index >= lessons.length) return lessons.last;
    return lessons[index];
  }
}
