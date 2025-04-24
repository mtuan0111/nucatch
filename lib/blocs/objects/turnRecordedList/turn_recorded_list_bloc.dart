import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch_with_bloc/services/turn_services.dart';

class TurnRecordedListBloc
    extends Bloc<TurnRecordedListEvent, TurnRecordedListState> {
  // SharedPreferences? _prefs;
  final TurnRecordedServices _turnedServices = TurnRecordedServices();

  TurnRecordedListBloc(super.state) {
    on<LoadData>(_onLoadData);
    on<ChangeNumberOfTopBoard>(_onChangeNumberOfTopBoard);

    add(LoadData());
  }

  Future<void> _onLoadData(
    LoadData event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    emitter(
      state.copyWith(
        listModel: [],
        isLoading: true,
      ),
    );

    emitter(
      state.copyWith(
        listModel: await _turnedServices.getTurnedList(state.numberOfTopBoard),
        isLoading: false,
      ),
    );
  }

  Future<void> _onChangeNumberOfTopBoard(
    ChangeNumberOfTopBoard event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    emitter(
      state.copyWith(
        numberOfTopBoard: event.numberOfTopBoard,
      ),
    );
  }

  // Future<void> _onAddItem(
  //   AddItem event,
  //   Emitter<TurnRecordedListState> emitter,
  // ) async {
  //   if (await _turnedServices.addItem(event.item)) {
  //     emitter(
  //       state.copyWith(
  //         listModel: await _turnedServices.getTurnedList(),
  //       ),
  //     );
  //   }
  // }
}
