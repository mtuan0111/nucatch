import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart' hide SettingScreen;
import 'package:skeleton_core/src/screens/setting_screen.dart' as core;
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart'
    as tlre;
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/helpers/const.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return core.SettingScreen(
      title: title,
      onNumberOfTopBoardChanged: (numberOfTopBoard) {
        final turnRecordedListBloc = context.read<TurnRecordedListBloc>();
        if (numberOfTopBoard != turnRecordedListBloc.state.numberOfTopBoard) {
          turnRecordedListBloc.add(
            tlre.ChangeNumberOfTopBoard(
              numberOfTopBoard: numberOfTopBoard,
            ),
          );
        }
      },
      additionalSettingsBuilder: (context, settingState) => [
        // Restart Tour Button
        Container(
          padding: const EdgeInsets.all(kPaddingL),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
              bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.compass,
                color: Theme.of(context).colorScheme.onPrimary,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(
                  lang(context).tourRestartFromSettings,
                  style: AppTextStyles.titleLarge(context),
                ),
              ),
              const SizedBox(width: kSpaceML),
              ElevatedButton(
                onPressed: () {
                  final tourBloc = context.read<TourBloc>();
                  tourBloc.add(TourReset());
                  tourBloc.add(TourStarted());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang(context).tourResetMessage,
                        style: AppTextStyles.bodyLarge(context),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                  context.read<MenuBloc>().add(ShowMenu());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(
                  lang(context).tourRestartFromSettings,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
