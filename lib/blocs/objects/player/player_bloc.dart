import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/player/player_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc(super.initialState);
}
