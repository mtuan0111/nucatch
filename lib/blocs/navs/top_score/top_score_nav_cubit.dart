// Re-export generic TopScore nav types from skeleton_core
// and provide nucatch-specific type aliases.
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
