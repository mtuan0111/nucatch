import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/navs/combat_nav.dart';
import 'package:nucatch/navs/solo_nav.dart';
import 'package:nucatch/screens/menu_screens/player/select_play_mode_screen.dart';

class PlayerNav extends StatefulWidget {
  const PlayerNav({super.key});

  @override
  State<PlayerNav> createState() => _PlayerNavState();
}

class _PlayerNavState extends State<PlayerNav> {
  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  @override
  void initState() {
    super.initState();
    // See the BlocListener below's doc comment — `MenuBloc.add(...)` (which
    // first mounts PlayerNav) and `TutorialCubit.start()` (called right
    // after, in GlobalTourWrapper) both go through async event queues, so
    // by the time this widget subscribes, the tutorial may already be
    // active with no further emission left to react to. Catch that case
    // once, on mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final tutorial = context.read<TutorialCubit>().state;
      if (!tutorial.isActive) return;
      final playerNavCubit = context.read<PlayerNavCubit>();
      if (tutorial.lesson.arc == TutorialArc.combat) {
        playerNavCubit.selectPlayMode(PlayMode.combat);
      } else if (tutorial.lesson.hostScreen == TutorialHostScreen.playScreen) {
        playerNavCubit.showPlay(playMode: PlayMode.solo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TutorialCubit, TutorialState>(
      listenWhen: (previous, current) {
        if (!current.isActive) return false;
        // Regular arc's very first lesson (entered from GlobalTourWrapper,
        // one navigation hop before this widget's own state settles) and
        // the pickRight arc's wrap-up-into-next-lesson hand-off (from
        // gameOverScreen back to playScreen) both need PlayerNavState to be
        // (re-)pointed at solo PlayingState.
        //
        // Also when a play-screen lesson is set up again while GameOverScreen
        // is showing: Previous from a lesson whose real timeout just ended
        // the game (its result card sits on GameOverScreen) back to the one
        // before it — both are "play screen" lessons, but the game has to
        // come back on screen for the player to play it.
        final enteringPlayScreen = current.lesson.hostScreen ==
                TutorialHostScreen.playScreen &&
            (!previous.isActive ||
                previous.lesson.hostScreen != TutorialHostScreen.playScreen ||
                (previous.seedToken != current.seedToken &&
                    context.read<PlayerNavCubit>().state is GameOverState));
        // Cross-arc hand-off into Combat, skipping Setup/Host/SetDifficulty.
        final enteringCombat = current.lesson.arc == TutorialArc.combat &&
            (!previous.isActive || previous.lesson.arc != TutorialArc.combat);
        return enteringPlayScreen || enteringCombat;
      },
      listener: (context, state) {
        if (state.lesson.arc == TutorialArc.combat) {
          context.read<PlayerNavCubit>().selectPlayMode(PlayMode.combat);
        } else {
          context.read<PlayerNavCubit>().showPlay(playMode: PlayMode.solo);
        }
      },
      child: BlocBuilder<PlayerNavCubit, PlayerNavState>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            child: Navigator(
              // ignore: deprecated_member_use
              onPopPage: (route, result) {
                return false;
              },
              pages: [
                // Select play mode is always the base
                const MaterialPage(
                  child: SelectPlayModeScreen(),
                ),

                // Combat mode navigation
                if (state is CombatModeSetupState ||
                    (state is PlayingState &&
                        state.playMode == PlayMode.combat))
                  const MaterialPage(
                    child: CombatNav(),
                  ),

                // Solo mode navigation
                if (state is SetDifficultyState ||
                    (state is PlayingState &&
                        state.playMode == PlayMode.solo) ||
                    state is GameOverState)
                  const MaterialPage(
                    child: SoloNav(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
