// Re-export from skeleton_core's generic TopScore nav states
// and provide backward-compatible TopScoreDetailState alias.
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:skeleton_core/skeleton_core.dart' as core;

export 'package:skeleton_core/skeleton_core.dart'
    show TopScoreNavState, TopScoreRootState;

/// Backward-compatible TopScoreDetailState for nucatch.
/// Maps the generic skeleton_core type to nucatch's concrete types.
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
