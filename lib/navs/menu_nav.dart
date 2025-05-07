import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/navs/player_nav.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';

import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';

class MenuNav extends StatefulWidget {
  const MenuNav({super.key});

  @override
  State<MenuNav> createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  SettingBloc get settingBloc => context.read<SettingBloc>();
  SettingState get settingState => settingBloc.state;
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
                return Navigator(
                  onPopPage: (route, result) {
                    context.read<MenuBloc>().add(SelectOption(option: null));
                    return route.didPop(result);
                  },
                  pages: [
                    const MaterialPage(
                      child: MenuScreen(),
                    ),
                    if (navState is Play)
                      MaterialPage(
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => TurnBloc(
                                TurnState(context),
                              )
                                ..add(ApplySetting(
                                    settingModel: settingState.model!))
                                ..add(
                                  Start(),
                                ),
                            ),
                            BlocProvider(
                              create: (context) => PlayerNavCubit(),
                            ),
                          ],
                          child: const PlayerNav(),
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
