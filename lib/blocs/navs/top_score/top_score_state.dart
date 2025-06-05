import 'package:nucatch/models/turn_record_model.dart';

abstract class TopScoreState {}

class TopScoreRootState extends TopScoreState {}

class TopScoreDetailState extends TopScoreState {
  final TurnRecordedModel turnRecordedModel;
  final int? ranking;

  TopScoreDetailState({
    required this.turnRecordedModel,
    required this.ranking,
  });
}
