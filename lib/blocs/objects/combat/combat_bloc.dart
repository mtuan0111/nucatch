import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
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
    on<CombatPlayerTapped>(_onTap);
    on<CombatTurnStarted>(_onTurnStarted);
    on<CombatTurnReceived>(_onTurnReceived);
    on<CombatOpponentMoveReceived>(_onOpponentMoveReceived);
    on<CombatGameEnded>(_onGameEnded);
    on<CombatOpponentDisconnected>(_onOpponentDisconnected);
    on<CombatDifficultyChanged>(_onDifficultySelected);
    on<CombatLevelChanged>(_onSetLevel);
    on<CombatLifeLost>(_onLostLife);
    on<CombatPointAdded>(_onAddPoint);
    on<CombatRequiredStringGenerated>(_onGeneratedRequiredString);
    on<CombatExpectShown>(_onShowExpect);
    on<CombatNumberReset>(_onResetNewNumber);

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

    // Completely reset state for fresh game
    emit(state.copyWith(
      isHost: event.isHost,
      difficultyModel: DifficultyModel.models[event.difficulty],
      combatStatus: event.isHost ? CombatStatus.hostSelecting : CombatStatus.waiting,
      isGameActive: true,
      lifeRemaining: 3,
      opponentLives: 3,
      point: 0,
      opponentScore: 0,
      isWinner: null, // Reset win/loss status
      gameEndReason: null, // Reset game end reason
      isMyTurn: false, // Reset turn state
      requirementString: null, // Clear previous challenge
      expect: null, // Clear previous target
      typing: '', // Clear input
      opponentInput: null, // Clear opponent input
      isWaitingForOpponent: false, // Reset waiting state
    ));

    print(
        '🎮 [Combat] After CombatGameStarted - state.isHost: ${state.isHost}');

    // Turn will be started after difficulty is selected
    // This ensures both players are ready before the first turn
  }

  Future<void> _onDifficultySelected(
    CombatDifficultyChanged event,
    Emitter<CombatState> emit,
  ) async {
    final difficultyModel = DifficultyModel.models[event.difficulty]!;

    emit(state.copyWith(
      difficultyModel: difficultyModel,
      combatStatus: CombatStatus.starting,
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
      add(CombatTurnStarted(isMyTurn: true));
    }
    // Guest does NOT trigger turn here - waits for turn_start message from host
  }

  Future<void> _onTurnStarted(
    CombatTurnStarted event,
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
      requirementString: requirement,
      expect: expect,
      typing: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      combatStatus: CombatStatus.playing,
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
    CombatTurnReceived event,
    Emitter<CombatState> emit,
  ) async {
    print(
        '🎮 [Combat] TurnReceived - isHost: ${state.isHost}, isMyTurn: ${event.isMyTurn}');

    // Receive challenge from opponent - NO new message sent
    emit(state.copyWith(
      isMyTurn: event.isMyTurn,
      requirementString: event.requirement,
      expect: event.expect,
      typing: '',
      opponentInput: null,
      isWaitingForOpponent: false,
      combatStatus: CombatStatus.playing,
    ));
  }

  Map<String, String> _generateChallenge() {
    if (state.difficultyModel == null) {
      return {'requirement': '123', 'expect': '123'};
    }

    // Use the same generation logic as solo mode
    final level = (state.point ~/ state.difficultyModel!.pointEachTurn) + 1;

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

  Future<void> _onOpponentMoveReceived(
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

  Future<void> _onGameEnded(
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

  Future<void> _onOpponentDisconnected(
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

  Future<void> _onTap(
    CombatPlayerTapped event,
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
      await _onAddPoint(CombatPointAdded(), emit);

      // Prepare for next turn - opponent's turn
      await Future.delayed(const Duration(milliseconds: 1000));

      final newScore = state.point;
      final newLives = state.lifeRemaining;

      // Send move to opponent
      await _sendMessage({
        'type': 'move_completed',
        'input': state.typing,
        'correct': true,
        'score': newScore,
        'lives': newLives,
      });

      // Check if game ended
      if (newLives <= 0) {
        add(CombatGameEnded(isWinner: false, reason: 'my_lives_out'));
        return;
      }

      // Start opponent's turn
      add(CombatTurnStarted(isMyTurn: false));
    }
  }

  Future<void> _onMarkCorrectTap(
    KeyboardOption keyValue,
    Emitter<CombatState> emit,
  ) async {
    emit(
      state.copyWith(
          typing: "${state.typing}${keyboardArray[keyValue].toString()}"),
    );
  }

  Future<void> _onMarkWrongTap(
    Emitter<CombatState> emit,
  ) async {
    add(CombatLifeLost());

    if (!state.isAbleToContinue) {
      add(CombatGameEnded(isWinner: false, reason: 'my_lives_out'));
      return;
    }
  }

  Future<void> _onSetLevel(
    CombatLevelChanged event,
    Emitter<CombatState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TurnStatus.playing,
        expect: "",
      ),
    );

    emit(
      state.copyWith(
        level: event.level,
        timesCorrect: state.level != event.level ? 0 : null,
        typing: "",
      ),
    );

    await _onShowExpect(
        CombatExpectShown(Duration(milliseconds: state.getTimeShowTarget)),
        emit);
  }

  Future<void> _onLostLife(
    CombatLifeLost event,
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

  Future<void> _onAddPoint(
    CombatPointAdded event,
    Emitter<CombatState> emit,
  ) async {
    emit(
      state.copyWith(
        point: state.point + state.difficultyModel!.pointEachTurn,
      ),
    );
  }

  Future<String> _onGeneratedRequiredString(
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

    emit(
      state.copyWith(
        requirementString: requiredString,
        expect: expectString,
      ),
    );
    return requiredString;
  }

  Future<void> _onShowExpect(
    CombatExpectShown event,
    Emitter<CombatState> emit,
  ) async {
    await _onGeneratedRequiredString(CombatRequiredStringGenerated(), emit);

    emit(
      state.copyWith(
        status: TurnStatus.initial,
      ),
    );

    await Future.delayed(event.duration, () {});

    emit(
      state.copyWith(
        status: TurnStatus.playing,
      ),
    );
  }

  Future<void> _onResetNewNumber(
    CombatNumberReset event,
    Emitter<CombatState> emit,
  ) async {
    if (!state.isAbleToReset) {
      return;
    }

    add(CombatLifeLost());

    await Future.delayed(
        Duration(milliseconds: event.duration.inMilliseconds + 500));
    await _onSetLevel(
      CombatLevelChanged(level: state.level),
      emit,
    );
  }
}
