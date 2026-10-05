import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart' hide SettingScreen;
import 'package:skeleton_core/src/screens/setting_screen.dart' as core;
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart'
    as tlre;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/widgets/account_setting_row.dart';

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
      // Any landscape (not just tablet) flows setting rows into a
      // 2-column grid instead of one long vertical list.
      enableLandscapeSplit: true,
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
      additionalSettingsBuilder: (context, settingState, buildField) => [
        // Account — sign in with Google/Apple, or show who is signed in.
        // Placed here rather than on its own screen because this is where a
        // player already comes to set their leaderboard name, and the two
        // decisions ("who am I" / "keep it across devices") belong together.
        if (kEnableAccountSignIn)
          buildField(
            context,
            iconData: FontAwesomeIcons.userShield,
            title: lang(context).accountSectionTitle,
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) =>
                  AccountSettingRow(userState: userState),
            ),
          ),
        // Restart Tour Button
        buildField(
          context,
          iconData: FontAwesomeIcons.compass,
          title: lang(context).tourRestartFromSettings,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.play,
                  size: kIconSizeS,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
