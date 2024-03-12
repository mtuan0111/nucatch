import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/player/player_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc(super.initialState) {
    on<MarkCorrectTurn>(_onMarkCorrectTurn);
  }

  void _onMarkCorrectTurn(
    MarkCorrectTurn event,
    Emitter<PlayerState> emitter,
  ) {
    emitter(
      state.copyWith(
        point: state.point + event.point,
        level: state.level,
      ),
    );
  }
}
