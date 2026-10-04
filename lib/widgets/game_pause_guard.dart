import 'package:flutter/widgets.dart';

import 'package:nucatch/blocs/objects/timer_pause.dart';
import 'package:nucatch/helpers/game_layout.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';

/// Pauses a game screen's turn timer while the player can't see or reach
/// the board, and resumes it through a 3-2-1 countdown:
///
/// - the app leaves the foreground — a Flip closed, a Fold folded with
///   "continue on cover screen" off, the app switcher, an incoming call;
/// - the [GameLayoutMode] changes mid-round — fold/unfold, a posture change,
///   rotation — so a tap can't land on a keypad that just moved.
///
/// Each cause is its own [TimerPauseReason] hold, so this never unpauses a
/// timer someone else (the in-game menu) is still holding. Put
/// [resumeCountdownOverlay] last in the screen's [Stack].
mixin GamePauseGuard<T extends StatefulWidget> on State<T> {
  /// Whether a round is in progress — the only time the timer would tick
  /// and so the only time there is anything to pause.
  bool get isRoundLive;

  /// Adds/releases [reason]'s hold on the screen's bloc. Must not look up
  /// [context]: [onTimerRelease] is also called from [dispose].
  void onTimerHold(TimerPauseReason reason);
  void onTimerRelease(TimerPauseReason reason);

  /// The player just lost the board mid-round (left the app, or the window
  /// changed shape). May repeat; combat forwards it to the opponent.
  void onGuardAway() {}

  /// The resume 3-2-1 just started here. Combat forwards it so the
  /// opponent runs the same countdown.
  void onGuardResuming() {}

  late final AppLifecycleListener _lifecycleListener;
  final Set<TimerPauseReason> _guardHolds = {};
  GameLayoutMode? _lastLayoutMode;
  bool _showResumeCountdown = false;

  static const int resumeCountdownSeconds = 3;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onStateChange: _onAppLifecycle);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mode = GameLayout.of(context);
    final changed = _lastLayoutMode != null && mode != _lastLayoutMode;
    _lastLayoutMode = mode;
    if (changed && _hold(TimerPauseReason.layoutChange)) {
      onGuardAway();
      if (_appInForeground) {
        _showResumeCountdown = true; // build follows didChangeDependencies
        onGuardResuming();
      }
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    for (final reason in _guardHolds) {
      onTimerRelease(reason);
    }
    _guardHolds.clear();
    super.dispose();
  }

  /// Null before the platform's first lifecycle report — the app is on
  /// screen then.
  bool get _appInForeground => switch (WidgetsBinding.instance.lifecycleState) {
        null || AppLifecycleState.resumed => true,
        _ => false,
      };

  void _onAppLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_guardHolds.isNotEmpty && !_showResumeCountdown) {
        setState(() => _showResumeCountdown = true);
        onGuardResuming();
      }
      return;
    }
    if (_hold(TimerPauseReason.appLifecycle)) onGuardAway();
    // Leaving mid-countdown restarts it from 3 on return.
    if (_showResumeCountdown) setState(() => _showResumeCountdown = false);
  }

  /// Holds [reason] if a round is live. True when the timer is (now) held
  /// by this guard.
  bool _hold(TimerPauseReason reason) {
    if (!isRoundLive && _guardHolds.isEmpty) return false;
    if (_guardHolds.add(reason)) onTimerHold(reason);
    return true;
  }

  void _onResumeCountdownFinished() {
    if (!mounted) return;
    for (final reason in _guardHolds) {
      onTimerRelease(reason);
    }
    _guardHolds.clear();
    setState(() => _showResumeCountdown = false);
  }

  /// The 3-2-1 shown before a guarded pause ends, or null. Its backdrop
  /// blocks taps until the timer runs again.
  Widget? resumeCountdownOverlay() => _showResumeCountdown
      ? CountdownOverlay(
          key: const ValueKey('game-pause-guard-resume'),
          seconds: resumeCountdownSeconds,
          onFinished: _onResumeCountdownFinished,
        )
      : null;
}
