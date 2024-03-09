import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
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
      builder: ((context, state) => PopScope(
            canPop: false,
            onPopInvoked: (involked) {
              if (state is Menu) {
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
            child: Navigator(
              onPopPage: (route, result) {
                context.read<MenuBloc>().add(SelectOption(option: null));
                return false;
              },
              pages: [
                const MaterialPage(
                  child: MenuScreen(),
                ),
                if (state is Home)
                  const MaterialPage(
                    child: HomeScreen(),
                  ),
                if (state is TopScore)
                  const MaterialPage(
                    child: TopScoreScreen(),
                  ),
                if (state is Setting)
                  const MaterialPage(
                    child: SettingScreen(),
                  ),
                if (state is About)
                  const MaterialPage(
                    child: AboutScreen(),
                  ),
              ],
            ),
          )),
    );
  }
}
