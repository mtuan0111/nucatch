// Nucatch-specific TopScore nav types
// These provide typed versions of skeleton_core's generic TopScore types
// using TurnRecordedModel and RankingPeriod.

import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:skeleton_core/skeleton_core.dart' as core;

export 'package:skeleton_core/skeleton_core.dart'
    show TopScoreNavState, TopScoreRootState;

/// Nucatch-specific TopScoreDetailState using TurnRecordedModel and RankingPeriod.
typedef NucatchTopScoreDetailState
    = core.TopScoreDetailState<TurnRecordedModel, RankingPeriod>;

/// Nucatch-specific TopScoreNavCubit using TurnRecordedModel and RankingPeriod.
class TopScoreNavCubit
    extends core.TopScoreNavCubit<TurnRecordedModel, RankingPeriod> {
  void showTopScoreDetail(
    TurnRecordedModel turnRecordedModel,
    int? ranking,
    RankingPeriod period,
    bool isPersonalView,
  ) =>
      emit(
        core.TopScoreDetailState<TurnRecordedModel, RankingPeriod>(
          record: turnRecordedModel,
          ranking: ranking,
          period: period,
          isPersonalView: isPersonalView,
        ),
      );
}

/// Convenience getter for accessing the record from TopScoreDetailState.
extension TopScoreDetailStateExtension on NucatchTopScoreDetailState {
  TurnRecordedModel get turnRecordedModel => record;
}

/// Backward-compatible TopScoreDetailState for nucatch.
class TopScoreDetailState
    extends core.TopScoreDetailState<TurnRecordedModel, RankingPeriod> {
  TopScoreDetailState({
    required TurnRecordedModel turnRecordedModel,
    required int? ranking,
    required RankingPeriod period,
    required bool isPersonalView,
  }) : super(
          record: turnRecordedModel,
          ranking: ranking,
          period: period,
          isPersonalView: isPersonalView,
        );

  /// Backward-compatible getter.
  TurnRecordedModel get turnRecordedModel => record;
}
