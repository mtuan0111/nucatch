import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/blocs/objects/timer_pause.dart';

void main() {
  group('TimerPauseHolds', () {
    test('starts unpaused', () {
      expect(TimerPauseHolds().isPaused, isFalse);
    });

    test('stays paused until every reason is released', () {
      final holds = TimerPauseHolds()
        ..hold(TimerPauseReason.menu)
        ..hold(TimerPauseReason.appLifecycle);

      holds.release(TimerPauseReason.appLifecycle);
      expect(holds.isPaused, isTrue,
          reason: 'reopening the phone must not unpause behind the open menu');

      holds.release(TimerPauseReason.menu);
      expect(holds.isPaused, isFalse);
    });

    test('holding the same reason twice needs only one release', () {
      final holds = TimerPauseHolds()
        ..hold(TimerPauseReason.appLifecycle)
        ..hold(TimerPauseReason.appLifecycle)
        ..release(TimerPauseReason.appLifecycle);
      expect(holds.isPaused, isFalse);
    });

    test('releasing a reason that was never held is a no-op', () {
      final holds = TimerPauseHolds()
        ..hold(TimerPauseReason.menu)
        ..release(TimerPauseReason.layoutChange);
      expect(holds.isPaused, isTrue);
    });

    test('clear drops every hold', () {
      final holds = TimerPauseHolds()
        ..hold(TimerPauseReason.menu)
        ..hold(TimerPauseReason.layoutChange)
        ..clear();
      expect(holds.isPaused, isFalse);
    });
  });
}
