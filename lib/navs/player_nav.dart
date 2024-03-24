import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/player/home_screen.dart';

class PlayerNav extends StatefulWidget {
  const PlayerNav({super.key});

  @override
  State<PlayerNav> createState() => _PlayerNavState();
}

class _PlayerNavState extends State<PlayerNav> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerNavCubit, PlayerNavState>(
      builder: (context, state) {
        return BlocListener<TurnBloc, TurnState>(
          listener: (context, state) {
            if (state is! GameOverState &&
                state.status == TurnStatus.gameOver) {
              BlocProvider.of<PlayerNavCubit>(context).showGameover();
            }
          },
          child: Navigator(
            onPopPage: (route, result) {
              return route.didPop(result);
            },
            pages: [
              const MaterialPage(
                child: HomeScreen(),
              ),
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
