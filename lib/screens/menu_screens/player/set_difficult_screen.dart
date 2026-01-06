import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/helper.dart';

import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

class SetDifficultScreen extends StatefulWidget {
  const SetDifficultScreen({super.key});

  @override
  State<SetDifficultScreen> createState() => _SetDifficultScreenState();
}

class _SetDifficultScreenState extends State<SetDifficultScreen> {
  UserBloc get userBloc => context.read<UserBloc>();

  TurnBloc get turnBloc => context.read<TurnBloc>();
  TurnState get turnState => turnBloc.state;

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;

  @override
  void initState() {
    // await _onSaveRecorded(SaveRecorded(savingRecord: itemModel), emitter);
    // turnBloc.add(SaveRecorded(context: context));

    turnRecordedListBloc.add(
      LoadData(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerNavCubit = context.read<PlayerNavCubit>();
    final playMode = playerNavCubit.currentPlayMode;

    // In combat mode, only host should see difficulty selection
    if (playMode == PlayMode.combat) {
      final combatBloc = context.read<CombatBloc>();
      if (!combatBloc.isHost) {
        // Guest should never reach this screen in combat mode
        // Show waiting screen with message
        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: kSpaceXL),
                    Text(
                      'Waiting for host to select difficulty...',
                      style: AppTextStyles.titleLarge(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                pinned: true,
                stretch: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final bool isCollapsed = appBarHeight <=
                        kToolbarHeight + MediaQuery.of(context).padding.top;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: kAnimationDurationMedium),
                      color: isCollapsed
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        title: Padding(
                          padding: const EdgeInsets.all(kPaddingM),
                          child: Text(
                            lang(context).difficultySetting,
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.displaySmallTitleScreen(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                leading: IconButton(
                  onPressed: () {
                    if (Theme.of(context).platform == TargetPlatform.iOS) {
                      context.read<MenuBloc>().add(ShowMenu());
                    } else {
                      // Navigate back to select play mode screen
                      playerNavCubit.showSelectPlayMode();
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.chevronLeft),
                ),
                expandedHeight: 100,
              ),
              DecoratedSliver(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                sliver: SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SafeArea(
                      child: DeviceWrapper(
                        child: Column(
                          spacing: buttonSpace,
                          children: Difficulty.values.map((difficulty) {
                            IconData difficultyIcon =
                                Helper.getIconFromDifficulty(
                                    context, difficulty);

                            Color difficultyColor =
                                Helper.getColorIconFromDifficulty(
                                    context, difficulty);

                            void onTap() {
                              final playerNavCubit =
                                  context.read<PlayerNavCubit>();
                              final playMode = playerNavCubit.currentPlayMode;

                              if (playMode == PlayMode.combat) {
                                // Combat mode: Initialize and send difficulty selection
                                final combatBloc = context.read<CombatBloc>();

                                // Initialize combat game with host/guest status and difficulty
                                combatBloc.add(CombatGameStarted(
                                  difficulty: difficulty,
                                  isHost: combatBloc.isHost,
                                ));

                                // Send difficulty selected event (will notify opponent via Firestore)
                                combatBloc.add(
                                    DifficultySelected(difficulty: difficulty));

                                // Navigate to play screen with combat mode
                                context.read<CombatNavCubit>().showPlaying();
                              } else {
                                // Solo mode: Use existing logic
                                turnBloc.add(
                                  SetDifficulty(
                                    difficulty: difficulty,
                                    onChanged: () {
                                      turnBloc.add(Start());
                                      playerNavCubit.showPlay(
                                          playMode: playMode);
                                    },
                                  ),
                                );
                              }
                            }

                            return OptionCard(
                              context: context,
                              title: Helper.getTitleFromDifficulty(
                                  context, difficulty),
                              description: Helper.getDescriptionFromDifficulty(
                                  context, difficulty),
                              icon: difficultyIcon,
                              color: difficultyColor,
                              onTap: onTap,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
