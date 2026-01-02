import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';

/// Navigator for Solo Mode screens
class SoloNav extends StatelessWidget {
  const SoloNav({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: BlocBuilder<PlayerNavCubit, PlayerNavState>(
        builder: (context, state) {
          return Navigator(
            pages: [
              // Set difficulty is always the base for solo mode
              const MaterialPage(child: SetDifficultScreen()),

              // Playing screen
              if (state is PlayingState && state.playMode == PlayMode.solo)
                MaterialPage(
                  child: PopScope(
                    canPop: true,
                    child: PopScope(
                      canPop: true,
                      child: PlayScreen(
                        title: menuArray(context)[MenuOption.start]!['text']!,
                      ),
                    ),
                  ),
                ),

              // Game Over screen
              if (state is GameOverState) ...[
                MaterialPage(
                  child: PopScope(
                    canPop: true,
                    child: PlayScreen(
                      title: menuArray(context)[MenuOption.start]!['text']!,
                    ),
                  ),
                ),
                const MaterialPage(
                  child: GameOverScreen(),
                ),
              ],
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

              // Handle navigation back based on current state
              if (state is GameOverState) {
                // From game over, go back to playing
                context.read<PlayerNavCubit>().showSetDifficulty();
              } else if (state is PlayingState) {
                // From playing, go back to difficulty selection
                context.read<PlayerNavCubit>().showSetDifficulty();
              }

              return true;
            },
          );
        },
      ),
    );
  }
}
