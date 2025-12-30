import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/navs/combat_nav.dart';
import 'package:nucatch/navs/solo_nav.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';

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
    return BlocBuilder<PlayerNavCubit, PlayerNavState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Navigator(
            onPopPage: (route, result) {
              return false;
            },
            pages: [
              // Select play mode is always the base
              const MaterialPage(
                child: SelectPlayModeScreen(),
              ),

              // Combat mode navigation
              if (state is CombatModeSetupState ||
                  (state is PlayingState && state.playMode == PlayMode.combat))
                const MaterialPage(
                  child: CombatNav(),
                ),

              // Solo mode navigation
              if (state is SetDifficultyState ||
                  (state is PlayingState && state.playMode == PlayMode.solo) ||
                  state is GameOverState)
                const MaterialPage(
                  child: SoloNav(),
                ),
            ],
          ),
        );
      },
    );
  }
}
