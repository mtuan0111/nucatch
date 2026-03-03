import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/navs/menu_nav.dart';

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
        // Game Over title
        Text(
          lang(context).gameOver,
          style: AppTextStyles.displayLarge(context).copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpace3XL),

        // Show requirement string if different from expected
        if (turnState.expect != turnState.requirementString)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpace2XL),
            child: Text(
              turnState.requirementString ?? '',
              style: AppTextStyles.displayLarge(context).copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: kFontSizeXL,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: kSpaceL),

        // "The correct is" label
        Text(
          lang(context).theCorrectIs,
          style: AppTextStyles.withColor(
            AppTextStyles.bodyLargeMedium(context),
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: kSpaceS),

        // Expected answer
        Text(
          turnState.expect ?? '',
          style: AppTextStyles.displayLarge(context).copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
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
              turnRecordedModel: turnState.recordedItem!,
              iconData: FontAwesomeIcons.trophy,
            );
          },
        ),
      ],
    );
  }
}
