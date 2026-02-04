import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TopScoreNavCubit extends Cubit<TopScoreNavState> {
  TopScoreNavCubit() : super(TopScoreRootState());

  void showTopScore() => emit(TopScoreRootState());
  void showTopScoreDetail(
    TurnRecordedModel turnRecordedModel,
    int? ranking,
    RankingPeriod period,
    bool isPersonalView,
  ) =>
      emit(
        TopScoreDetailState(
          turnRecordedModel: turnRecordedModel,
          ranking: ranking,
          period: period,
          isPersonalView: isPersonalView,
        ),
      );
}
