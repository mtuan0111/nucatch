import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/player/gameover_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/player/play_screen.dart';

class PlayerNav extends StatefulWidget {
  const PlayerNav({super.key});

  @override
  State<PlayerNav> createState() => _PlayerNavState();
}

class _PlayerNavState extends State<PlayerNav> {
  UserState get userState => BlocProvider.of<UserBloc>(context).state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerNavCubit, PlayerNavState>(
      builder: (context, state) {
        return Navigator(
          onPopPage: (route, result) {
            return route.didPop(result);
          },
          pages: [
            const MaterialPage(
              child: PlayScreen(),
            ),
            if (state is GameOverState)
              const MaterialPage(
                child: GameOverScreen(),
              )
          ],
        );
      },
    );
  }
}
