abstract class AudioEvent {}

class PlayIntroAudio extends AudioEvent {}

class PlayTapAudio extends AudioEvent {}

class PlayCorrectAudio extends AudioEvent {}

class PlayCorrectUpAudio extends AudioEvent {}

class PlayWrongAudio extends AudioEvent {}

class PlayEndAudio extends AudioEvent {}

class PlaySaveSuccessAudio extends AudioEvent {}

class PlaySecondTicking extends AudioEvent {}

class PlayNewTings extends AudioEvent {}

class SetAudioVolume extends AudioEvent {
  final double volume;

  SetAudioVolume({required this.volume});
}
