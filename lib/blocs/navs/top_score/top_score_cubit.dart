import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_state.dart';

class TopScoreCubit extends Cubit<TopScoreState> {
  TopScoreCubit() : super(TopScoreRootState());

  void showTopScore() => emit(TopScoreRootState());
  void showTopScoreDetail() => emit(TopScoreDetailState());
}
