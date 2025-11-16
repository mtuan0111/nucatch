import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

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

  static const secondTickingSound = "second_ticking.mp3";

  static const saveSuccessSound = "save_success.wav";

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

  Future<void> playSaveSuccess() {
    return playSound(saveSuccessSound);
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

  Future<void> playSecondTicking() {
    return playSound(secondTickingSound);
  }
}

class VibrationServices {
  bool isVibrate = true;

  set setIsVibrate(bool isVibrate) {
    this.isVibrate = isVibrate;
  }

  Future<void> vibrate({int duration = 100}) async {
    if (!isVibrate) {
      return;
    }

    await Vibration.vibrate(duration: duration);
  }

  Future<void> multipleVibrate(
      {int count = 3, int duration = 200, int pause = 100}) async {
    if (!isVibrate) return;
    for (int i = 0; i < count; i++) {
      await vibrate(duration: duration);
      if (i < count - 1) {
        await Future.delayed(Duration(milliseconds: pause));
      }
    }
  }
}
