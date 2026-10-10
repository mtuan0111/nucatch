import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/widgets/game_over_score.dart';
import 'package:nucatch/widgets/nucatch_ranking_item.dart';

/// Game over content widget for Pick Right difficulty mode
/// Shows the correct equation instead of button index
class GameOverPickRight extends StatelessWidget {
  final TurnState turnState;

  const GameOverPickRight({
    super.key,
    required this.turnState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spotlighted by the tutorial's game-over result beat.
        Column(
          key: TourKeys.gameOverSummaryKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            GameOverScore(point: turnState.point),
            const SizedBox(height: kSpace2XL),
            // The actual correct equation, not the button index
            GameOverAnswer(
              answer: turnState.trueEquation ?? turnState.expect ?? '',
            ),
          ],
        ),
        const SizedBox(height: kSpaceXL),

        // Ranking widget
        BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
          builder: (context, state) {
            if (state.isLoading || turnState.recordedItem == null) {
              return const LoadingWidget();
            }

            int? indexOfItem =
                state.listModel!.indexOfTurn(turnState.recordedItem!);

            return NucatchRankingItem(
              turnRecordedModel: turnState.recordedItem!,
              ranking: indexOfItem,
              heroTag: "ranking-${turnState.recordedItem!.turnId}",
            );
          },
        ),
      ],
    );
  }
}
