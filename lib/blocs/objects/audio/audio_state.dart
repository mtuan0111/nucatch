class AudioState {
  final double volume;
  final bool isPlaying;
  final String? lastPlayedSound;

  const AudioState({
    this.volume = 0.5,
    this.isPlaying = false,
    this.lastPlayedSound,
  });

  AudioState copyWith({
    double? volume,
    bool? isPlaying,
    String? lastPlayedSound,
  }) {
    return AudioState(
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      lastPlayedSound: lastPlayedSound ?? this.lastPlayedSound,
    );
  }
}
