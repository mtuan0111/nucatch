import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lunar/calendar/Fu.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/audio/audio_bloc.dart';
import 'package:nucatch/blocs/objects/audio/audio_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_bloc.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_event.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/services/combat_nearby_service.dart';

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  final CombatNearbyService _roomService;
  final AudioBloc _audioBloc;
  final VibrationBloc _vibrationBloc;
  StreamSubscription? _messageSubscription;
  Timer? _tapTimer;

  // Expose isHost status from room service
  bool get isHost => _roomService.isHost;

  CombatBloc({
    required CombatNearbyService roomService,
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
    on<CombatLevelChanged>(_onCombatSetLevel);
    on<CombatRequiredStringGenerated>(_onCombatGeneratedRequiredString);
    on<CombatExpectShown>(_onCombatShowExpect);
    on<CombatNumberReset>(_onCombatResetNewNumber);
    on<CombatTapTimerTick>(_onCombatTapTimerTick);
    on<CombatTapTimerTimeout>(_onCombatTapTimerTimeout);
    on<CombatBlocReset>(_onCombatBlocReset);

    // Listen to BLE messages
    _messageSubscription = _roomService.messageStream.listen((data) {
      _handleRoomMessage(data);
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _tapTimer?.cancel();
    return super.close();
  }

  void _handleRoomMessage(Map<String, dynamic> data) {
    print('🎮 [Combat] Received message: $data');

    try {
      // Ignore messages sent by myself
      final senderId = data['senderId'] as String?;
      if (senderId == _roomService.playerId) {
        return;
      }

      final type = data['type'] as String;

      switch (type) {
        case 'difficulty_selected':
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
            add(CombatDifficultyChanged(difficulty: difficulty));
          }
          break;
        case 'turn_start':
          // Use _roomService.isHost instead of state.isHost to avoid race condition
          // where state might not be updated yet when message arrives
          final isMyTurn = data['isHostTurn'] == _roomService.isHost;
          final requirement = data['requirement'] as String;
          final expect = data['expect'] as String;
          print(
              '🎮 [Combat] turn_start received - isHostTurn: ${data['isHostTurn']}, _roomService.isHost: ${_roomService.isHost}, calculated isMyTurn: $isMyTurn');
          add(CombatTurnReceived(
            isMyTurn: isMyTurn,
            requirement: requirement,
            expect: expect,
          ));
          break;
        case 'typing_update':
          // Real-time typing progress from opponent
          if (!state.isMyTurn) {
            add(CombatOpponentTypingUpdate(
              currentInput: data['currentInput'],
            ));
          }
          break;
        case 'move_completed':
          add(CombatOpponentMoveReceived(
            opponentInput: data['input'],
            wasOpponentCorrect: data['correct'],
            opponentScore: data['score'],
            opponentLives: data['lives'],
          ));
          break;
        case 'game_ended':
          // Don't send message back - this prevents infinite loop
          add(CombatGameEnded(
            isWinner: !data['isWinner'], // Opponent sends their win status
            reason: data['reason'],
            sendMessage: false, // Don't echo the message back
          ));
          break;
        case 'restart_requested':
          add(CombatRestartRequested());
          break;
        case 'restart_ready':
          add(CombatRestartReadyReceived(
            opponentReady: data['isReady'] as bool,
          ));
          break;
        case 'opponent_disconnected':
          add(CombatOpponentDisconnected());
          break;
      }
    } catch (e) {
      print('❌ [Combat] Failed to parse message: $e');
    }
  }

  Future<void> _sendMessage(Map<String, dynamic> data) async {
    try {
      await _roomService.sendMessage(data);
      print('📤 [Combat] Sent message: $data');
    } catch (e) {
      print('❌ [Combat] Failed to send message: $e');
    }
  }

  Future<void> _onCombatGameStarted(
    CombatGameStarted event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] CombatGameStarted - event.isHost: ${event.isHost}, current state.isHost: ${state.isHost}');

    emit(CombatState(
      isHost: event.isHost,
      difficultyModel: DifficultyModel.models[event.difficulty],
      combatStatus: event.combatStatus ??
          (event.isHost ? CombatStatus.hostSelecting : CombatStatus.waiting),
      isGameActive: true,
      level: 1, // Start from level 1 like solo mode
      lifeRemaining: 3,
      opponentLives: 3,
      point: 0,
      opponentScore: 0,
    ));

    print(
        '🎮 [Combat] After CombatGameStarted - state.isHost: ${state.isHost}');

    // Turn will be started after difficulty is selected
    // This ensures both players are ready before the first turn
  }

  Future<void> _onCombatDifficultySelected(
    CombatDifficultyChanged event,
    Emitter<CombatState> emit,
  ) async {
    final difficultyModel = DifficultyModel.models[event.difficulty]!;

    emit(state.copyWith(
      difficultyModel: difficultyModel,
      combatStatus: CombatStatus.intro,
      countDown: 4, // Start countdown at 4 (will show 3-2-1-GO)
    ));

    // Only HOST sends the difficulty selection message
    if (state.isHost) {
      await _sendMessage({
        'type': 'difficulty_selected',
        'difficulty': event.difficulty.toString(),
      });
    }

    // Wait for countdown to finish (4 seconds)
    for (int i = 4; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (isClosed) return;
    }

    // After countdown, host starts their turn first
    if (state.isHost) {
      print('🎮 [Host] Starting my turn first (host goes first)');
      add(CombatTurnStarted(isMyTurn: true));
    }
    // Guest waits for turn_start message from host
  }

  Future<void> _onCombatTurnStarted(
    CombatTurnStarted event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] TurnStarted - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Generate new challenge based on difficulty and level using event handler
    await _onCombatGeneratedRequiredString(CombatRequiredStringGenerated(), emit);
    await Future.delayed(const Duration(milliseconds: 500)); // Slight delay
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
    ));

    // Send turn start message to opponent
    final isHostTurn = state.isHost ? event.isMyTurn : !event.isMyTurn;
    print('🎮 [Combat] Sending turn_start - isHostTurn: $isHostTurn');

    await _sendMessage({
      'type': 'turn_start',
      'isHostTurn': isHostTurn,
      'requirement': requirement,
      'expect': expect,
    });

    // Calculate show time based on level (similar to solo mode)
    final level = state.level;
    final diffShowLevelMilisecond = 100; // Increase by 100ms per level
    final showTime = 1000 + level * diffShowLevelMilisecond;

    // Wait for the show time, then transition to typing mode
    await Future.delayed(Duration(milliseconds: showTime));

    if (isClosed) return;

    emit(state.copyWith(
      status: TurnStatus.playing, // Now allow typing
    ));

    // Start tap timer when typing begins
    _startTapTimer();
  }

  Future<void> _onCombatTurnReceived(
    CombatTurnReceived event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] TurnReceived - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Receive challenge from opponent - NO new message sent
    // First, set to initial status to show the requirement
    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      requirementString: event.requirement,
      expect: event.expect,
      typing: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      combatStatus: CombatStatus.playing,
      status: TurnStatus.initial, // Show requirement first
    ));

    // Calculate show time based on level (similar to solo mode)
    final level = state.level;
    final diffShowLevelMilisecond = 100; // Increase by 100ms per level
    final showTime = 1000 + level * diffShowLevelMilisecond;

    // Wait for the show time, then transition to typing mode
    await Future.delayed(Duration(milliseconds: showTime));

    if (isClosed) return;

    emit(state.copyWith(
      status: TurnStatus.playing, // Now allow typing
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
      add(CombatGameEnded(isWinner: true, reason: 'opponent_lives_out'));
      return;
    }

    // Start my turn
    add(CombatTurnStarted(isMyTurn: true));
  }

  Future<void> _onCombatOpponentTypingUpdate(
    CombatOpponentTypingUpdate event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      opponentInput: event.currentInput,
    ));
  }

  Future<void> _onCombatGameEnded(
    CombatGameEnded event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      combatStatus: CombatStatus.ended,
      isWinner: event.isWinner,
      gameEndReason: event.reason,
      isGameActive: false,
    ));

    // Only send game ended message if this is a local game end (not from opponent)
    if (event.sendMessage) {
      await _sendMessage({
        'type': 'game_ended',
        'isWinner': event.isWinner,
        'reason': event.reason,
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
      gameEndReason: 'opponent_disconnected',
      isGameActive: false,
    ));
  }

  Future<void> _onCombatRestartRequested(
    CombatRestartRequested event,
    Emitter<CombatState> emit,
  ) async {
    print('🔄 [Combat] Restart requested');
    emit(state.copyWith(
      isRestartRequested: true,
      isPlayerReady: false,
      isOpponentReady: false,
    ));

    // Notify opponent
    await _sendMessage({
      'type': 'restart_requested',
    });
  }

  Future<void> _onCombatRestartReady(
    CombatRestartReady event,
    Emitter<CombatState> emit,
  ) async {
    print('🔄 [Combat] Player ready: ${event.isReady}');
    emit(state.copyWith(
      isPlayerReady: event.isReady,
    ));

    // Send ready status to opponent
    await _sendMessage({
      'type': 'restart_ready',
      'isReady': event.isReady,
    });

    // Check if both players are ready
    if (event.isReady && state.isOpponentReady) {
      await _restartGame(emit);
    }
  }

  Future<void> _onCombatRestartReadyReceived(
    CombatRestartReadyReceived event,
    Emitter<CombatState> emit,
  ) async {
    print('🔄 [Combat] Opponent ready: ${event.opponentReady}');
    emit(state.copyWith(
      isOpponentReady: event.opponentReady,
    ));

    // Check if both players are ready
    if (state.isPlayerReady && event.opponentReady) {
      await _restartGame(emit);
    }
  }

  Future<void> _restartGame(Emitter<CombatState> emit) async {
    print('🔄 [Combat] Both players ready - restarting game');

    // Reset to difficulty selection state
    emit(state.copyWith(
      combatStatus:
          state.isHost ? CombatStatus.hostSelecting : CombatStatus.waiting,
      isWinner: null,
      gameEndReason: null,
      isRestartRequested: false,
      isPlayerReady: false,
      isOpponentReady: false,
      isGameActive: false,
      level: 0,
      timesCorrect: 0,
      point: 0,
      lifeRemaining: 3,
      opponentScore: 0,
      opponentLives: 3,
      requirementString: null,
      expect: null,
      typing: '',
      opponentInput: null,
      isMyTurn: false,
      isWaitingForOpponent: false,
    ));
  }

  Future<void> _onCombatTap(
    CombatTap event,
    Emitter<CombatState> emit,
  ) async {
    if (!state.isMyTurn || !state.canTap) {
      return;
    }

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
    final newTyping = "${state.typing}${keyboardArray[keyValue].toString()}";

    emit(
      state.copyWith(typing: newTyping),
    );

    // Send real-time typing update to opponent
    await _sendMessage({
      'type': 'typing_update',
      'currentInput': newTyping,
    });
  }

  Future<void> _onMarkWrongTap(
    Emitter<CombatState> emit,
  ) async {
    _stopTapTimer(); // Stop timer on wrong tap
    add(CombatLostLife());

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: 'my_lives_out'));
      return;
    }
  }

  Future<void> _onCombatSetLevel(
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
        tapTimerRemaining: tapTimerDuration, // Reset timer on level change
      ),
    );

    // Send move completion to opponent
    final newScore = state.point;
    final newLives = state.lifeRemaining;

    await _sendMessage({
      'type': 'move_completed',
      'input': state.typing,
      'correct': true,
      'score': newScore,
      'lives': newLives,
    });

    await _onCombatShowExpect(
        CombatExpectShown(Duration(milliseconds: state.getTimeShowTarget)),
        emitter);

    // Start timer after showing challenge
    _startTapTimer();
  }

  Future<void> _onCombatLostLife(
    CombatLostLife event,
    Emitter<CombatState> emit,
  ) async {
    emit(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - 1,
      ),
    );

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: 'my_lives_out'));
    }
  }

  Future<void> _onCombatAddPoint(
    CombatAddPoint event,
    Emitter<CombatState> emit,
  ) async {
    _vibrationBloc.add(VibrateShort());

    emit(
      state.copyWith(
        point: state.point + state.difficultyModel!.pointEachTurn,
      ),
    );

    // Increment timesCorrect and add life bonus (every 3 correct turns)
    emit(
      state.copyWith(
        timesCorrect: state.timesCorrect + 1,
        lifeRemaining: state.timesCorrect >= 2
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
    if (!state.isAbleToReset) {
      return;
    }

    add(CombatLostLife());

    await Future.delayed(
        Duration(milliseconds: event.duration.inMilliseconds + 500));
    await _onCombatSetLevel(
      CombatLevelChanged(level: state.level),
      emit,
    );
  }

  // ===== Tap Timer Methods =====

  void _startTapTimer() {
    _tapTimer?.cancel();
    const tickDuration = Duration(milliseconds: 100);
    double remainingTime = tapTimerDuration;

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
    if (!state.canTap) return;

    _stopTapTimer();

    // Lose a life
    add(CombatLostLife());

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: 'timeout'));
      return;
    } else {
      _audioBloc.add(PlayWrongAudio());
      await Future.delayed(const Duration(milliseconds: 500));

      // Send timeout notification to opponent
      await _sendMessage({
        'type': 'move_completed',
        'input': '',
        'correct': false,
        'score': state.point,
        'lives': state.lifeRemaining,
      });

      // Wait for opponent to finish their turn
      emit(state.copyWith(
        isWaitingForOpponent: true,
        isMyTurn: false,
      ));
    }
  }

  // Reset bloc to fresh initial state
  Future<void> _onCombatBlocReset(
    CombatBlocReset event,
    Emitter<CombatState> emit,
  ) async {
    print('🔄 [Combat] Resetting CombatBloc to initial state');

    // Cancel any active timers
    _tapTimer?.cancel();
    _tapTimer = null;

    // Reset to fresh initial state
    emit(const CombatState());

    print('✅ [Combat] CombatBloc reset complete');
  }
}
