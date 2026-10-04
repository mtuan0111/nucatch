import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/timer_pause.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:skeleton_core/skeleton_core.dart' show AudioBloc, VibrationBloc;

/// Records what the bloc sends and lets the test play the opponent.
class _FakeBle implements CombatBleService {
  final incoming = StreamController<Map<String, dynamic>>.broadcast();
  final sent = <Map<String, dynamic>>[];

  @override
  Stream<Map<String, dynamic>> get incomingDataStream => incoming.stream;

  @override
  String? get playerId => 'me';

  @override
  bool get isHost => true;

  @override
  Future<void> sendData(Map<String, dynamic> data) async => sent.add(data);

  @override
  Future<void> reset() async {}

  @override
  void dispose() => incoming.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The pause sync never plays sounds or vibrates; these just satisfy the
/// constructor without touching platform plugins.
class _SilentAudio implements AudioBloc {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _SilentVibration implements VibrationBloc {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

List<Map<String, dynamic>> _pauseUpdates(_FakeBle ble) =>
    ble.sent.where((m) => m['type'] == 'pause_update').toList();

void main() {
  late _FakeBle ble;
  late CombatBloc bloc;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  Future<void> fromOpponent(Map<String, dynamic> data) async {
    ble.incoming.add({...data, 'senderId': 'peer'});
    await settle();
    await settle();
  }

  Future<void> startRound() async {
    bloc.add(CombatGameStarted(
      difficulty: Difficulty.easy,
      isHost: true,
      combatStatus: CombatStatus.playing,
    ));
    await settle();
  }

  setUp(() {
    ble = _FakeBle();
    bloc = CombatBloc(
      roomService: ble,
      audioBloc: _SilentAudio(),
      vibrationBloc: _SilentVibration(),
    );
  });

  tearDown(() => bloc.close());

  group('this device pauses', () {
    test('sends one pause_update per change, with a rising seq', () async {
      await startRound();

      bloc
        ..add(CombatLocalPauseChanged(paused: true))
        ..add(CombatLocalPauseChanged(paused: true)) // repeat: dropped
        ..add(CombatLocalPauseChanged(paused: false));
      await settle();

      final updates = _pauseUpdates(ble);
      expect(updates.map((m) => m['paused']), [true, false]);
      expect(updates[1]['seq'], greaterThan(updates[0]['seq'] as int));
    });

    test('sends nothing between rounds', () async {
      bloc
        ..add(CombatLocalPauseChanged(paused: true))
        ..add(CombatLocalPauseChanged(paused: false));
      await settle();
      expect(_pauseUpdates(ble), isEmpty);
    });
  });

  group('the opponent pauses', () {
    test('away → resuming → none holds the timer until the 3-2-1 ends',
        () async {
      await startRound();

      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});
      expect(bloc.state.opponentPause, OpponentPause.away);
      expect(bloc.state.isTimerPaused, isTrue);

      await fromOpponent({'type': 'pause_update', 'paused': false, 'seq': 2});
      expect(bloc.state.opponentPause, OpponentPause.resuming);
      expect(bloc.state.isTimerPaused, isTrue,
          reason: 'still held while both devices count down');

      bloc.add(CombatOpponentResumeFinished());
      await settle();
      expect(bloc.state.opponentPause, OpponentPause.none);
      expect(bloc.state.isTimerPaused, isFalse);
    });

    test('ignores duplicated and out-of-order updates', () async {
      await startRound();

      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});
      await fromOpponent({'type': 'pause_update', 'paused': false, 'seq': 2});
      // A late copy of the first packet must not re-pause.
      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});
      expect(bloc.state.opponentPause, OpponentPause.resuming);
    });

    test('resuming does not unpause a timer this player is still holding',
        () async {
      await startRound();
      bloc.add(CombatTapTimerPause(TimerPauseReason.appLifecycle));
      await settle();

      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});
      await fromOpponent({'type': 'pause_update', 'paused': false, 'seq': 2});
      bloc.add(CombatOpponentResumeFinished());
      await settle();

      expect(bloc.state.opponentPause, OpponentPause.none);
      expect(bloc.state.isTimerPaused, isTrue);
    });

    test('a pause outside a round is ignored', () async {
      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});
      expect(bloc.state.opponentPause, OpponentPause.none);
      expect(bloc.state.isTimerPaused, isFalse);
    });
  });

  group('away too long', () {
    test('only an away-too-long opponent can be claimed against', () async {
      await startRound();
      await fromOpponent({'type': 'pause_update', 'paused': true, 'seq': 1});

      bloc.add(CombatClaimWinAfterAway()); // too early: ignored
      await settle();
      expect(bloc.state.combatStatus, CombatStatus.playing);

      bloc.add(CombatOpponentAwayTooLong());
      await settle();
      expect(bloc.state.opponentPause, OpponentPause.awayTooLong);

      bloc.add(CombatClaimWinAfterAway());
      await settle();
      await settle();
      expect(bloc.state.combatStatus, CombatStatus.ended);
      expect(bloc.state.isWinner, isTrue);
      expect(bloc.state.gameEndReason, GameEndReason.opponentAway);
      expect(bloc.state.opponentPause, OpponentPause.none);

      final ended = ble.sent.lastWhere((m) => m['type'] == 'game_ended');
      expect(ended['reason'], 'opponent_away');
    });

    test('the away player sees myAway when the win is claimed', () async {
      await startRound();
      await fromOpponent({
        'type': 'game_ended',
        'isWinner': true,
        'reason': 'opponent_away',
      });
      expect(bloc.state.isWinner, isFalse);
      expect(bloc.state.gameEndReason, GameEndReason.myAway);
    });

    test('opponentAwayLimit is one minute (plan §4.3)', () {
      expect(CombatBloc.opponentAwayLimit, const Duration(seconds: 60));
    });
  });
}
