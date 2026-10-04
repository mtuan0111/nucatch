/// Why a turn timer is paused. Several can hold at once — the player opens
/// the in-game menu, then folds the phone shut — and the timer only runs
/// again once every one of them has been released.
enum TimerPauseReason {
  /// The in-game main-menu dialog is open.
  menu,

  /// The app is inactive, hidden or backgrounded: a Flip closed, a Fold
  /// folded with "continue on cover screen" off, the app switcher.
  appLifecycle,

  /// The window changed shape mid-turn (fold/unfold, posture change); held
  /// through the resume countdown so a tap can't land on a moving keypad.
  layoutChange,

  /// Combat only: the opponent paused on their device, so this one pauses
  /// too (both players pause together over BLE).
  opponent,
}

/// The set of [TimerPauseReason]s currently holding a turn timer paused.
/// Owned by the bloc; its `isTimerPaused` state is [isPaused].
class TimerPauseHolds {
  final Set<TimerPauseReason> _held = {};

  bool get isPaused => _held.isNotEmpty;

  bool isHeld(TimerPauseReason reason) => _held.contains(reason);

  void hold(TimerPauseReason reason) => _held.add(reason);

  void release(TimerPauseReason reason) => _held.remove(reason);

  /// Drops every hold — for a brand-new game or turn state.
  void clear() => _held.clear();
}
