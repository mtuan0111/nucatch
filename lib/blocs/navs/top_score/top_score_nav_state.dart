import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';

abstract class TopScoreNavState {}

class TopScoreRootState extends TopScoreNavState {}

class TopScoreDetailState extends TopScoreNavState {
  final TurnRecordedModel turnRecordedModel;
  final int? ranking;
  final RankingPeriod period;
  final bool isPersonalView;

  TopScoreDetailState({
    required this.turnRecordedModel,
    required this.ranking,
    required this.period,
    required this.isPersonalView,
  });
}
