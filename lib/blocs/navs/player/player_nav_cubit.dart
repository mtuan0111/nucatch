import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

class PlayerNavCubit extends Cubit<PlayerNavState> {
  PlayerNavCubit() : super(PlayerNavInitial());

  void showPlay() => emit(PlayingState());
  void showGameover() => emit(
        GameOverState(),
      );
}
