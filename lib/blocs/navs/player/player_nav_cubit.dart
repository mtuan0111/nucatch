import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

class PlayerNavCubit extends Cubit<PlayerNavState> {
  PlayerNavCubit() : super(PlayerNavInitial());

  PlayMode _currentPlayMode = PlayMode.solo;

  PlayMode get currentPlayMode => _currentPlayMode;

  void showSelectPlayMode() => emit(SelectPlayModeState());

  void selectPlayMode(PlayMode mode) {
    _currentPlayMode = mode;
    // Solo mode goes to difficulty first, Combat mode goes to setup
    if (mode == PlayMode.solo) {
      emit(SetDifficultyState(playMode: mode));
    } else {
      emit(CombatModeSetupState());
    }
  }

  /// Select play mode for instant start feature
  /// Emits SetDifficultyState with isInstantStart flag set to true
  void selectPlayModeForInstantStart(PlayMode mode) {
    _currentPlayMode = mode;
    // For instant start, always emit SetDifficultyState with isInstantStart = true
    emit(SetDifficultyState(playMode: mode, isInstantStart: true));
  }

  void showCombatModeSetup() => emit(CombatModeSetupState());

  void showPairingRoom({required bool isHost, String? roomCode}) {
    emit(PairingRoomState(isHost: isHost, roomCode: roomCode));
  }

  void showPlay({PlayMode? playMode}) =>
      emit(PlayingState(playMode: playMode ?? _currentPlayMode));

  void showGameover() => emit(GameOverState());

  void showSetDifficulty({PlayMode? playMode}) {
    emit(SetDifficultyState(playMode: playMode ?? _currentPlayMode));
  }

  /// Start game instantly without showing difficulty selection
  /// Used for instant start feature
  void startInstant(
      {PlayMode playMode = PlayMode.solo, Difficulty? difficulty}) {
    _currentPlayMode = playMode;
    if (difficulty != null) {
      emit(SetDifficultyState(playMode: playMode, difficulty: difficulty));
    } else {
      emit(PlayingState(playMode: playMode));
    }
  }
}
