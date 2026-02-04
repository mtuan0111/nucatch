import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/services/turn_services.dart';

class TurnRecordedListBloc
    extends Bloc<TurnRecordedListEvent, TurnRecordedListState> {
  // SharedPreferences? _prefs;
  final TurnRecordedServices _turnedServices = TurnRecordedServices();

  TurnRecordedListBloc(super.state) {
    on<LoadData>(_onLoadData);
    on<LoadDataByPeriod>(_onLoadDataByPeriod);
    on<ChangeNumberOfTopBoard>(_onChangeNumberOfTopBoard);
    on<DebugDatabaseContent>(_onDebugDatabaseContent);

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

    // Clear cache for refresh operation
    _turnedServices.clearCache();

    // Use getTurnedListByPeriod which handles offline mode efficiently
    // This method tries Firestore first but falls back quickly to local DB
    final data = await _turnedServices.getTurnedListByPeriod(
      RankingPeriod.all,
      state.numberOfTopBoard,
      useFirebase: true, // Try Firebase but fallback quickly
      clearCache: true,
    );

    emitter(
      state.copyWith(
        listModel: data,
        isLoading: false,
        currentPeriod: RankingPeriod.all, // Default to all time using enum
      ),
    );
  }

  Future<void> _onLoadDataByPeriod(
    LoadDataByPeriod event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    emitter(
      state.copyWith(
        listModel: [],
        isLoading: true,
        currentPeriod: event.period,
      ),
    );

    try {
      List<TurnRecordedModel>? data;

      // Try Firebase first, then fallback to local
      if (event.useFirebase) {
        data = await _turnedServices.getTurnedListByPeriod(
          event.period, // Convert enum to string for service
          state.numberOfTopBoard,
          useFirebase: true,
          clearCache:
              event.isRefresh, // Clear cache if it's a refresh operation
          userId: event.userId, // Pass userId for filtering
        );
      }

      // Fallback to local if Firebase fails or not requested
      data ??= await _turnedServices.getTurnedListByPeriod(
        event.period, // Convert enum to string for service
        state.numberOfTopBoard,
        useFirebase: false,
        clearCache: event.isRefresh, // Clear cache if it's a refresh operation
        userId: event.userId, // Pass userId for filtering
      );

      emitter(
        state.copyWith(
          listModel: data,
          isLoading: false,
          currentPeriod: event.period,
        ),
      );
    } catch (e) {
      // Handle error - emit empty list but keep loading false
      emitter(
        state.copyWith(
          listModel: [],
          isLoading: false,
          currentPeriod: event.period,
        ),
      );
    }
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

  // Debug method removed - no longer needed with Firestore offline persistence
  Future<void> _onDebugDatabaseContent(
    DebugDatabaseContent event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    // No-op: Database debugging not needed with Firestore offline persistence
    print(
        'ℹ️ Database debugging not available - using Firestore offline persistence');
  }
}
