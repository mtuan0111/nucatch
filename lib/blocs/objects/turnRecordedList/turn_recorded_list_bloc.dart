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

    add(LoadData());
  }

  Future<void> _onLoadData(
    LoadData event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    print("_onLoadData");
    emitter(
      state.copyWith(
        listModel: [],
        isLoading: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emitter(
      state.copyWith(
        listModel: await _turnedServices.getTurnedList(),
        isLoading: false,
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
