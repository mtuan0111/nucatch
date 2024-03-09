import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/screens/home_screen.dart';
import 'package:nucatch_with_bloc/screens/menu_screen.dart';

class MenuNav extends StatefulWidget {
  const MenuNav({super.key});

  @override
  State<MenuNav> createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  @override
  Widget build(BuildContext context) {
    bool requesToExits = false;
    return BlocBuilder<MenuBloc, MenuState>(
      builder: ((context, state) => PopScope(
            canPop: false,
            onPopInvoked: (involked) {
              if (state is Menu) {
                if (!requesToExits) {
                  requesToExits = true;
                  SnackBar snackBar = const SnackBar(
                    content: Text("Tap one more time to exit"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  context
                      .read<MenuBloc>()
                      .add(SelectOption(option: MenuOption.exit));
                }
              } else {
                requesToExits = false;
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
                    child: Text("Top Score"),
                  ),
                if (state is Setting)
                  const MaterialPage(
                    child: Text("Setting"),
                  ),
                if (state is About)
                  const MaterialPage(
                    child: Text("About"),
                  ),
              ],
            ),
          )),
    );
  }
}
