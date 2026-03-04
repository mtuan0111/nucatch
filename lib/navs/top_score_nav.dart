import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide
        TopScoreNav,
        TopScoreNavCubit,
        TopScoreNavState,
        TopScoreRootState,
        TopScoreDetailState;
import 'package:skeleton_core/src/navs/top_score_nav.dart' as core_nav;
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/screens/menu_screens/top_score_details_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';
import 'package:nucatch/helpers/const.dart';

/// Nucatch-specific TopScoreNav that delegates to skeleton_core's
/// generic [TopScoreNav] with game-specific screen builders.
class TopScoreNav extends StatelessWidget {
  const TopScoreNav({super.key});

  @override
  Widget build(BuildContext context) {
    return core_nav.TopScoreNav<TurnRecordedModel, RankingPeriod>(
      titleBuilder: (ctx) => menuArray(ctx)[MenuOption.topScore]!['text']!,
      rootScreenBuilder: (ctx, title) => TopScoreScreen(title: title),
      detailScreenBuilder: (ctx, title, detailState) {
        return BlocProvider(
          create: (context) {
            return TurnRecordedBloc(
              TurnRecordedState(
                model: detailState.record,
              ),
            );
          },
          child: TopScoreDetailScreen(title: title),
        );
      },
    );
  }
}
