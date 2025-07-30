import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
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
    return BlocBuilder<PlayerNavCubit, PlayerNavState>(
      builder: (context, state) {
        return PopScope(
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
                child: PopScope(
                  canPop: true,
                  child: PlayScreen(),
                ),
              ),
              if (state is SetDifficultyState)
                const MaterialPage(
                  child: SetDifficultScreen(),
                ),
              // if (state is PlayingState)
              //   const MaterialPage(
              //     child: PopScope(
              //       canPop: true,
              //       child: PlayScreen(),
              //     ),
              //   ),
              if (state is GameOverState)
                const MaterialPage(
                  child: GameOverScreen(),
                )
            ],
          ),
        );
      },
    );
  }
}
