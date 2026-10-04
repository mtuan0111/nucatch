import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/blocs/objects/timer_pause.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';
import 'package:nucatch/widgets/game_pause_guard.dart';
import 'package:skeleton_core/skeleton_core.dart' show CoreLocalizations;

import '../helpers/foldable_devices.dart';

/// Records the guard's holds the way the real screens forward them to
/// TurnBloc / CombatBloc.
class _Recorder {
  final holds = TimerPauseHolds();
  final log = <String>[];

  /// onGuardAway / onGuardResuming calls — what combat sends over BLE.
  final sync = <String>[];
}

class _GuardedScreen extends StatefulWidget {
  const _GuardedScreen({required this.recorder, required this.live});

  final _Recorder recorder;
  final bool live;

  @override
  State<_GuardedScreen> createState() => _GuardedScreenState();
}

class _GuardedScreenState extends State<_GuardedScreen> with GamePauseGuard {
  @override
  bool get isRoundLive => widget.live;

  @override
  void onTimerHold(TimerPauseReason reason) {
    widget.recorder.holds.hold(reason);
    widget.recorder.log.add('hold ${reason.name}');
  }

  @override
  void onTimerRelease(TimerPauseReason reason) {
    widget.recorder.holds.release(reason);
    widget.recorder.log.add('release ${reason.name}');
  }

  @override
  void onGuardAway() => widget.recorder.sync.add('away');

  @override
  void onGuardResuming() => widget.recorder.sync.add('resuming');

  @override
  Widget build(BuildContext context) => Stack(children: [
        const SizedBox.expand(),
        if (resumeCountdownOverlay() case final overlay?) overlay,
      ]);
}

Future<_Recorder> _pump(WidgetTester tester, {bool live = true}) async {
  FoldableDevices.phone.apply(tester);
  final recorder = _Recorder();
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: const [CoreLocalizations.delegate],
    supportedLocales: const [Locale('en')],
    home: Scaffold(body: _GuardedScreen(recorder: recorder, live: live)),
  ));
  await tester.pump();
  return recorder;
}

void _background(WidgetTester tester) {
  for (final s in [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
}

void _foreground(WidgetTester tester) {
  for (final s in [
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
}

Future<void> _finishCountdown(WidgetTester tester) async {
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('closing the phone mid-round holds until the 3-2-1 finishes',
      (tester) async {
    final r = await _pump(tester);

    _background(tester);
    await tester.pump();
    expect(r.holds.isHeld(TimerPauseReason.appLifecycle), isTrue);
    expect(find.byType(CountdownOverlay), findsNothing,
        reason: 'no countdown while the app is away');

    _foreground(tester);
    await tester.pump();
    expect(find.byType(CountdownOverlay), findsOneWidget);
    expect(r.holds.isPaused, isTrue, reason: 'still held during the 3-2-1');

    await _finishCountdown(tester);
    expect(r.holds.isPaused, isFalse);
    expect(find.byType(CountdownOverlay), findsNothing);
    expect(r.log, ['hold appLifecycle', 'release appLifecycle']);
    expect(r.sync.first, 'away');
    expect(r.sync.last, 'resuming',
        reason: 'the opponent is told when the 3-2-1 starts, so both run it');
  });

  testWidgets('unfolding mid-round pauses and counts down', (tester) async {
    final r = await _pump(tester);

    FoldableDevices.foldBook.apply(tester); // stacked → twoPane
    await tester.pump();
    expect(r.holds.isHeld(TimerPauseReason.layoutChange), isTrue);
    expect(find.byType(CountdownOverlay), findsOneWidget);

    await _finishCountdown(tester);
    expect(r.holds.isPaused, isFalse);
  });

  testWidgets('does nothing between rounds', (tester) async {
    final r = await _pump(tester, live: false);

    _background(tester);
    _foreground(tester);
    FoldableDevices.foldBook.apply(tester);
    await tester.pump();

    expect(r.log, isEmpty);
    expect(r.sync, isEmpty, reason: 'nothing to tell the opponent');
    expect(find.byType(CountdownOverlay), findsNothing);
  });

  testWidgets('releases its holds when disposed mid-countdown', (tester) async {
    final r = await _pump(tester);
    _background(tester);
    _foreground(tester);
    await tester.pump();
    expect(find.byType(CountdownOverlay), findsOneWidget);
    expect(r.holds.isPaused, isTrue);

    await tester.pumpWidget(const SizedBox());
    expect(r.holds.isPaused, isFalse);
  });
}
