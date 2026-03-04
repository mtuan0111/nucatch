import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide TopScoreNavCubit, TopScoreNavState, TopScoreRootState, TopScoreDetailState;
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart' show PlayMode;

import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/navs/player_nav.dart';
import 'package:nucatch/navs/top_score_nav.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';

import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';

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
                  content: Text(coreLang(context).doYouWantToExit),
                  action: SnackBarAction(
                    label: coreLang(context).yes,
                    onPressed: () {
                      context
                          .read<MenuBloc>()
                          .add(SelectOption(option: MenuOption.exit));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              if (navState is! Play && navState is! InstantStart)
                context.read<MenuBloc>().add(ShowMenu());
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                return Navigator(
                  // onPopPage: (route, result) {
                  //   context.read<MenuBloc>().add(SelectOption(option: null));
                  //   return route.didPop(result);
                  // },
                  onDidRemovePage: (page) =>
                      context.read<MenuBloc>().add(ShowMenu()),
                  pages: [
                    const MaterialPage(
                      child: MenuScreen(),
                    ),
                    if (navState is Play || navState is InstantStart)
                      MaterialPage(
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => AudioBloc()
                                ..add(SetAudioVolume(
                                    volume: settingState.vol / 10)),
                            ),
                            BlocProvider(
                              create: (context) => VibrationBloc()
                                ..add(SetVibrationEnabled(
                                    enabled: settingState.isVibrate)),
                            ),
                            BlocProvider<TurnBloc>(
                              create: (context) {
                                final turnBloc = TurnBloc(
                                  const TurnState(),
                                  audioBloc: context.read<AudioBloc>(),
                                  vibrationBloc: context.read<VibrationBloc>(),
                                )..add(ApplySetting(
                                    settingModel: settingState.model));

                                // Difficulty will be loaded and set in SetDifficultScreen
                                return turnBloc;
                              },
                            ),
                            BlocProvider<PlayerNavCubit>(create: (context) {
                              // For instant start, set play mode to solo with isInstantStart flag
                              // The difficulty will be loaded and game will auto-start in SetDifficultScreen
                              if (navState is InstantStart) {
                                final cubit = PlayerNavCubit();
                                cubit.selectPlayModeForInstantStart(
                                    PlayMode.solo);
                                return cubit;
                              }

                              // Normal play flow - show play mode selection
                              return PlayerNavCubit()..showSelectPlayMode();
                            }),
                            BlocProvider(
                              create: (context) => CombatNavCubit(),
                            ),
                          ],
                          child: const PlayerNav(),
                        ),
                      ),
                    if (navState is TopScore)
                      MaterialPage(
                        child: BlocProvider(
                          create: (context) => TopScoreNavCubit(),
                          child: const TopScoreNav(),
                        ),
                      ),
                    if (navState is Setting)
                      MaterialPage(
                        child: SettingScreen(
                          title: (menuArray(
                              context)[MenuOption.setting]!['text']!),
                        ),
                      ),
                    if (navState is About)
                      MaterialPage(
                        child: AboutScreen(
                          title:
                              (menuArray(context)[MenuOption.about]!['text']!),
                        ),
                      ),
                  ],
                );
              },
            ),
          )),
    );
  }
}
