abstract class TourEvent {}

/// Start the tour from the beginning
class TourStarted extends TourEvent {}

/// Move to the next tour step
class TourStepCompleted extends TourEvent {}

/// Go back to the previous tour step
class TourStepBack extends TourEvent {}

/// User skips the entire tour
class TourSkipped extends TourEvent {}

/// Tour has been completed
class TourCompleted extends TourEvent {}

/// Reset tour (restart from settings)
class TourReset extends TourEvent {}

/// Jump to a specific tour step
class TourJumpToStep extends TourEvent {
  final int stepIndex;

  TourJumpToStep(this.stepIndex);
}
