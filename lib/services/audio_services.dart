import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  static const pathPrefix = "sounds/";

  static const tapSound = "tap.mp3";
  // AudioCache tap_sound_audio = AudioCache()
  static const introSound = "intro.mp3";
  // AudioCache intro_sound_audio = AudioCache()

  static const correctSound = "correct.mp3";
  // AudioCache correct_sound_audio = AudioCache()
  static const correctUpSound = "correct_up.mp3";
  // AudioCache correct_up_sound_audio = AudioCache()

  static const wrongSOund = "wrong.mp3";
  // AudioCache wrong_sound_audio = AudioCache()
  static const endSound = "end.mp3";
  // AudioCache end_sound_audio = AudioCache()

  // late AudioPlayer _audioPlayer;
  double volume = 0.7;
  double get getVolume => volume;
  set setVolume(double volume) {
    this.volume = volume;
  }

  AudioServices({double? volume}) {
    if (volume != null) {
      this.volume = volume;
    }
  }

  Future<void> playSound(String soundPath) async {
    if (getVolume == 0) {
      return;
    }
    AudioPlayer().play(
      AssetSource(pathPrefix + soundPath),
      volume: getVolume,
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> playTap() {
    return playSound(tapSound);
  }

  Future<void> playIntro() {
    return playSound(introSound);
  }

  Future<void> playCorrect() {
    return playSound(correctSound);
  }

  Future<void> playCorrectUp() {
    return playSound(correctUpSound);
  }

  Future<void> playWrong() {
    return playSound(wrongSOund);
  }

  Future<void> playEnd() {
    return playSound(endSound);
  }
}
