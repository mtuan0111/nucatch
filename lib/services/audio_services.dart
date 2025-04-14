import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  static const FREFIX = "sounds/";

  static const TAP_SOUND = "tap.mp3";
  // AudioCache tap_sound_audio = AudioCache()
  static const INTRO_SOUND = "intro.mp3";
  // AudioCache intro_sound_audio = AudioCache()

  static const CORRECT_SOUND = "correct.mp3";
  // AudioCache correct_sound_audio = AudioCache()
  static const CORRECT_UP_SOUND = "correct_up.mp3";
  // AudioCache correct_up_sound_audio = AudioCache()

  static const WRONG_SOUND = "wrong.mp3";
  // AudioCache wrong_sound_audio = AudioCache()
  static const END_SOUND = "end.mp3";
  // AudioCache end_sound_audio = AudioCache()

  // late AudioPlayer _audioPlayer;
  double volume = 7;
  double get getVolume => volume;
  set setVolume(double volume) {
    this.volume = volume;
  }

  AudioServices() {
    // _audioPlayer = AudioPlayer();
  }
  void dispose() {
    // _audioPlayer.dispose();
  }

  Future<void> playSound(String soundPath) async {
    AudioPlayer().play(
      AssetSource(FREFIX + soundPath),
      volume: getVolume / 10,
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> playTap() {
    return playSound(TAP_SOUND);
  }

  Future<void> playIntro() {
    return playSound(INTRO_SOUND);
  }

  Future<void> playCorrect() {
    return playSound(CORRECT_SOUND);
  }

  Future<void> playCorrectUp() {
    return playSound(CORRECT_UP_SOUND);
  }

  Future<void> playWrong() {
    return playSound(WRONG_SOUND);
  }

  Future<void> playEnd() {
    return playSound(END_SOUND);
  }
}
