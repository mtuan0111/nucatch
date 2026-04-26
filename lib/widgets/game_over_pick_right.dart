import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';

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
        // Game Over title
        Text(
          coreLang(context).gameOver,
          style: AppTextStyles.displayLarge(context).copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpace3XL),

        // "The correct is" label
        Text(
          lang(context).theCorrectIs,
          style: AppTextStyles.withColor(
            AppTextStyles.bodyLargeMedium(context),
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: kSpaceS),

        // Show the actual correct equation (not the button index)
        Text(
          turnState.trueEquation ?? turnState.expect ?? '',
          style: AppTextStyles.displaySmall(context),
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

            return RankingItem(
              ranking: indexOfItem,
              iconData: FontAwesomeIcons.trophy,
              heroTag: "ranking-${turnState.recordedItem!.turnId}",
              currentUserLabel: lang(context).you,
              infoRows: [
                RankingInfoRow(
                  icon: Icons.person,
                  text: turnState.recordedItem!.playedUsername ??
                      coreLang(context).anonymous,
                ),
                RankingInfoRow(
                  icon: Icons.calendar_today,
                  text: (turnState.recordedItem!.recordedTime)
                      .formatClient()
                      .replaceFirst(' ', '\n'),
                ),
                RankingInfoRow(
                  icon: Helper.getIconFromDifficulty(
                      context, turnState.recordedItem!.difficulty),
                  text: Helper.getTitleFromDifficulty(
                      context, turnState.recordedItem!.difficulty),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
