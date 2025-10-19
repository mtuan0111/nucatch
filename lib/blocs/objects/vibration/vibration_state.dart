class VibrationState {
  final bool isEnabled;
  final bool isVibrating;
  final int? lastVibrationDuration;

  const VibrationState({
    this.isEnabled = true,
    this.isVibrating = false,
    this.lastVibrationDuration,
  });

  VibrationState copyWith({
    bool? isEnabled,
    bool? isVibrating,
    int? lastVibrationDuration,
  }) {
    return VibrationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isVibrating: isVibrating ?? this.isVibrating,
      lastVibrationDuration:
          lastVibrationDuration ?? this.lastVibrationDuration,
    );
  }
}
