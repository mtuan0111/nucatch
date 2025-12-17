import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/services/combat_nearby_service.dart';

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  final CombatNearbyService _roomService;
  StreamSubscription? _messageSubscription;

  // Expose isHost status from room service
  bool get isHost => _roomService.isHost;

  CombatBloc({required CombatNearbyService roomService})
      : _roomService = roomService,
        super(const CombatState()) {
    on<CombatGameStarted>(_onCombatGameStarted);
    on<TurnStarted>(_onTurnStarted);
    on<TurnReceived>(_onTurnReceived);
    on<TurnCompleted>(_onTurnCompleted);
    on<OpponentMoveReceived>(_onOpponentMoveReceived);
    on<GameEnded>(_onGameEnded);
    on<OpponentDisconnected>(_onOpponentDisconnected);
    on<DifficultySelected>(_onDifficultySelected);
    on<InputUpdated>(_onInputUpdated);
    on<CombatReset>(_onCombatReset);

    // Listen to BLE messages
    _messageSubscription = _roomService.messageStream.listen((data) {
      _handleRoomMessage(data);
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
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
            add(CombatGameStarted(difficulty: difficulty, isHost: false));
            // Then handle difficulty selection
            add(DifficultySelected(difficulty: difficulty));
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
          add(TurnReceived(
            isMyTurn: isMyTurn,
            requirement: requirement,
            expect: expect,
          ));
          break;
        case 'move_completed':
          add(OpponentMoveReceived(
            opponentInput: data['input'],
            wasOpponentCorrect: data['correct'],
            opponentScore: data['score'],
            opponentLives: data['lives'],
          ));
          break;
        case 'game_ended':
          // Don't send message back - this prevents infinite loop
          add(GameEnded(
            isWinner: !data['isWinner'], // Opponent sends their win status
            reason: data['reason'],
            sendMessage: false, // Don't echo the message back
          ));
          break;
        case 'opponent_disconnected':
          add(OpponentDisconnected());
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

    // Completely reset state for fresh game
    emit(state.copyWith(
      isHost: event.isHost,
      difficultyModel: DifficultyModel.models[event.difficulty],
      status: event.isHost ? CombatStatus.hostSelecting : CombatStatus.waiting,
      isGameActive: true,
      myLives: 3,
      opponentLives: 3,
      myScore: 0,
      opponentScore: 0,
      isWinner: null, // Reset win/loss status
      gameEndReason: null, // Reset game end reason
      isMyTurn: false, // Reset turn state
      currentRequirement: null, // Clear previous challenge
      currentTarget: null, // Clear previous target
      myInput: '', // Clear input
      opponentInput: null, // Clear opponent input
      isWaitingForOpponent: false, // Reset waiting state
    ));

    print(
        '🎮 [Combat] After CombatGameStarted - state.isHost: ${state.isHost}');

    // Turn will be started after difficulty is selected
    // This ensures both players are ready before the first turn
  }

  Future<void> _onDifficultySelected(
    DifficultySelected event,
    Emitter<CombatState> emit,
  ) async {
    final difficultyModel = DifficultyModel.models[event.difficulty]!;

    emit(state.copyWith(
      difficultyModel: difficultyModel,
      status: CombatStatus.starting,
    ));

    // Only HOST triggers the first turn
    // Host goes first (isMyTurn: true for host)
    if (state.isHost) {
      await _sendMessage({
        'type': 'difficulty_selected',
        'difficulty': event.difficulty.toString(),
      });

      // Host starts their own turn first
      // The turn_start message will be sent to guest in _onTurnStarted
      print('🎮 [Host] Starting my turn first (host goes first)');
      add(TurnStarted(isMyTurn: true));
    }
    // Guest does NOT trigger turn here - waits for turn_start message from host
  }

  Future<void> _onTurnStarted(
    TurnStarted event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] TurnStarted - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Generate new challenge based on difficulty and level
    final challenge = _generateChallenge();
    final requirement =
        challenge['requirement']!; // What players see (e.g., "25 + 17")
    final expect = challenge['expect']!; // What players type (e.g., "42")

    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      currentRequirement: requirement,
      currentTarget: expect,
      myInput: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      status: CombatStatus.playing,
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
  }

  Future<void> _onTurnReceived(
    TurnReceived event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] TurnReceived - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Receive challenge from opponent - NO new message sent
    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      currentRequirement: event.requirement,
      currentTarget: event.expect,
      myInput: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      status: CombatStatus.playing,
    ));
  }

  Map<String, String> _generateChallenge() {
    if (state.difficultyModel == null) {
      return {'requirement': '123', 'expect': '123'};
    }

    // Use the same generation logic as solo mode
    final level = (state.myScore ~/ state.difficultyModel!.pointEachTurn) + 1;

    switch (state.difficultyModel!.difficulty) {
      case Difficulty.easy:
        final randomNum = Helper().generateRandomNumber(level + 2);
        return {'requirement': randomNum, 'expect': randomNum};
      case Difficulty.medium:
        return Helper().randomCalculatorWithPlusMinus(level);
      case Difficulty.hard:
        return Helper().randomCalculatorWithMulDiv(level);
      case Difficulty.extreme:
        return Helper().randomCalculatorWithMulDiv(level + 1);
    }
  }

  Future<void> _onTurnCompleted(
    TurnCompleted event,
    Emitter<CombatState> emit,
  ) async {
    final newScore = event.wasCorrect
        ? state.myScore + (state.difficultyModel?.pointEachTurn ?? 1)
        : state.myScore;

    final newLives = event.wasCorrect ? state.myLives : state.myLives - 1;

    emit(state.copyWith(
      myScore: newScore,
      myLives: newLives,
      isWaitingForOpponent: true,
    ));

    // Send move to opponent
    await _sendMessage({
      'type': 'move_completed',
      'input': event.playerInput,
      'correct': event.wasCorrect,
      'score': newScore,
      'lives': newLives,
    });

    // Check if game ended
    if (newLives <= 0) {
      add(GameEnded(isWinner: false, reason: 'my_lives_out'));
      return;
    }

    // Start opponent's turn
    add(TurnStarted(isMyTurn: false));
  }

  Future<void> _onOpponentMoveReceived(
    OpponentMoveReceived event,
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
      add(GameEnded(isWinner: true, reason: 'opponent_lives_out'));
      return;
    }

    // Start my turn
    add(TurnStarted(isMyTurn: true));
  }

  Future<void> _onGameEnded(
    GameEnded event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      status: CombatStatus.ended,
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

  Future<void> _onOpponentDisconnected(
    OpponentDisconnected event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(
      status: CombatStatus.ended,
      isWinner: true,
      gameEndReason: 'opponent_disconnected',
      isGameActive: false,
    ));
  }

  Future<void> _onInputUpdated(
    InputUpdated event,
    Emitter<CombatState> emit,
  ) async {
    // Only update input if it's the player's turn
    if (!state.isMyTurn || !state.canTap) return;

    emit(state.copyWith(myInput: event.input));
  }

  void _onCombatReset(
    CombatReset event,
    Emitter<CombatState> emit,
  ) {
    print('🔄 [Combat] Resetting combat state');

    // Reset to initial state
    emit(const CombatState());
  }
}
