import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart' show GameEndReason;
import 'package:nucatch/helpers/combat_tutorial_script.dart';

/// Plays a scripted [CombatOpponentAction] transcript into a live
/// [CombatBloc], one action at a time, by dispatching the exact same events
/// `CombatBloc`'s real BLE message-handling would dispatch had a message
/// actually arrived from a peer — only the transport (BLE) is bypassed, the
/// real reducers run unmodified.
///
/// It's safe for the local player's own real taps to keep sending messages
/// during a scripted match: `CombatBleService.sendData`/`sendMessage`
/// no-ops whenever there's no connected endpoint, which is always the case
/// here since the tutorial's combat arc never calls
/// `startAdvertising`/`connectToDevice`.
///
/// Constructed once by the combat-arc entry gate in `combat_nav.dart`,
/// holding the same `CombatBloc` instance `CombatNav` already provides —
/// disposed automatically when `CombatNav` unmounts.
class CombatTutorialDriver {
  final CombatBloc combatBloc;

  CombatTutorialDriver({required this.combatBloc});

  Future<void> play(List<CombatOpponentAction> script) async {
    for (final action in script) {
      await Future.delayed(action.delay);
      if (combatBloc.isClosed) return;

      switch (action) {
        case OpponentTyping():
          combatBloc.add(
            CombatOpponentTypingUpdate(currentInput: action.partialInput),
          );
        case OpponentMoveCompleted():
          combatBloc.add(CombatOpponentMoveReceived(
            opponentInput: action.input,
            wasOpponentCorrect: action.wasCorrect,
            opponentScore: action.score,
            opponentLives: action.lives,
          ));
        case OpponentLifeLost():
          combatBloc.add(CombatOpponentLifeUpdate(
            opponentLives: action.lives,
            opponentScore: action.score,
            wrongTap: true,
          ));
        case OpponentGameEnded():
          combatBloc.add(CombatGameEnded(
            isWinner: !action.theyWon,
            reason: action.theyWon
                ? GameEndReason.opponentLivesOut
                : GameEndReason.myLivesOut,
            sendMessage: false,
          ));
      }
    }
  }
}
