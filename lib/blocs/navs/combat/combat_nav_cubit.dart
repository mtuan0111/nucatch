import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_state.dart';

class CombatNavCubit extends Cubit<CombatNavState> {
  CombatNavCubit() : super(CombatNavInitial());

  /// Show the combat mode setup screen (create or join room)
  void showSetup() => emit(CombatSetupState());

  /// Navigate to host room screen
  void showHostRoom() => emit(HostRoomState());

  /// Navigate to join room screen
  void showJoinRoom() => emit(JoinRoomState());

  /// Navigate to difficulty selection (host only)
  void showSetDifficulty() => emit(CombatSetDifficultyState());

  /// Navigate to playing screen
  void showPlaying() => emit(CombatPlayingState());

  /// Navigate to end game screen
  void showEndGame() => emit(CombatEndGameState());

  /// Navigate to restart confirmation screen
  void showRestartConfirmation() => emit(CombatRestartConfirmationState());

  /// Reset to initial state
  void reset() => emit(CombatNavInitial());
}
