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

/// Game over content widget for Regular (normal) difficulty modes
/// Displays the requirement string, expected answer, and ranking
class GameOverRegular extends StatelessWidget {
  final TurnState turnState;

  const GameOverRegular({
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

            // The expression, when it differs from its answer
            if (turnState.expect != turnState.requirementString)
              Padding(
                padding: const EdgeInsets.only(
                  left: kSpace2XL,
                  right: kSpace2XL,
                  bottom: kSpaceS,
                ),
                child: Text(
                  turnState.requirementString ?? '',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            GameOverAnswer(answer: turnState.expect ?? ''),
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
              showScore: false,
            );
          },
        ),
      ],
    );
  }
}
