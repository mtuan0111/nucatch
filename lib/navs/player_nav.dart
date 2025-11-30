import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/bluetooth/bluetooth_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/screens/menu_screens/player/combat_mode_setup_screen.dart';
import 'package:nucatch/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch/screens/menu_screens/player/pairing_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';

class PlayerNav extends StatefulWidget {
  const PlayerNav({super.key});

  @override
  State<PlayerNav> createState() => _PlayerNavState();
}

class _PlayerNavState extends State<PlayerNav> {
  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BluetoothBloc(),
      child: BlocBuilder<PlayerNavCubit, PlayerNavState>(
        builder: (context, state) {
          return BlocListener<TurnBloc, TurnState>(
            listenWhen: (previous, current) {
              // Only listen when saveSuccess state changes and we have a message
              return previous.saveSuccess != current.saveSuccess &&
                  current.message != null;
            },
            listener: (context, state) {
              // Show toast based on save result
              if (state.message == 'save_success') {
                Fluttertoast.showToast(
                  msg: lang(context).insertedSuccess,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              } else if (state.message == 'save_failed') {
                Fluttertoast.showToast(
                  msg: lang(context).insertedFailed,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: PopScope(
              canPop: false,
              child: Navigator(
                onPopPage: (route, result) {
                  return false;
                },
                // onDidRemovePage: (page) {
                //   if (page is MaterialPage) {
                //     return context.read<MenuBloc>().add(ShowMenu());
                //   }
                // },
                pages: [
                  const MaterialPage(
                    child: SelectPlayModeScreen(),
                  ),
                  if (state is CombatModeSetupState)
                    const MaterialPage(
                      child: CombatModeSetupScreen(),
                    ),
                  if (state is PairingRoomState)
                    MaterialPage(
                      child: PairingRoomScreen(
                        isHost: state.isHost,
                        roomCode: state.roomCode,
                      ),
                    ),
                  if (state is SetDifficultyState)
                    const MaterialPage(
                      child: SetDifficultScreen(),
                    ),
                  if (state is PlayingState)
                    MaterialPage(
                      child: PopScope(
                        canPop: true,
                        child: PlayScreen(
                          title: menuArray(context)[MenuOption.start]!['text']!,
                        ),
                      ),
                    ),
                  if (state is GameOverState) ...[
                    MaterialPage(
                      child: PopScope(
                        canPop: true,
                        child: PlayScreen(
                            title:
                                menuArray(context)[MenuOption.start]!['text']!),
                      ),
                    ),
                    const MaterialPage(
                      child: GameOverScreen(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
