import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/models/turn_record_model.dart';

class CombatState extends TurnState {
  // Combat-specific properties
  final bool isHost;
  final bool isMyTurn;
  final bool isGameActive;

  // Opponent state
  final int opponentScore;
  final int opponentLives;

  // Current turn info
  final String myInput;
  final String? opponentInput;
  final bool isWaitingForOpponent;

  // Game status
  final CombatStatus combatStatus;
  final bool? isWinner; // null = ongoing, true = won, false = lost
  final GameEndReason? gameEndReason;

  // Restart state
  final bool isRestartRequested;
  final bool isPlayerReady;
  final bool isOpponentReady;
  final bool?
      willStartFirst; // null = unknown, true = I start first, false = opponent starts first
  final bool
      opponentJustSucceeded; // Track when opponent successfully completes for firework animation
  final bool
      opponentJustLostLife; // Track when opponent loses life for red blink animation
  final bool
      pickRightJustCorrect; // Track when pick-right answer is correct for scale+fade animation
  final String?
      correctEquationDisplay; // Synced correct equation text for game over screen
  final bool
      wantsChangeDifficulty; // Host wants to change difficulty when both ready

  const CombatState({
    // Combat-specific parameters
    this.isHost = false,
    this.isMyTurn = false,
    this.isGameActive = false,
    this.opponentScore = 0,
    this.opponentLives = 3,
    this.myInput = '',
    this.opponentInput,
    this.isWaitingForOpponent = false,
    this.combatStatus = CombatStatus.waiting,
    this.isWinner,
    this.gameEndReason,
    this.isRestartRequested = true,
    this.isPlayerReady = false,
    this.isOpponentReady = false,
    this.willStartFirst,
    this.opponentJustSucceeded = false,
    this.opponentJustLostLife = false,
    this.pickRightJustCorrect = false,
    this.correctEquationDisplay,
    this.wantsChangeDifficulty = false,
    // TurnState parameters
    super.level = 0,
    super.timesCorrect = 0,
    super.point = 0,
    super.difficultyModel,
    super.lifeRemaining = 3,
    super.requirementString,
    super.expect,
    super.status = TurnStatus.initial,
    super.typing = "",
    super.countDown = 0,
    super.recordedItem,
    super.isLoading = false,
    super.message,
    super.saveSuccess = false,
    super.tapTimerRemaining = 20.0,
    super.isTimerPaused = false,
    super.trueEquation,
    super.falseEquation,
    super.isLeftCorrect,
    super.selectedOption,
    super.correctIndex,
    super.equations,
  });

  @override
  CombatState copyWith({
    // Combat-specific parameters
    bool? isHost,
    bool? isMyTurn,
    bool? isGameActive,
    int? opponentScore,
    int? opponentLives,
    String? myInput,
    String? opponentInput,
    bool? isWaitingForOpponent,
    CombatStatus? combatStatus,
    bool? isWinner,
    GameEndReason? gameEndReason,
    bool? isRestartRequested,
    bool? isPlayerReady,
    bool? isOpponentReady,
    bool? willStartFirst,
    bool? opponentJustSucceeded,
    bool? opponentJustLostLife,
    bool? pickRightJustCorrect,
    String? correctEquationDisplay,
    bool clearCorrectEquationDisplay = false,
    bool? wantsChangeDifficulty,
    // TurnState parameters
    int? level,
    int? timesCorrect,
    int? point,
    DifficultyModel? difficultyModel,
    int? lifeRemaining,
    String? requirementString,
    String? expect,
    String? typing,
    TurnStatus? status,
    int? countDown,
    TurnRecordedModel? recordedItem,
    bool? isLoading,
    String? message,
    bool? saveSuccess,
    double? tapTimerRemaining,
    bool? isTimerPaused,
    String? trueEquation,
    String? falseEquation,
    bool? isLeftCorrect,
    int? selectedOption,
    int? correctIndex,
    List<String>? equations,
  }) {
    return CombatState(
      // Combat-specific
      isHost: isHost ?? this.isHost,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      isGameActive: isGameActive ?? this.isGameActive,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentLives: opponentLives ?? this.opponentLives,
      myInput: myInput ?? this.myInput,
      opponentInput: opponentInput ?? this.opponentInput,
      isWaitingForOpponent: isWaitingForOpponent ?? this.isWaitingForOpponent,
      combatStatus: combatStatus ?? this.combatStatus,
      isWinner: isWinner ?? this.isWinner,
      gameEndReason: gameEndReason ?? this.gameEndReason,
      isRestartRequested: isRestartRequested ?? this.isRestartRequested,
      isPlayerReady: isPlayerReady ?? this.isPlayerReady,
      isOpponentReady: isOpponentReady ?? this.isOpponentReady,
      willStartFirst: willStartFirst ?? this.willStartFirst,
      opponentJustSucceeded:
          opponentJustSucceeded ?? this.opponentJustSucceeded,
      opponentJustLostLife: opponentJustLostLife ?? this.opponentJustLostLife,
      pickRightJustCorrect: pickRightJustCorrect ?? this.pickRightJustCorrect,
      correctEquationDisplay: clearCorrectEquationDisplay
          ? null
          : (correctEquationDisplay ?? this.correctEquationDisplay),
      wantsChangeDifficulty:
          wantsChangeDifficulty ?? this.wantsChangeDifficulty,
      // TurnState
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      point: point ?? this.point,
      difficultyModel: difficultyModel ?? this.difficultyModel,
      lifeRemaining: lifeRemaining ?? this.lifeRemaining,
      requirementString: requirementString ?? this.requirementString,
      expect: expect ?? this.expect,
      typing: typing ?? this.typing,
      status: status ?? this.status,
      countDown: countDown ?? this.countDown,
      recordedItem: recordedItem ?? this.recordedItem,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      tapTimerRemaining: tapTimerRemaining ?? this.tapTimerRemaining,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      trueEquation: trueEquation ?? this.trueEquation,
      falseEquation: falseEquation ?? this.falseEquation,
      isLeftCorrect: isLeftCorrect ?? this.isLeftCorrect,
      selectedOption: selectedOption ?? this.selectedOption,
      correctIndex: correctIndex ?? this.correctIndex,
      equations: equations ?? this.equations,
    );
  }

  // Combat-specific computed properties

  @override
  bool get isAbleToTap =>
      isMyTurn && isGameActive && isExpectNotEmpty && !isFinishTarget;
  bool get isComplete => myInput == expect;
  bool get hasGameEnded => isWinner != null;
  bool get isOpponentActive => !isMyTurn && isGameActive;

  // Convenience getters for clarity
  int get myScore => point;
  int get myLives => lifeRemaining;
  String? get currentRequirement => requirementString;
  String? get currentTarget => expect;

  // Auto-detect opponent completion when their input length matches expected length
  bool get isOpponentComplete =>
      opponentInput != null &&
      expect != null &&
      opponentInput!.length == expect!.length;
}

enum CombatStatus {
  waiting, // Waiting for game to start
  hostSelecting, // Host is selecting difficulty
  choosingDifficulty, // Host is re-selecting difficulty after game over
  intro, // Countdown before game starts
  playing, // Game in progress
  ended, // Game finished
}

enum GameEndReason {
  opponentLivesOut, // Opponent ran out of lives
  myLivesOut, // I ran out of lives
  opponentDisconnected, // Opponent disconnected
  timeout, // Timeout
}

enum CombatMessageType {
  difficultySelected, // Host selected difficulty
  turnStart, // Turn started
  typingUpdate, // Full typing update (auto-detects completion)
  moveCompleted, // Turn completed
  gameEnded, // Game ended
  restartRequested, // Restart requested
  restartReady, // Player ready for restart
  changeDifficulty, // Host wants to change difficulty after game over
  opponentDisconnected, // Opponent disconnected
}
