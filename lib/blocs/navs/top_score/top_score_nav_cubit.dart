import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_state.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TopScoreNavCubit extends Cubit<TopScoreNavState> {
  TopScoreNavCubit() : super(TopScoreRootState());

  void showTopScore() => emit(TopScoreRootState());
  void showTopScoreDetail(
    TurnRecordedModel turnRecordedModel,
    int? ranking,
  ) =>
      emit(
        TopScoreDetailState(
          turnRecordedModel: turnRecordedModel,
          ranking: ranking,
        ),
      );
}
