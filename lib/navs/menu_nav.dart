import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart' show PlayMode;

import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/audio/audio_bloc.dart';
import 'package:nucatch/blocs/objects/audio/audio_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:ble_plat_services/ble_plat_services.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_bloc.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_event.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/navs/player_nav.dart';
import 'package:nucatch/navs/top_score_nav.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';

import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';

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
                  content: Text(lang(context).doYouWantToExit),
                  action: SnackBarAction(
                    label: lang(context).yes,
                    onPressed: () {
                      context
                          .read<MenuBloc>()
                          .add(SelectOption(option: MenuOption.exit));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              if (navState is! Play) context.read<MenuBloc>().add(ShowMenu());
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
                    if (navState is Play)
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
                              create: (context) => TurnBloc(
                                const TurnState(),
                                audioBloc: context.read<AudioBloc>(),
                                vibrationBloc: context.read<VibrationBloc>(),
                              )..add(ApplySetting(
                                  settingModel: settingState.model))
                              // ..add(
                              //   Start(),
                              // )
                              ,
                            ),
                            BlocProvider<PlayerNavCubit>(create: (context) {
                              // if (Theme.of(context).platform ==
                              //     TargetPlatform.android) {
                              //   return PlayerNavCubit()..showSelectPlayMode();
                              // }

                              // if (Platform.isIOS) {
                              //   return PlayerNavCubit()
                              //     ..showSelectPlayMode()
                              //     ..selectPlayMode(PlayMode.solo);
                              // }

                              return PlayerNavCubit()..showSelectPlayMode()
                                  // ..selectPlayMode(PlayMode.solo)
                                  ;
                            }

                                // ..showSetDifficulty(),
                                ),
                            BlocProvider(
                              create: (context) => CombatNavCubit(),
                            ),
                            BlocProvider(
                              create: (context) {
                                // Create BLE infrastructure
                                final bleDataSource =
                                    BleDataSource(appPrefix: 'nucatch');
                                final bluetoothRepository =
                                    BluetoothRepositoryImpl(
                                  dataSource: bleDataSource,
                                );
                                final combatBleService = CombatBleService(
                                  repository: bluetoothRepository,
                                );

                                return CombatBloc(
                                  roomService: combatBleService,
                                  audioBloc: context.read<AudioBloc>(),
                                  vibrationBloc: context.read<VibrationBloc>(),
                                );
                              },
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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
