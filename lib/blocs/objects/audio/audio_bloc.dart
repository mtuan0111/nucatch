import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/audio/audio_event.dart';
import 'package:nucatch/blocs/objects/audio/audio_state.dart';
import 'package:nucatch/services/audio_services.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioServices _audioServices;

  AudioBloc()
      : _audioServices = AudioServices(),
        super(const AudioState()) {
    on<PlayIntroAudio>(_onPlayIntro);
    on<PlayTapAudio>(_onPlayTap);
    on<PlayCorrectAudio>(_onPlayCorrect);
    on<PlayCorrectUpAudio>(_onPlayCorrectUp);
    on<PlayWrongAudio>(_onPlayWrong);
    on<PlayEndAudio>(_onPlayEnd);
    on<PlaySaveSuccessAudio>(_onPlaySaveSuccess);
    on<PlaySecondTicking>(_onPlaySecondTicking);
    on<SetAudioVolume>(_onSetVolume);
  }

  Future<void> _onPlayIntro(
    PlayIntroAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'intro'));
    await _audioServices.playIntro();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayTap(
    PlayTapAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'tap'));
    await _audioServices.playTap();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayCorrect(
    PlayCorrectAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'correct'));
    await _audioServices.playCorrect();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayCorrectUp(
    PlayCorrectUpAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'correct_up'));
    await _audioServices.playCorrectUp();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayWrong(
    PlayWrongAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'wrong'));
    await _audioServices.playWrong();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayEnd(
    PlayEndAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'end'));
    await _audioServices.playEnd();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlaySaveSuccess(
    PlaySaveSuccessAudio event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'save_success'));
    await _audioServices.playSaveSuccess();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlaySecondTicking(
    PlaySecondTicking event,
    Emitter<AudioState> emitter,
  ) async {
    emitter(state.copyWith(isPlaying: true, lastPlayedSound: 'second_ticking'));
    await _audioServices.playSecondTicking();
    emitter(state.copyWith(isPlaying: false));
  }

  Future<void> _onSetVolume(
    SetAudioVolume event,
    Emitter<AudioState> emitter,
  ) async {
    _audioServices.setVolume = event.volume;
    emitter(state.copyWith(volume: event.volume));
  }
}
