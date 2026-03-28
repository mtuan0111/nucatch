import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';

class MenuAlert extends StatelessWidget {
  final int point;
  final int? rank;
  final TurnBloc turnBloc;
  final TurnState turnState;
  final PlayerNavCubit playerNavCubit;

  const MenuAlert({
    super.key,
    this.point = 0,
    this.rank,
    required this.turnBloc,
    required this.turnState,
    required this.playerNavCubit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertTemplate(
      title: coreLang(context).mainMenu,
      message: coreLang(context).confirmExit,
      content: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null)
            Flexible(
              flex: 1,
              child: RankingSortingWidget(
                position: rank!,
              ),
            ),
          if (rank != null) const SizedBox(height: kSpaceXL),
          Text(
            "${lang(context).yourScoreIs}: $point",
            style: AppTextStyles.withColor(AppTextStyles.bodyLarge(context),
                Theme.of(context).colorScheme.primary.getDarker()),
          ),
          Text(
            "${coreLang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, turnState.difficultyModel!.difficulty)}",
            style: AppTextStyles.withColor(AppTextStyles.bodyLarge(context),
                Theme.of(context).colorScheme.primary.getDarker()),
          ),
          const SizedBox(height: kSpaceM),
          AnimatedButton(
            context,
            iconData: Helper.getIconFromDifficulty(
              context,
              turnState.difficultyModel!.difficulty,
            ),
            backgroundColor: Helper.getColorIconFromDifficulty(
              context,
              turnState.difficultyModel!.difficulty,
            ),
            text: coreLang(context).difficultySetting,
            shapeAt: RoundedWithShapeAt.topLeft,
            buttonSize: ButtonSize.smallest,
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertTemplate(
                  title: coreLang(context).difficultySetting,
                  message: lang(context).confirmChangeDifficulty,
                  possitiveButtonLabel: coreLang(context).yes,
                  onPossitiveButtonPressed: () =>
                      Navigator.of(context).pop(true),
                  negativeButtonLabel: coreLang(context).no,
                  onNegativeButtonPressed: () =>
                      Navigator.of(context).pop(false),
                ),
              ).then((confirmed) {
                if (confirmed == true && context.mounted) {
                  turnBloc.add(SaveRecorded(
                    callback: () {
                      // Close game over dialog
                      Navigator.of(context).pop(false);
                      // Show difficulty setting
                      playerNavCubit.selectPlayMode(
                        PlayMode.solo,
                      );
                    },
                  ));
                }
              });
            },
            backgroundBuilder: (context, borderRadius) {
              return LightningWidget(
                baseColor: Helper.getColorIconFromDifficulty(
                  context,
                  turnState.difficultyModel!.difficulty,
                ),
                seed: coreLang(context).difficultySetting.hashCode,
                borderRadius: borderRadius,
              );
            },
          ),
          const SizedBox(height: kSpaceM),
          // Restart button
          AnimatedButton(
            context,
            iconData: Icons.refresh,
            text: coreLang(context).restart,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            shapeAt: RoundedWithShapeAt.topRight,
            buttonSize: ButtonSize.smallest,
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertTemplate(
                  title: lang(dialogContext).restartGame,
                  message: lang(dialogContext).confirmRestart,
                  possitiveButtonLabel: coreLang(dialogContext).yes,
                  onPossitiveButtonPressed: () =>
                      Navigator.of(dialogContext).pop(true),
                  negativeButtonLabel: coreLang(dialogContext).no,
                  onNegativeButtonPressed: () =>
                      Navigator.of(dialogContext).pop(false),
                ),
              ).then((confirmed) {
                if (confirmed == true && context.mounted) {
                  turnBloc.add(SaveRecorded(
                    callback: () {
                      // Close game over dialog
                      Navigator.of(context).pop(false);
                      // Start new game with countdown
                      turnBloc.add(Start());
                    },
                  ));
                }
              });
            },
            backgroundBuilder: (context, borderRadius) {
              return LightningWidget(
                baseColor: Theme.of(context).colorScheme.tertiary,
                seed: coreLang(context).restart.hashCode,
                borderRadius: borderRadius,
              );
            },
          ),
          const SizedBox(height: kSpaceM),
        ],
      ),
      possitiveButtonLabel: coreLang(context).yes,
      onPossitiveButtonPressed: () => Navigator.of(context).pop(true),
      negativeButtonLabel: coreLang(context).no,
      onNegativeButtonPressed: () => Navigator.of(context).pop(false),
    );
  }
}

