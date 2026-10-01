import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart' show Difficulty;
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
    on<SeedDemoLeaderboard>(_onSeedDemoLeaderboard);
  }

  /// Screenshot/demo-only: swap in a curated, deterministic leaderboard so the
  /// store-screenshot run never captures real players' usernames. See the
  /// [SeedDemoLeaderboard] doc comment and `tool/screenshots/README.md`.
  Future<void> _onSeedDemoLeaderboard(
    SeedDemoLeaderboard event,
    Emitter<TurnRecordedListState> emitter,
  ) async {
    // Invented names + descending points; the state getter re-sorts by point,
    // so order here is only for readability.
    const demoRows = <(String, int, Difficulty)>[
      ('NumNinja', 980, Difficulty.extreme),
      ('QuickAdd', 915, Difficulty.hard),
      ('MathMaven', 870, Difficulty.hard),
      ('SumSprinter', 806, Difficulty.medium),
      ('DigitDynamo', 742, Difficulty.medium),
      ('CarryOne', 689, Difficulty.medium),
      ('TenFrame', 604, Difficulty.easy),
      ('CountOn', 551, Difficulty.easy),
    ];
    final now = DateTime.now();
    final demoList = <TurnRecordedModel>[
      for (var i = 0; i < demoRows.length; i++)
        TurnRecordedModel(
          turnId: 'demo-$i',
          playedUsername: demoRows[i].$1,
          point: demoRows[i].$2,
          recordedTime: now.subtract(Duration(hours: i)),
          difficulty: demoRows[i].$3,
          firebaseUserId: 'demo-$i',
        ),
    ];
    emitter(state.copyWith(listModel: demoList, isLoading: false));
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
    debugPrint(
        'ℹ️ Database debugging not available - using Firestore offline persistence');
  }
}
