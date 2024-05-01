import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecorded/turn_recorded_state.dart';

class TurnRecordedBloc extends Bloc<TurnRecordedState, TurnRecordedEvent> {
  TurnRecordedBloc(super.initialState);
}
