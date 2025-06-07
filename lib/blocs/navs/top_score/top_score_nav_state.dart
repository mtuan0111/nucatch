import 'package:nucatch/models/turn_record_model.dart';

abstract class TopScoreNavState {}

class TopScoreRootState extends TopScoreNavState {}

class TopScoreDetailState extends TopScoreNavState {
  final TurnRecordedModel turnRecordedModel;
  final int? ranking;

  TopScoreDetailState({
    required this.turnRecordedModel,
    required this.ranking,
  });
}
