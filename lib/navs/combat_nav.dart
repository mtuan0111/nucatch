import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_state.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/screens/menu_screens/player/combat_game_end_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_mode_setup_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_play_screen.dart';
import 'package:nucatch/screens/menu_screens/player/combat_restart_confirmation_screen.dart';
import 'package:nucatch/screens/menu_screens/player/host_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/join_room_screen.dart';
import 'package:nucatch/screens/menu_screens/player/set_difficult_screen.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:ble_plat_services/ble_plat_services.dart';

/// Navigator for Combat Mode screens
class CombatNav extends StatefulWidget {
  const CombatNav({super.key});

  @override
  State<CombatNav> createState() => _CombatNavState();
}

class _CombatNavState extends State<CombatNav> {
  @override
  void initState() {
    super.initState();
    // The entry-gate BlocListener below only reacts to emissions AFTER it
    // subscribes — if the tutorial already transitioned into the combat arc
    // before this widget even mounted (player_nav.dart's own listener is
    // what causes CombatNav to mount in the first place, reacting to that
    // exact same emission first), there's no later emission left for this
    // widget's listener to catch. Same fix as PlayerNav's initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final tutorial = context.read<TutorialCubit>().state;
      if (tutorial.isActive && tutorial.lesson.arc == TutorialArc.combat) {
        context.read<CombatNavCubit>().showPlaying();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create fresh CombatBloc + CombatBleService each time combat mode is entered.
    // This ensures a clean BLE state every time, preventing stale connections
    // when users go back to Select Play Mode and re-enter combat.
    return BlocProvider<CombatBloc>(
      create: (context) {
        final bleDataSource = BleDataSource(appPrefix: kBleAppPrefix);
        final bluetoothRepository = BluetoothRepositoryImpl(
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
      child: MultiBlocListener(
        listeners: [
          // Combat-arc entry gate: skip Setup/Host/Join/SetDifficulty
          // entirely and land straight on a scripted "already paired"
          // playing state — see the plan's architecture decision on why the
          // combat arc never visits the real BLE pairing screens.
          BlocListener<TutorialCubit, TutorialState>(
            listenWhen: (previous, current) =>
                current.isActive &&
                current.lesson.arc == TutorialArc.combat &&
                (previous.lesson.arc != TutorialArc.combat ||
                    !previous.isActive),
            listener: (context, state) {
              context.read<CombatNavCubit>().showPlaying();
            },
          ),
          // Teardown once the tutorial ends. Lives here (on CombatNav, not
          // CombatPlayScreen) because the combat arc's last lesson
          // (CombatWrapUp) is hosted on the sibling CombatGameEndScreen —
          // this listener needs to survive that screen swap.
          BlocListener<TutorialCubit, TutorialState>(
            listenWhen: (previous, current) =>
                previous.isActive && !current.isActive,
            listener: (context, state) {
              context.read<CombatBloc>().add(CombatBlocReset());
              context.read<CombatNavCubit>().reset();
              context.read<PlayerNavCubit>().showSelectPlayMode();
              context.read<TourBloc>().add(TourCompleted());
            },
          ),
        ],
        child: BlocBuilder<CombatNavCubit, CombatNavState>(
        builder: (context, state) {
          return Navigator(
            pages: [
              // Setup screen is always the base
              const MaterialPage(child: CombatModeSetupScreen()),

              // Host room screen
              if (state is HostRoomState)
                const MaterialPage(child: HostRoomScreen()),

              // Join room screen
              if (state is JoinRoomState)
                const MaterialPage(child: JoinRoomScreen()),

              // Set difficulty screen (host only)
              if (state is CombatSetDifficultyState)
                const MaterialPage(child: SetDifficultScreen()),

              // Playing screen
              if (state is CombatPlayingState)
                const MaterialPage(child: CombatPlayScreen()),

              // End game screen
              if (state is CombatEndGameState)
                const MaterialPage(child: CombatGameEndScreen()),

              // Restart confirmation screen
              if (state is CombatRestartConfirmationState)
                const MaterialPage(child: CombatRestartConfirmationScreen()),
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

              // Handle back navigation
              final currentState = context.read<CombatNavCubit>().state;
              if (currentState is HostRoomState ||
                  currentState is JoinRoomState) {
                context.read<CombatNavCubit>().showSetup();
              } else if (currentState is CombatSetDifficultyState) {
                context.read<CombatNavCubit>().showHostRoom();
              } else if (currentState is CombatPlayingState ||
                  currentState is CombatEndGameState ||
                  currentState is CombatRestartConfirmationState) {
                context.read<CombatNavCubit>().showSetup();
              }

              return true;
            },
          );
        },
        ),
      ),
    );
  }
}
