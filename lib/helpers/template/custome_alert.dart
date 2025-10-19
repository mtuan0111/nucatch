import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';

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
      title: lang(context).confirmExit,
      message: lang(context).areYouSure,
      content: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null) RankingSortingWidget(position: rank!),
          if (rank != null) const SizedBox(height: 20),
          Text(
            "${lang(context).score}: $point",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${lang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, turnState.difficultyModel!.difficulty)}",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AnimatedButton(
            context,
            iconData: Helper.getIconFromDifficulty(
              context,
              turnState.difficultyModel!.difficulty,
            ),
            buttonSize: ButtonSize.small,

            // icon: Icon(Helper.getIconFromDifficulty(
            //     context, turnState.difficultyModel!.difficulty)),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (context) => AlertTemplate(
                  title: lang(context).confirmChangeDifficulty,
                  message: lang(context).areYouSure,
                  content: Text(lang(context).areYouSure),
                  actions: [
                    _buildActionButton(
                      context,
                      label: lang(context).yes,
                      color: Theme.of(context).primaryColor,
                      icon: Icons.check,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    _buildActionButton(
                      context,
                      label: lang(context).no,
                      color: Theme.of(context).colorScheme.error,
                      icon: Icons.close,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              ).then((confirmed) {
                if (confirmed == true) {
                  turnBloc.add(SaveRecorded(
                    callback: () {
                      playerNavCubit.showSetDifficulty();
                      Navigator.of(context).pop(false);
                    },
                  ));
                }
              });
            },
          )
        ],
      ),
      actions: [
        _buildActionButton(
          context,
          label: lang(context).yes,
          color: Theme.of(context).primaryColor,
          icon: Icons.check,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        _buildActionButton(
          context,
          label: lang(context).no,
          color: Theme.of(context).colorScheme.error,
          icon: Icons.close,
          onPressed: () => Navigator.of(context).pop(false),
        ),

        // _buildActionButton(
        //   context,
        //   label: lang(context).difficultySetting,
        //   color: Theme.of(context).secondaryHeaderColor,
        //   onPressed: () {
        //     ;
        //   },
        // ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: icon != null
          ? Icon(
              icon,
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            )
          : const SizedBox.shrink(),
      label: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertTemplate extends StatelessWidget {
  final String title;
  final String? message;
  final Widget content;
  final List<Widget> actions;

  const AlertTemplate({
    super.key,
    required this.title,
    this.message,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                message!,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions,
        )
      ],
    );
  }
}
