import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/services/combat_ble_service.dart';

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  final CombatBleService _roomService;
  final AudioBloc _audioBloc;
  final VibrationBloc _vibrationBloc;
  StreamSubscription? _messageSubscription;
  Timer? _tapTimer;

  // Debounce timer for typing_update messages to prevent BLE flooding
  Timer? _typingUpdateDebounceTimer;
  String? _pendingTypingUpdate;
  static const Duration _typingUpdateDebounce = Duration(milliseconds: 100);

  // Expose isHost status from room service
  bool get isHost => _roomService.isHost;

  // Expose room service for UI screens
  CombatBleService get roomService => _roomService;

  CombatBloc({
    required CombatBleService roomService,
    required AudioBloc audioBloc,
    required VibrationBloc vibrationBloc,
  })  : _roomService = roomService,
        _audioBloc = audioBloc,
        _vibrationBloc = vibrationBloc,
        super(const CombatState()) {
    on<CombatTap>(_onCombatTap);
    on<CombatAddPoint>(_onCombatAddPoint);
    on<CombatLostLife>(_onCombatLostLife);
    on<CombatGameStarted>(_onCombatGameStarted);
    on<CombatTurnStarted>(_onCombatTurnStarted);
    on<CombatTurnReceived>(_onCombatTurnReceived);
    on<CombatOpponentMoveReceived>(_onCombatOpponentMoveReceived);
    on<CombatOpponentTypingUpdate>(_onCombatOpponentTypingUpdate);
    on<CombatGameEnded>(_onCombatGameEnded);
    on<CombatOpponentDisconnected>(_onCombatOpponentDisconnected);
    on<CombatRestartRequested>(_onCombatRestartRequested);
    on<CombatRestartReady>(_onCombatRestartReady);
    on<CombatRestartReadyReceived>(_onCombatRestartReadyReceived);
    on<CombatDifficultyChanged>(_onCombatDifficultySelected);
    on<CombatLevelChanged>(_onCombatLevelChanged);
    on<CombatRequiredStringGenerated>(_onCombatGeneratedRequiredString);
    on<CombatExpectShown>(_onCombatShowExpect);
    on<CombatNumberReset>(_onCombatResetNewNumber);
    on<CombatTapTimerTick>(_onCombatTapTimerTick);
    on<CombatTapTimerTimeout>(_onCombatTapTimerTimeout);
    on<CombatOpponentSuccessReceived>(_onCombatOpponentSuccessReceived);
    on<CombatOpponentLifeUpdate>(_onCombatOpponentLifeUpdate);
    on<CombatBlocReset>(_onCombatBlocReset);
    on<CombatPickRightButtonTap>(_onCombatPickRightButtonTap);
    on<CombatChangeDifficultyReceived>(_onCombatChangeDifficultyReceived);

    // Listen to BLE messages
    _messageSubscription = _roomService.incomingDataStream.listen((data) {
      _handleRoomMessage(data);
    });
  }

  @override
  Future<void> close() async {
    _messageSubscription?.cancel();
    _tapTimer?.cancel();
    _typingUpdateDebounceTimer?.cancel();
    // Clean up BLE connections and stream subscriptions
    await _roomService.reset();
    _roomService.dispose();
    return super.close();
  }

  void _handleRoomMessage(Map<String, dynamic> data) {
    debugPrint('🎮 [Combat] Received message: $data');

    try {
      // Ignore messages sent by myself
      final senderId = data['senderId'] as String?;
      if (senderId == _roomService.playerId) {
        return;
      }

      if (data['type'] != null) {
        final String typeString = data['type'];
        final CombatMessageType? messageType = _stringToMessageType(typeString);

        if (messageType == null) {
          // Handle special cases like move_typed_* events and life_update
          if (typeString.startsWith('move_typed_')) {
            debugPrint(
                '📥 [Combat] Received move_typed event: $typeString, isMyTurn: ${state.isMyTurn}');
            final currentInput = data['currentInput'] as String?;
            debugPrint('📥 [Combat] currentInput from message: $currentInput');
            if (currentInput != null && !state.isMyTurn) {
              debugPrint(
                  '✅ [Combat] Updating opponent input to: $currentInput');
              add(CombatOpponentTypingUpdate(currentInput: currentInput));
            } else if (state.isMyTurn) {
              debugPrint('⏭️ [Combat] Skipping - it\'s my turn');
            }
          } else if (typeString == 'life_update') {
            // Handle life update from opponent
            debugPrint('💔 [Combat] Received life_update from opponent');
            final opponentLives = data['lives'] as int?;
            final opponentScore = data['score'] as int?;
            final wrongTap = data['wrongTap'] as bool? ?? false;
            if (opponentLives != null) {
              debugPrint(
                  '💔 [Combat] Updating opponent lives to: $opponentLives, score: $opponentScore, wrongTap: $wrongTap');
              // Use existing event to update opponent stats
              add(CombatOpponentLifeUpdate(
                opponentLives: opponentLives,
                opponentScore: opponentScore ?? 0,
                wrongTap: wrongTap,
              ));
            }
          }
          return;
        }

        switch (messageType) {
          case CombatMessageType.difficultySelected:
            if (!state.isHost) {
              final difficulty = Difficulty.values.firstWhere(
                (d) => d.toString() == data['difficulty'],
              );
              // Initialize combat game for guest first
              add(CombatGameStarted(
                difficulty: difficulty,
                isHost: false,
                combatStatus: CombatStatus.intro,
              ));
              // Then handle difficulty selection
              // add(CombatDifficultyChanged(difficulty: difficulty));
            }
            break;
          case CombatMessageType.turnStart:
            // Use _roomService.isHost instead of state.isHost to avoid race condition
            // where state might not be updated yet when message arrives
            final isMyTurn = data['isHostTurn'] == _roomService.isHost;
            final requirement = data['requirement'] as String;
            final expect = data['expect'] as String;
            final equations = data['equations'] as List?;
            final correctIndex = data['correctIndex'] as int?;
            debugPrint(
                '🎮 [Combat] turn_start received - isHostTurn: ${data['isHostTurn']}, _roomService.isHost: ${_roomService.isHost}, calculated isMyTurn: $isMyTurn');
            add(CombatTurnReceived(
              isMyTurn: isMyTurn,
              requirement: requirement,
              expect: expect,
              equations: equations?.cast<String>(),
              correctIndex: correctIndex,
            ));
            break;
          case CombatMessageType.typingUpdate:
            // Real-time typing progress from opponent
            if (!state.isMyTurn) {
              add(CombatOpponentTypingUpdate(
                currentInput: data['currentInput'],
              ));

              // Auto-detect opponent completion based on input length
              // Check if opponent just completed their move
              final newOpponentInput = data['currentInput'] as String?;
              if (newOpponentInput != null &&
                  state.expect != null &&
                  newOpponentInput.length == state.expect!.length) {
                // Automatically trigger success animation
                add(CombatOpponentSuccessReceived());
              }
            }
            break;
          case CombatMessageType.moveCompleted:
            final wasCorrect = data['wasCorrect'] as bool;
            add(CombatOpponentMoveReceived(
              opponentInput: data['input'],
              wasOpponentCorrect: wasCorrect,
              opponentScore: data['score'],
              opponentLives: data['lives'],
            ));

            // Trigger firework animation when opponent picks correct button
            // TODO: if type is Pick Right mode
            if (state.difficultyModel?.difficulty == Difficulty.pickRight &&
                wasCorrect) {
              add(CombatOpponentSuccessReceived());
            }

            break;
          case CombatMessageType.gameEnded:
            // Don't send message back - this prevents infinite loop
            // Swap the reason: opponent's "my_lives_out" becomes "opponent_lives_out" for me
            String receivedReasonString = data['reason'];
            GameEndReason? myReason = _stringToGameEndReason(
                receivedReasonString,
                swapPerspective: true);

            // For pick-right mode, sync the correct equation from opponent
            // so both players see the same answer on game over screen
            final opponentCorrectEquation = data['correctEquation'] as String?;
            if (opponentCorrectEquation != null) {
              debugPrint(
                  '🏁 [Combat] Received opponent correctEquation: $opponentCorrectEquation');
            }

            add(CombatGameEnded(
              isWinner: !data['isWinner'], // Opponent sends their win status
              reason: myReason,
              sendMessage: false, // Don't echo the message back
              correctEquation: opponentCorrectEquation,
            ));
            break;
          case CombatMessageType.restartRequested:
            // add(CombatRestartRequested());
            break;
          case CombatMessageType.restartReady:
            add(CombatRestartReadyReceived(
              opponentReady: data['isReady'] as bool,
              changeDifficulty: data['changeDifficulty'] as bool? ?? false,
            ));
            break;
          case CombatMessageType.changeDifficulty:
            // Host wants to change difficulty - guest navigates to waiting screen
            add(CombatChangeDifficultyReceived());
            break;
          case CombatMessageType.opponentDisconnected:
            add(CombatOpponentDisconnected());
            break;
        }
      }
    } catch (e) {
      debugPrint('❌ [Combat] Failed to parse message: $e');
    }
  }

  Future<void> _sendMessage(Map<String, dynamic> data) async {
    try {
      debugPrint('📤 [Combat] Attempting to send message: ${data['type']}');
      await _roomService.sendData(data);
      debugPrint(
          '✅ [Combat] Successfully sent message: ${data['type']}, data: $data');
    } catch (e) {
      debugPrint('❌ [Combat] Failed to send message: $e');
    }
  }

  Future<void> _onCombatGameStarted(
    CombatGameStarted event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🎮 [Combat] CombatGameStarted - event.isHost: ${event.isHost}, current state.isHost: ${state.isHost}');

    final combatStatus = event.combatStatus ??
        (event.isHost ? CombatStatus.hostSelecting : CombatStatus.waiting);

    emit(CombatState(
      isHost: event.isHost,
      difficultyModel: DifficultyModel.models[event.difficulty],
      combatStatus: combatStatus,
      isGameActive: true,
      level: 1, // Start from level 1 like solo mode
      lifeRemaining: kCombatInitialLives,
      opponentLives: kCombatInitialLives,
      point: 0,
      opponentScore: 0,
      countDown: kCombatCountDown,
      willStartFirst: combatStatus == CombatStatus.intro
          ? false // Guest (this player) does not start first in initial game
          : null, // Unknown for other statuses
    ));

    debugPrint(
        '🎮 [Combat] After CombatGameStarted - state.isHost: ${state.isHost}');

    // Turn will be started after difficulty is selected
    // This ensures both players are ready before the first turn
  }

  Future<void> _onCombatDifficultySelected(
    CombatDifficultyChanged event,
    Emitter<CombatState> emit,
  ) async {
    final difficultyModel = DifficultyModel.models[event.difficulty]!;

    // Reset game state for new match (handles both initial and re-selection)
    emit(state.copyWith(
      difficultyModel: difficultyModel,
      combatStatus: CombatStatus.intro,
      countDown: kCombatCountDown,
      willStartFirst: state.isHost,
      // Reset game stats for re-selection after game over
      level: 1,
      timesCorrect: 0,
      point: 0,
      lifeRemaining: kCombatInitialLives,
      opponentScore: 0,
      opponentLives: kCombatInitialLives,
      isGameActive: false,
      isMyTurn: false,
      isWaitingForOpponent: false,
      typing: '',
      opponentInput: null,
      requirementString: null,
      expect: null,
      clearCorrectEquationDisplay: true,
    ));

    // Only HOST sends the difficulty selection message
    if (state.isHost) {
      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.difficultySelected),
        'difficulty': event.difficulty.toString(),
      });
    }

    // Wait for countdown to finish (4 seconds)
    for (int i = state.countDown; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (isClosed) return;
    }

    // After countdown, host starts their turn first
    if (state.isHost) {
      add(CombatTurnStarted(isMyTurn: true));
    }
    // Guest waits for turn_start message from host
  }

  Future<void> _onCombatTurnStarted(
    CombatTurnStarted event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🎮 [Combat] TurnStarted - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Generate new challenge based on difficulty and level using event handler
    await _onCombatGeneratedRequiredString(
        CombatRequiredStringGenerated(), emit);

    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;

    // For non-pick-right modes, add slight delay for UI transition
    // Pick right skips this to avoid disabled-button gap during turn swap
    if (!isPickRight) {
      await Future.delayed(
          const Duration(milliseconds: kAnimationDurationSlow));
    }
    final requirement = state.requirementString ?? "";
    final expect = state.expect ?? "";

    // First, set to initial status to show the requirement
    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      isWinner: null,
      requirementString: requirement,
      expect: expect,
      typing: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      combatStatus: CombatStatus.playing,
      status: TurnStatus.initial, // Show requirement first
      countDown: 0, // Reset countdown when turn starts
      isGameActive: true, // Mark game as active when turn starts
      pickRightJustCorrect: false, // Reset animation flag - new equations ready
    ));
    debugPrint(
        '🎬 [Combat] pickRightJustCorrect → FALSE (turn started, equations: ${state.equations})');

    // Send turn start message to opponent
    final isHostTurn = state.isHost ? event.isMyTurn : !event.isMyTurn;
    debugPrint('🎮 [Combat] Sending turn_start - isHostTurn: $isHostTurn');

    await _sendMessage({
      'type': _messageTypeToString(CombatMessageType.turnStart),
      'isHostTurn': isHostTurn,
      'requirement': requirement,
      'expect': expect,
      'equations': state.equations, // For Pick Right mode
      'correctIndex': state.correctIndex, // For Pick Right mode
    });

    // Calculate show time based on level (similar to solo mode)
    // Skip for Pick Right mode - equations ARE the buttons, no memorization needed
    if (!isPickRight) {
      final level = state.level;
      const diffShowLevelMilisecond = 100; // Increase by 100ms per level
      final showTime = 1000 + level * diffShowLevelMilisecond;

      // Wait for the show time, then transition to typing mode
      await Future.delayed(Duration(milliseconds: showTime));

      if (isClosed) return;
    }

    emit(state.copyWith(
      status: TurnStatus.playing, // Now allow typing/tapping
    ));

    // Start tap timer when typing begins
    _startTapTimer();
  }

  Future<void> _onCombatTurnReceived(
    CombatTurnReceived event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🎮 [Combat] TurnReceived - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Receive challenge from opponent - NO new message sent
    // First, set to initial status to show the requirement
    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      requirementString: event.requirement,
      expect: event.expect,
      equations: event.equations, // For Pick Right mode
      correctIndex: event.correctIndex, // For Pick Right mode
      typing: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      combatStatus: CombatStatus.playing,
      status: TurnStatus.initial, // Show requirement first
      isGameActive: true, // Mark game as active when turn received
      pickRightJustCorrect: false, // Reset animation flag - new equations ready
      selectedOption: null, // Clear selection highlight
    ));

    // Calculate show time based on level (similar to solo mode)
    // Skip for Pick Right mode - equations ARE the buttons, no memorization needed
    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;

    if (!isPickRight) {
      final level = state.level;
      const diffShowLevelMilisecond = 100; // Increase by 100ms per level
      final showTime = 1000 + level * diffShowLevelMilisecond;

      // Wait for the show time, then transition to typing mode
      await Future.delayed(Duration(milliseconds: showTime));

      if (isClosed) return;
    }

    emit(state.copyWith(
      status: TurnStatus.playing, // Now allow typing/tapping
    ));

    // Start tap timer when typing begins
    _startTapTimer();
  }

  Future<void> _onCombatOpponentMoveReceived(
    CombatOpponentMoveReceived event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      opponentScore: event.opponentScore,
      opponentLives: event.opponentLives,
      opponentInput: event.opponentInput,
      isWaitingForOpponent: false,
    ));

    // Check if opponent lost
    if (event.opponentLives <= 0) {
      // Don't sendMessage - the opponent will send game_ended with the correct equation
      add(CombatGameEnded(
          isWinner: true,
          reason: GameEndReason.opponentLivesOut,
          sendMessage: false));
      return;
    }

    // Start my turn
    add(CombatTurnStarted(isMyTurn: true));
  }

  Future<void> _onCombatOpponentTypingUpdate(
    CombatOpponentTypingUpdate event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🔄 [Combat] OpponentTypingUpdate event - updating opponentInput to: ${event.currentInput}');
    emit(state.copyWith(
      opponentInput: event.currentInput,
    ));
    debugPrint(
        '✅ [Combat] State updated - opponentInput is now: ${state.opponentInput}');
    debugPrint(
        '🔍 [Combat] UI State: isMyTurn=${state.isMyTurn}, isGameActive=${state.isGameActive}, isOpponentActive=${state.isOpponentActive}');
  }

  Future<void> _onCombatGameEnded(
    CombatGameEnded event,
    Emitter<CombatState> emit,
  ) async {
    // Determine correct equation to display:
    // 1. If BLE provides correctEquation (from opponent), ALWAYS use it (override)
    // 2. If this is a local game end (sendMessage: true), use our own equations
    // 3. If we detected opponent's game end from move_completed (sendMessage: false,
    //    no correctEquation), leave null - the game_ended BLE message will fill it
    String? finalCorrectEquation;
    if (event.correctEquation != null) {
      // Path 1: BLE-synced - always trust this
      finalCorrectEquation = event.correctEquation;
    } else if (event.sendMessage) {
      // Path 2: Local game end - use own equations
      if (state.difficultyModel?.difficulty == Difficulty.pickRight &&
          state.correctIndex != null &&
          state.equations != null &&
          state.correctIndex! < state.equations!.length) {
        finalCorrectEquation = state.equations![state.correctIndex!];
      }
    }
    // Path 3: sendMessage=false, no correctEquation → leave null, wait for BLE

    debugPrint(
        '🏁 [Combat] Game ended - isWinner: ${event.isWinner}, reason: ${event.reason}, sendMessage: ${event.sendMessage}, correctEquation: $finalCorrectEquation, existing: ${state.correctEquationDisplay}');

    emit(state.copyWith(
      combatStatus: CombatStatus.ended,
      isWinner: event.isWinner,
      gameEndReason: event.reason,
      isGameActive: false,
      // BLE-provided value always overrides; otherwise keep existing or use new
      correctEquationDisplay: event.correctEquation ??
          (state.correctEquationDisplay ?? finalCorrectEquation),
    ));

    // Only send game ended message if this is a local game end (not from opponent)
    if (event.sendMessage) {
      // Convert enum to string for message transmission
      String reasonString = _gameEndReasonToString(event.reason);
      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.gameEnded),
        'isWinner': event.isWinner,
        'reason': reasonString,
        // Include correct equation for pick-right mode sync
        if (finalCorrectEquation != null)
          'correctEquation': finalCorrectEquation,
      });
    }
  }

  Future<void> _onCombatOpponentDisconnected(
    CombatOpponentDisconnected event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      combatStatus: CombatStatus.ended,
      isWinner: true,
      gameEndReason: GameEndReason.opponentDisconnected,
      isGameActive: false,
    ));
  }

  Future<void> _onCombatRestartRequested(
    CombatRestartRequested event,
    Emitter<CombatState> emit,
  ) async {
    if (event.changeDifficulty) {
      // Host wants to change difficulty - notify guest and navigate to difficulty screen
      emit(state.copyWith(
        combatStatus: CombatStatus.choosingDifficulty,
        isRestartRequested: false,
        isPlayerReady: false,
        isOpponentReady: false,
        clearCorrectEquationDisplay: true,
      ));

      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.changeDifficulty),
      });
      return;
    }

    // Normal restart - same difficulty
    emit(state.copyWith(
      isRestartRequested: true,
      isPlayerReady: false,
      isOpponentReady: false,
    ));

    // Notify opponent
    await _sendMessage({
      'type': _messageTypeToString(CombatMessageType.restartRequested),
    });
  }

  Future<void> _onCombatChangeDifficultyReceived(
    CombatChangeDifficultyReceived event,
    Emitter<CombatState> emit,
  ) async {
    // Guest received change difficulty from host - navigate to waiting screen
    emit(state.copyWith(
      combatStatus: CombatStatus.choosingDifficulty,
      isRestartRequested: false,
      isPlayerReady: false,
      isOpponentReady: false,
      clearCorrectEquationDisplay: true,
    ));
  }

  Future<void> _onCombatRestartReady(
    CombatRestartReady event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🔄 [Combat] Player ready: ${event.isReady}, changeDifficulty: ${event.changeDifficulty}');

    // If host is requesting difficulty change, store that intent
    final wantsChange = event.changeDifficulty
        ? true
        : (event.isReady ? state.wantsChangeDifficulty : false);

    emit(state.copyWith(
      isPlayerReady: event.isReady,
      wantsChangeDifficulty: wantsChange,
    ));

    // Send ready status to opponent (include changeDifficulty flag)
    await _sendMessage({
      'type': _messageTypeToString(CombatMessageType.restartReady),
      'isReady': event.isReady,
      'changeDifficulty': wantsChange,
    });

    // Check if both players are ready
    if (event.isReady && state.isOpponentReady) {
      if (state.wantsChangeDifficulty) {
        // Navigate to difficulty selection instead of restarting
        emit(state.copyWith(
          combatStatus: CombatStatus.choosingDifficulty,
          isRestartRequested: false,
          isPlayerReady: false,
          isOpponentReady: false,
          wantsChangeDifficulty: false,
          clearCorrectEquationDisplay: true,
        ));
      } else {
        await _restartGame(emit);
      }
    }
  }

  Future<void> _onCombatRestartReadyReceived(
    CombatRestartReadyReceived event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '🔄 [Combat] Opponent ready: ${event.opponentReady}, changeDifficulty: ${event.changeDifficulty}');

    // Store opponent's changeDifficulty intent
    final wantsChange = event.changeDifficulty || state.wantsChangeDifficulty;

    emit(state.copyWith(
      isOpponentReady: event.opponentReady,
      wantsChangeDifficulty: wantsChange,
    ));

    // Check if both players are ready
    if (state.isPlayerReady && event.opponentReady) {
      if (wantsChange) {
        // Navigate to difficulty selection instead of restarting
        emit(state.copyWith(
          combatStatus: CombatStatus.choosingDifficulty,
          isRestartRequested: false,
          isPlayerReady: false,
          isOpponentReady: false,
          wantsChangeDifficulty: false,
          clearCorrectEquationDisplay: true,
        ));
      } else {
        await _restartGame(emit);
      }
    }
  }

  Future<void> _restartGame(Emitter<CombatState> emit) async {
    debugPrint(
        '🔄 [Combat] Both players ready - restarting game with countdown');

    // Save current difficulty to preserve it
    final currentDifficulty = state.difficultyModel;

    // Save who lost - they will start first in the next match
    final iLost = state.isWinner == false;
    debugPrint(
        '🔄 [Combat] I lost previous match: $iLost, isHost: ${state.isHost}');

    // First, reset the state with intro status and countdown
    emit(state.copyWith(
      combatStatus: CombatStatus.intro,
      countDown:
          kCombatCountDown, // Start countdown at 6 (will show 5-4-3-2-1-GO)
      isWinner: null,
      gameEndReason: null,
      isRestartRequested: true,
      isPlayerReady: false,
      isOpponentReady: false,
      isGameActive: false,
      level: 1, // Always start from level 1
      timesCorrect: 0,
      point: 0,
      lifeRemaining: kCombatInitialLives,
      opponentScore: 0,
      opponentLives: kCombatInitialLives,
      requirementString: null,
      expect: null,
      typing: '',
      opponentInput: null,
      isMyTurn: false,
      isWaitingForOpponent: false,
      difficultyModel: currentDifficulty, // Keep the same difficulty
      willStartFirst: iLost, // Set to true if I lost (I will start first)
      clearCorrectEquationDisplay: true, // Clear for new match
      // Clear pick right state from previous round
      equations: [],
      correctIndex: null,
      selectedOption: null,
      pickRightJustCorrect: false,
    ));

    // Wait for countdown to finish (4 seconds)
    for (int i = state.countDown; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (isClosed) return;
    }

    // After countdown, the loser starts first
    // If I'm the host
    if (state.isHost) {
      if (iLost) {
        // I lost, so I (host) start first
        debugPrint('🎮 [Host] I lost previous match - starting my turn first');
        add(CombatTurnStarted(isMyTurn: true));
      } else {
        // I won, so guest (opponent) starts first
        debugPrint('🎮 [Host] I won previous match - guest starts first');
        add(CombatTurnStarted(isMyTurn: false));
      }
    }
    // If I'm the guest, wait for turn_start message from host
    // (Host will send the appropriate turn order based on who lost)
    // Guest waits for turn_start message from host
  }

  Future<void> _onCombatTap(
    CombatTap event,
    Emitter<CombatState> emit,
  ) async {
    if (!state.isMyTurn || !state.isAbleToTap) {
      return;
    }

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _audioBloc.add(PlayTapAudio());

    // Reset timer on each tap
    _startTapTimer();

    if (event.keyValue == KeyboardOption.reset) {
      return;
    }

    if (event.keyValue == KeyboardOption.mainMenu) {
      return;
    }

    if (state.lifeRemaining < 0) {
      return;
    }

    if (state.expect == null || state.expect!.isEmpty) {
      return;
    }

    // Check if tap is correct or not
    String keyValue = keyboardArray[event.keyValue].toString();
    if (state.expect == null || state.expect!.isEmpty) {
      return;
    }

    if (keyValue == state.expect![state.currentTypingIndex]) {
      await _onMarkCorrectTap(
        event.keyValue,
        emit,
      );
    } else {
      await _onMarkWrongTap(emit);
      if (!state.isAbleToContinue) {
        return;
      }
    }

    // When correct, check if turn is finished
    if (state.isFinishTarget) {
      _stopTapTimer(); // Stop timer on completion
      await _onCombatAddPoint(CombatAddPoint(), emit);
      // Note: Level progression and audio handled in _onCombatAddPoint
      // Next turn will be triggered by CombatLevelChanged event
    }
  }

  Future<void> _onMarkCorrectTap(
    KeyboardOption keyValue,
    Emitter<CombatState> emit,
  ) async {
    final tappedNumber = keyboardArray[keyValue].toString();
    final newTyping = "${state.typing}$tappedNumber";

    debugPrint('⌨️ [Combat] Correct tap: $tappedNumber, newTyping: $newTyping');

    emit(
      state.copyWith(typing: newTyping),
    );

    // Debounce typing_update to prevent BLE flooding when user taps too fast
    // Store the latest input and send after debounce period
    _pendingTypingUpdate = newTyping;
    _typingUpdateDebounceTimer?.cancel();
    _typingUpdateDebounceTimer = Timer(_typingUpdateDebounce, () async {
      if (_pendingTypingUpdate != null) {
        final inputToSend = _pendingTypingUpdate!;
        _pendingTypingUpdate = null;

        debugPrint(
            '📤 [Combat] Sending debounced typing_update with currentInput: $inputToSend');
        await _sendMessage({
          'type': _messageTypeToString(CombatMessageType.typingUpdate),
          'currentInput': inputToSend,
        });
      }
    });
  }

  Future<void> _onMarkWrongTap(
    Emitter<CombatState> emit,
  ) async {
    _stopTapTimer(); // Stop timer on wrong tap
    add(CombatLostLife());

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: GameEndReason.myLivesOut));
      return;
    }
  }

  /// Handle Pick Right button tap in Combat mode
  Future<void> _onCombatPickRightButtonTap(
    CombatPickRightButtonTap event,
    Emitter<CombatState> emit,
  ) async {
    if (!state.isMyTurn) return;
    if (!state.isAbleToTap) return;

    final correctIndex = state.correctIndex ?? -1;
    final isCorrect = event.buttonIndex == correctIndex;

    developer.log(
        '🎮 [Combat] Pick Right button tap: ${event.buttonIndex}, correct: $correctIndex, isCorrect: $isCorrect');

    // Update selected option for UI feedback
    emit(state.copyWith(selectedOption: event.buttonIndex));

    // Stop tap timer
    _stopTapTimer();

    if (isCorrect) {
      // Correct answer - add point and proceed
      // Note: Audio and vibration are handled by _onCombatAddPoint to avoid duplicates

      // Trigger scale+fade animation on current buttons
      debugPrint('🎬 [Combat] pickRightJustCorrect → TRUE (user correct tap)');
      emit(state.copyWith(pickRightJustCorrect: true));

      // Send correct move to opponent immediately for instant firework
      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.moveCompleted),
        'input': event.buttonIndex.toString(),
        'wasCorrect': true,
        'score': state.point + 1,
        'lives': state.lifeRemaining,
      });

      // Wait for fade-out animation to complete before proceeding
      await Future.delayed(const Duration(milliseconds: 400));
      if (isClosed) return;

      // NOTE: pickRightJustCorrect stays true until _onCombatLevelChanged
      // emits new state, so buttons won't fade back in with old equations
      debugPrint(
          '🎬 [Combat] pickRightJustCorrect staying TRUE - proceeding to addPoint');

      await _onCombatAddPoint(CombatAddPoint(), emit);
    } else {
      // Wrong answer - lose life but keep same turn and same equations
      _audioBloc.add(PlayWrongAudio());
      _vibrationBloc.add(VibrateLong());

      // Don't send moveCompleted - that would trigger turn swap on guest side.
      // CombatLostLife already sends life_update to sync opponent's UI.
      add(CombatLostLife());

      // Keep same equations (no regeneration) - clear selection and restart timer
      emit(state.copyWith(selectedOption: null));
      _startTapTimer();
    }
  }

  Future<void> _onCombatLevelChanged(
    CombatLevelChanged event,
    Emitter<CombatState> emitter,
  ) async {
    emitter(
      state.copyWith(
        status: TurnStatus.playing,
        expect: "",
      ),
    );

    emitter(
      state.copyWith(
        level: event.level,
        timesCorrect: state.level != event.level ? 0 : null,
        typing: "",
        tapTimerRemaining:
            state.difficultyModel?.difficulty == Difficulty.pickRight
                ? kCombatPickRightTimerPerTurn.toDouble()
                : tapTimerDuration, // Reset timer on level change
      ),
    );

    // Send move completion to opponent
    // Skip for Pick Right mode - it already sent moveCompleted instantly
    // in _onCombatPickRightButtonTap for immediate firework on opponent's screen
    if (state.difficultyModel?.difficulty != Difficulty.pickRight) {
      final newScore = state.point;
      final newLives = state.lifeRemaining;

      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.moveCompleted),
        'input': state.typing,
        'wasCorrect': true,
        'score': newScore,
        'lives': newLives,
      });
    }

    // For non-Pick-Right modes: generate new equations before yielding turn
    // For Pick Right mode: DON'T generate equations here.
    // The opponent will generate them in _onCombatTurnStarted and send via BLE.
    // Generating locally would create a desync (two different equation sets).
    if (state.difficultyModel?.difficulty != Difficulty.pickRight) {
      // (non-pick-right modes don't use equations, but keeping for consistency)
    }

    // Yield the turn to the opponent - wait for their move
    debugPrint(
        '🎬 [Combat] Level changed - yielding turn, pickRightJustCorrect → false');
    emitter(state.copyWith(
      isMyTurn: false,
      isWaitingForOpponent: true,
      pickRightJustCorrect: false,
      selectedOption: null, // Clear selection highlight for clean appearance
    ));
  }

  Future<void> _onCombatLostLife(
    CombatLostLife event,
    Emitter<CombatState> emit,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - 1,
      ),
    );

    _vibrationBloc.add(VibrateShort());

    // Send current life number to opponent so they can update their UI
    // Include wrongTap flag to trigger red blink animation
    await _sendMessage({
      'type': 'life_update',
      'lives': state.lifeRemaining,
      'score': state.point,
      'wrongTap':
          true, // Flag to trigger red blink animation on opponent's side
    });

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: GameEndReason.myLivesOut));
    }
  }

  Future<void> _onCombatAddPoint(
    CombatAddPoint event,
    Emitter<CombatState> emit,
  ) async {
    _vibrationBloc.add(VibrateShort());

    // Note: move_success is now auto-detected by opponent from typing_update
    // when opponentInput.length == expect.length

    // Increment timesCorrect and add life bonus (every 3 correct turns)
    emit(
      state.copyWith(
        point: state.point + state.difficultyModel!.pointEachTurn,
        timesCorrect: state.timesCorrect + 1,
        lifeRemaining:
            state.timesCorrect >= state.difficultyModel!.numberTurnEachLevel - 1
                ? state.lifeRemaining + 1
                : state.lifeRemaining,
      ),
    );

    // Play sound based on whether leveling up
    if (state.isAbleToLevelUp) {
      _audioBloc.add(PlayCorrectUpAudio());
    } else {
      _audioBloc.add(PlayCorrectAudio());
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    if (isClosed) return;

    // Check if player should level up
    if (state.isAbleToLevelUp) {
      add(CombatLevelChanged(
        level: state.level + 1,
      ));
    } else {
      add(CombatLevelChanged(
        level: state.level,
      ));
    }
  }

  Future<String> _onCombatGeneratedRequiredString(
    CombatRequiredStringGenerated event,
    Emitter<CombatState> emit,
  ) async {
    String requiredString;
    late String expectString;

    switch (state.difficultyModel?.difficulty ?? Difficulty.easy) {
      case Difficulty.medium:
        Map<String, String> result =
            Helper().randomCalculatorWithPlusMinus(state.level);
        expectString = result['expect']!;
        requiredString = result['expression']!;
        break;
      case Difficulty.hard:
        Map<String, String> result =
            Helper().randomCalculatorWithMulDiv(state.level);
        expectString = result['expect']!;
        requiredString = result['expression']!;
        break;
      case Difficulty.extreme:
        final rand = Random();
        final choice = rand.nextInt(3);
        if (choice == 0) {
          var result = Helper().randomCalculatorWithPlusMinus(state.level + 2);
          expectString = result['expect']!;
          requiredString = result['expression']!;
        } else if (choice == 1) {
          expectString = Helper().generateRandomNumber(state.level + 5);
          requiredString = expectString;
        } else {
          var result = Helper().randomCalculatorWithMulDiv(state.level + 2);
          expectString = result['expect']!;
          requiredString = result['expression']!;
        }
        break;
      case Difficulty.pickRight:
        // Pick Right mode - generate three equations (one true, two false)
        Map<String, dynamic> equationsData =
            Helper().generatePickRightEquations(state.level);

        // expectString stores the correct button index (0, 1, or 2)
        expectString = equationsData['correctIndex'].toString();
        // requirementString shows all equations separated by pipe
        final eqs = equationsData['equations'] as List<String>;
        requiredString = eqs.join(' | ');

        developer.log(
            '🎮 [Combat] Generated Pick Right equations: $requiredString, correctIndex: $expectString');
        emit(
          state.copyWith(
            requirementString: requiredString,
            trueEquation: equationsData['trueEquation'],
            falseEquation: equationsData['falseEquation'],
            isLeftCorrect: equationsData['isLeftCorrect'],
            correctIndex: equationsData['correctIndex'],
            equations: List<String>.from(equationsData['equations']),
            selectedOption: null,
          ),
        );

        await Future.delayed(
            const Duration(milliseconds: kAnimationDurationSlow));

        emit(
          state.copyWith(
            expect: expectString,
          ),
        );
        return requiredString;
      case Difficulty.easy:
        expectString = Helper().generateRandomNumber(state.level + 2);
        requiredString = expectString;
        break;
    }

    developer.log(
        '🎮 [Combat] Generated requiredString: $requiredString, expectString: $expectString');
    emit(
      state.copyWith(
        requirementString: requiredString,
      ),
    );

    await Future.delayed(const Duration(milliseconds: kAnimationDurationSlow));

    emit(
      state.copyWith(
        expect: expectString,
      ),
    );
    return requiredString;
  }

  Future<void> _onCombatShowExpect(
    CombatExpectShown event,
    Emitter<CombatState> emit,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _stopTapTimer(); // Stop timer while showing new challenge

    await _onCombatGeneratedRequiredString(
        CombatRequiredStringGenerated(), emit);

    emit(
      state.copyWith(
        status: TurnStatus.initial,
      ),
    );

    await Future.delayed(
      event.duration,
      () {},
    );

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        status: TurnStatus.playing,
      ),
    );
  }

  Future<void> _onCombatResetNewNumber(
    CombatNumberReset event,
    Emitter<CombatState> emit,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    if (!state.isAbleToReset) {
      return;
    }

    _stopTapTimer();
    add(CombatLostLife());
    _vibrationBloc.add(VibrateMultiple());

    await Future.delayed(
        Duration(milliseconds: event.duration.inMilliseconds + 500));
    add(
      CombatLevelChanged(
        level: state.level,
      ),
    );
  }

  // ===== Tap Timer Methods =====

  void _startTapTimer() {
    _tapTimer?.cancel();
    const tickDuration = Duration(milliseconds: kAnimationDurationFast);
    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;
    double remainingTime = isPickRight
        ? kCombatPickRightTimerPerTurn.toDouble()
        : tapTimerDuration;

    _tapTimer = Timer.periodic(tickDuration, (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      remainingTime -= tickDuration.inMilliseconds / 1000.0;

      if (remainingTime <= 0) {
        timer.cancel();
        add(CombatTapTimerTick(0));
        add(CombatTapTimerTimeout());
      } else {
        add(CombatTapTimerTick(remainingTime));
      }
    });
  }

  void _stopTapTimer() {
    _tapTimer?.cancel();
  }

  void _onCombatTapTimerTick(
    CombatTapTimerTick event,
    Emitter<CombatState> emit,
  ) {
    if (isClosed) return;

    final clampedTime = event.remainingTime < 0.01 ? 0.0 : event.remainingTime;

    emit(
      state.copyWith(
        tapTimerRemaining: clampedTime,
      ),
    );
  }

  Future<void> _onCombatTapTimerTimeout(
    CombatTapTimerTimeout event,
    Emitter<CombatState> emit,
  ) async {
    if (isClosed) return;

    debugPrint(
        '⏰ [Combat] TapTimerTimeout fired - isMyTurn: ${state.isMyTurn}, isAbleToTap: ${state.isAbleToTap}, lives: ${state.lifeRemaining}, isGameActive: ${state.isGameActive}');

    if (!state.isAbleToTap) {
      debugPrint('⏰ [Combat] TapTimerTimeout skipped - isAbleToTap is false');
      return;
    }

    _stopTapTimer();

    // Inline life loss (don't use add() - it's async and state won't update before we check it)
    emit(state.copyWith(
      lifeRemaining: state.lifeRemaining - 1,
    ));
    _vibrationBloc.add(VibrateShort());

    debugPrint(
        '⏰ [Combat] Life decremented: ${state.lifeRemaining}, isAbleToContinue: ${state.isAbleToContinue}');

    // Send life_update to opponent
    await _sendMessage({
      'type': 'life_update',
      'lives': state.lifeRemaining,
      'score': state.point,
      'wrongTap': true,
    });

    if (!state.isAbleToContinue) {
      // Game over - send game_ended and navigate
      debugPrint(
          '⏰ [Combat] Timeout → Game Over! Lives: ${state.lifeRemaining}');

      // Send move_completed so opponent knows this turn is done
      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.moveCompleted),
        'input': '',
        'wasCorrect': false,
        'score': state.point,
        'lives': state.lifeRemaining,
      });

      add(CombatGameEnded(isWinner: false, reason: GameEndReason.timeout));
      return;
    } else {
      // Still alive - yield turn
      _audioBloc.add(PlayWrongAudio());
      _vibrationBloc.add(VibrateMultiple());

      debugPrint(
          '⏰ [Combat] Timeout but still alive (${state.lifeRemaining} lives) - yielding turn');

      await Future.delayed(
          const Duration(milliseconds: kAnimationDurationSlow));
      if (isClosed) return;

      // Send timeout notification to opponent
      await _sendMessage({
        'type': _messageTypeToString(CombatMessageType.moveCompleted),
        'input': '',
        'wasCorrect': false,
        'score': state.point,
        'lives': state.lifeRemaining,
      });

      // For pick-right mode, generate new equations before yielding turn
      if (state.difficultyModel?.difficulty == Difficulty.pickRight) {
        await _onCombatGeneratedRequiredString(
            CombatRequiredStringGenerated(), emit);
        debugPrint(
            '⏰ [Combat] Pick Right timeout: new equations generated: ${state.equations}');
      }

      // Yield the turn to the opponent
      emit(state.copyWith(
        isMyTurn: false,
        isWaitingForOpponent: true,
        pickRightJustCorrect: false,
        selectedOption: null,
      ));
    }
  }

  Future<void> _onCombatOpponentSuccessReceived(
    CombatOpponentSuccessReceived event,
    Emitter<CombatState> emit,
  ) async {
    // Set flag that opponent just succeeded - this will trigger firework in UI
    _vibrationBloc.add(VibrateShort());

    // Check if pick-right mode for additional animation
    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;

    emit(state.copyWith(
      opponentJustSucceeded: true,
      pickRightJustCorrect: isPickRight ? true : null,
    ));
    debugPrint(
        '🎬 [Combat] pickRightJustCorrect → ${isPickRight ? "TRUE" : "unchanged"} (opponent success)');

    // For non-pick-right, reset quickly; for pick-right, keep flag until turn starts
    if (!isPickRight) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (isClosed) return;
      emit(state.copyWith(opponentJustSucceeded: false));
    } else {
      // Reset opponentJustSucceeded quickly (firework already triggered)
      // but keep pickRightJustCorrect true until new turn starts
      await Future.delayed(const Duration(milliseconds: 10));
      if (isClosed) return;
      emit(state.copyWith(opponentJustSucceeded: false));
    }
  }

  Future<void> _onCombatOpponentLifeUpdate(
    CombatOpponentLifeUpdate event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint(
        '💔 [Combat] Handling opponent life update: lives=${event.opponentLives}, score=${event.opponentScore}, wrongTap=${event.wrongTap}');

    // Update opponent stats
    emit(state.copyWith(
      opponentLives: event.opponentLives,
      opponentScore: event.opponentScore,
      opponentJustLostLife:
          event.wrongTap, // Trigger red blink animation if wrong tap
    ));

    // If this was a wrong tap, reset the animation flag after 500ms
    if (event.wrongTap) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (isClosed) return;

      emit(state.copyWith(
        opponentJustLostLife: false, // Reset animation flag
      ));
    }
  }

  // Reset bloc to fresh initial state
  Future<void> _onCombatBlocReset(
    CombatBlocReset event,
    Emitter<CombatState> emit,
  ) async {
    debugPrint('🔄 [Combat] Resetting CombatBloc to initial state');

    // Cancel any active timers
    _tapTimer?.cancel();
    _tapTimer = null;

    // Reset to fresh initial state
    emit(const CombatState());

    debugPrint('✅ [Combat] CombatBloc reset complete');
  }

  // Constant maps for enum-to-string conversions
  static const Map<GameEndReason, String> _gameEndReasonToStringMap = {
    GameEndReason.opponentLivesOut: 'opponent_lives_out',
    GameEndReason.myLivesOut: 'my_lives_out',
    GameEndReason.opponentDisconnected: 'opponent_disconnected',
    GameEndReason.timeout: 'timeout',
  };

  static const Map<String, GameEndReason> _stringToGameEndReasonMap = {
    'opponent_lives_out': GameEndReason.opponentLivesOut,
    'my_lives_out': GameEndReason.myLivesOut,
    'opponent_disconnected': GameEndReason.opponentDisconnected,
    'timeout': GameEndReason.timeout,
  };

  static const Map<CombatMessageType, String> _messageTypeToStringMap = {
    CombatMessageType.difficultySelected: 'difficulty_selected',
    CombatMessageType.turnStart: 'turn_start',
    CombatMessageType.typingUpdate: 'typing_update',
    CombatMessageType.moveCompleted: 'move_completed',
    CombatMessageType.gameEnded: 'game_ended',
    CombatMessageType.restartRequested: 'restart_requested',
    CombatMessageType.restartReady: 'restart_ready',
    CombatMessageType.changeDifficulty: 'change_difficulty',
    CombatMessageType.opponentDisconnected: 'opponent_disconnected',
  };

  static const Map<String, CombatMessageType> _stringToMessageTypeMap = {
    'difficulty_selected': CombatMessageType.difficultySelected,
    'turn_start': CombatMessageType.turnStart,
    'typing_update': CombatMessageType.typingUpdate,
    'move_completed': CombatMessageType.moveCompleted,
    'game_ended': CombatMessageType.gameEnded,
    'restart_requested': CombatMessageType.restartRequested,
    'restart_ready': CombatMessageType.restartReady,
    'change_difficulty': CombatMessageType.changeDifficulty,
    'opponent_disconnected': CombatMessageType.opponentDisconnected,
  };

  // Helper function to convert GameEndReason enum to string for message transmission
  String _gameEndReasonToString(GameEndReason? reason) {
    if (reason == null) return '';
    return _gameEndReasonToStringMap[reason] ?? '';
  }

  // Helper function to convert CombatMessageType enum to string for message transmission
  String _messageTypeToString(CombatMessageType type) {
    return _messageTypeToStringMap[type] ?? '';
  }

  // Helper function to convert string to CombatMessageType enum
  CombatMessageType? _stringToMessageType(String type) {
    return _stringToMessageTypeMap[type];
  }

  // Helper function to convert string to GameEndReason enum
  // If swapPerspective is true, swaps "my" and "opponent" reasons
  GameEndReason? _stringToGameEndReason(String? reasonString,
      {bool swapPerspective = false}) {
    if (reasonString == null) return null;

    GameEndReason? reason = _stringToGameEndReasonMap[reasonString];
    if (reason == null) return null;

    // Swap perspective if requested (for receiving opponent's messages)
    if (swapPerspective) {
      switch (reason) {
        case GameEndReason.myLivesOut:
          return GameEndReason.opponentLivesOut;
        case GameEndReason.opponentLivesOut:
          return GameEndReason.myLivesOut;
        default:
          return reason;
      }
    }

    return reason;
  }
}
