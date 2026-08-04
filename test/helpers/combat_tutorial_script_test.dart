import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/combat_tutorial_script.dart';

void main() {
  group('CombatTutorialScript', () {
    test('opponentTypesAndSucceeds ends with a correct OpponentMoveCompleted', () {
      final script = CombatTutorialScript.opponentTypesAndSucceeds;
      expect(script, isNotEmpty);
      final last = script.last;
      expect(last, isA<OpponentMoveCompleted>());
      expect((last as OpponentMoveCompleted).wasCorrect, isTrue);
      expect(last.lives, 3);
    });

    test('opponentMissesOnce loses exactly one life and the match continues', () {
      final script = CombatTutorialScript.opponentMissesOnce;
      final lifeLost = script.whereType<OpponentLifeLost>().toList();
      expect(lifeLost, hasLength(1));
      expect(lifeLost.single.lives, 2);

      final last = script.last;
      expect(last, isA<OpponentMoveCompleted>());
      expect((last as OpponentMoveCompleted).wasCorrect, isFalse);
      expect(last.lives, greaterThan(0));
    });

    test('opponentLosesTheMatch ends with the opponent at 0 lives', () {
      final script = CombatTutorialScript.opponentLosesTheMatch;
      final lifeLost = script.whereType<OpponentLifeLost>().toList();
      expect(lifeLost, hasLength(1));
      expect(lifeLost.single.lives, 0);

      final last = script.last;
      expect(last, isA<OpponentMoveCompleted>());
      expect((last as OpponentMoveCompleted).lives, 0);
    });

    test('no script contains an OpponentGameEnded mid-sequence', () {
      for (final script in [
        CombatTutorialScript.opponentTypesAndSucceeds,
        CombatTutorialScript.opponentMissesOnce,
        CombatTutorialScript.opponentLosesTheMatch,
      ]) {
        final gameEndedIndices = <int>[
          for (var i = 0; i < script.length; i++)
            if (script[i] is OpponentGameEnded) i,
        ];
        for (final index in gameEndedIndices) {
          expect(index, script.length - 1,
              reason: 'OpponentGameEnded must be terminal when present');
        }
      }
    });

    test('every action has a non-negative delay', () {
      for (final script in [
        CombatTutorialScript.opponentTypesAndSucceeds,
        CombatTutorialScript.opponentMissesOnce,
        CombatTutorialScript.opponentLosesTheMatch,
      ]) {
        for (final action in script) {
          expect(action.delay.isNegative, isFalse);
        }
      }
    });
  });
}
