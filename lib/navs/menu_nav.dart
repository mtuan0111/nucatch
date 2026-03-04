import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide
        MenuNav,
        TopScoreNav,
        TopScoreNavCubit,
        TopScoreNavState,
        TopScoreRootState,
        TopScoreDetailState;
import 'package:skeleton_core/src/navs/menu_nav.dart' as core_nav;
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart' show PlayMode;
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/navs/player_nav.dart';
import 'package:nucatch/navs/top_score_nav.dart';
import 'package:nucatch/screens/menu_screens/about_screen.dart';
import 'package:nucatch/screens/menu_screen.dart';
import 'package:nucatch/screens/menu_screens/setting_screen.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';

/// Nucatch-specific MenuNav that delegates to skeleton_core's
/// generic [MenuNav] with game-specific screen builders.
class MenuNav extends StatelessWidget {
  const MenuNav({super.key});

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();

    return core_nav.MenuNav(
      menuScreenBuilder: (_) => const MenuScreen(),
      menuArrayBuilder: (ctx) => menuArray(ctx),
      playScreenBuilder: (ctx, navState) {
        final settingState = settingBloc.state;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AudioBloc()
                ..add(SetAudioVolume(volume: settingState.vol / 10)),
            ),
            BlocProvider(
              create: (context) => VibrationBloc()
                ..add(SetVibrationEnabled(enabled: settingState.isVibrate)),
            ),
            BlocProvider<TurnBloc>(
              create: (context) {
                final turnBloc = TurnBloc(
                  const TurnState(),
                  audioBloc: context.read<AudioBloc>(),
                  vibrationBloc: context.read<VibrationBloc>(),
                )..add(ApplySetting(settingModel: settingState.model));
                return turnBloc;
              },
            ),
            BlocProvider<PlayerNavCubit>(create: (context) {
              if (navState is InstantStart) {
                final cubit = PlayerNavCubit();
                cubit.selectPlayModeForInstantStart(PlayMode.solo);
                return cubit;
              }
              return PlayerNavCubit()..showSelectPlayMode();
            }),
            BlocProvider(
              create: (context) => CombatNavCubit(),
            ),
          ],
          child: const PlayerNav(),
        );
      },
      topScoreScreenBuilder: (ctx) => BlocProvider(
        create: (context) => TopScoreNavCubit(),
        child: const TopScoreNav(),
      ),
      settingScreenBuilder: (ctx, title) => SettingScreen(title: title),
      aboutScreenBuilder: (ctx, title) => AboutScreen(title: title),
    );
  }
}
