import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/about_screen.dart';

import 'package:nucatch_with_bloc/screens/menu_screens/home_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/setting_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/top_score_screen.dart';

class MenuNav extends StatefulWidget {
  const MenuNav({super.key});

  @override
  State<MenuNav> createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: ((context, navState) => PopScope(
            canPop: false,
            onPopInvoked: (involked) {
              if (navState is Menu) {
                SnackBar snackBar = SnackBar(
                  content: const Text("Do you want to close the app?"),
                  action: SnackBarAction(
                    label: 'Yes',
                    onPressed: () {
                      context
                          .read<MenuBloc>()
                          .add(SelectOption(option: MenuOption.exit));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              context.read<MenuBloc>().add(SelectOption(option: null));
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                return userState is LoadingUser
                    ? const LoadingWidget()
                    : Navigator(
                        onPopPage: (route, result) {
                          context
                              .read<MenuBloc>()
                              .add(SelectOption(option: null));
                          return false;
                        },
                        pages: [
                          const MaterialPage(
                            child: MenuScreen(),
                          ),
                          if (navState is Home)
                            MaterialPage(
                              child: BlocProvider(
                                create: (context) => TurnBloc(InitialState()),
                                child: HomeScreen(),
                              ),
                            ),
                          if (navState is TopScore)
                            const MaterialPage(
                              child: TopScoreScreen(),
                            ),
                          if (navState is Setting)
                            const MaterialPage(
                              child: SettingScreen(),
                            ),
                          if (navState is About)
                            const MaterialPage(
                              child: AboutScreen(),
                            ),
                        ],
                      );
              },
            ),
          )),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
