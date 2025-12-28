import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_state.dart';
import 'package:nucatch/screens/menu_screens/player/combat_game_end_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_mode_setup_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/host_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/join_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';

/// Navigator for Combat Mode screens
class CombatNav extends StatelessWidget {
  const CombatNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombatNavCubit, CombatNavState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            // Setup screen is always the base
            const MaterialPage(child: CombatModeSetupScreen()),

            // Host room screen
            if (state is HostRoomState)
              const MaterialPage(child: HostRoomScreen()),

            // Join room screen
            if (state is JoinRoomState)
              const MaterialPage(child: JoinRoomScreen()),

            // Set difficulty screen (host only)
            if (state is CombatSetDifficultyState)
              const MaterialPage(child: SetDifficultScreen()),

            // Playing screen
            if (state is CombatPlayingState)
              const MaterialPage(child: CombatPlayScreen()),

            // End game screen
            if (state is CombatEndGameState)
              const MaterialPage(child: CombatGameEndScreen()),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            // Handle back navigation
            final currentState = context.read<CombatNavCubit>().state;
            if (currentState is HostRoomState ||
                currentState is JoinRoomState) {
              context.read<CombatNavCubit>().showSetup();
            } else if (currentState is CombatSetDifficultyState) {
              context.read<CombatNavCubit>().showHostRoom();
            } else if (currentState is CombatPlayingState ||
                currentState is CombatEndGameState) {
              context.read<CombatNavCubit>().showSetup();
            }

            return true;
          },
        );
      },
    );
  }
}
