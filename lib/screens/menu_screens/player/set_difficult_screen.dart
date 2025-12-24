import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:nucatch/helpers/helper.dart';

import 'package:nucatch/helpers/template.dart';

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
                    const SizedBox(height: 20),
                    Text(
                      'Waiting for host to select difficulty...',
                      style: LayoutConfig(context).titleSectionStyle(),
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
                      duration: const Duration(milliseconds: 300),
                      color: isCollapsed
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            lang(context).difficultySetting,
                            textAlign: TextAlign.center,
                            style: LayoutConfig(context).displaySmallStyle(
                              isActiveShadow: true,
                              isItalic: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                leading: IconButton(
                  onPressed: () {
                    context.read<MenuBloc>().add(ShowMenu());
                    // Navigator.pop(context);
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
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: buttonSpace,
                          // runSpacing: buttonSpace,
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
                                playerNavCubit.showPlay(playMode: playMode);
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

                            return GestureDetector(
                              onTap: () {
                                onTap();
                              },
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          CustomElevatedButton(
                                            text: Helper
                                                .getDescriptionFromDifficulty(
                                                    context, difficulty),
                                            style: LayoutConfig(context)
                                                .contentSectionStyle(),
                                            buttonSize: ButtonSize.smallest,
                                            shapeAt:
                                                RoundedWithShapeAt.topRight,
                                            backgroundColor: Colors.black54,
                                            // color: difficultyColor,
                                          ),
                                          Positioned(
                                            top: -45,
                                            right: 10,
                                            child: CustomElevatedButton(
                                              text:
                                                  Helper.getTitleFromDifficulty(
                                                      context, difficulty),
                                              buttonSize: ButtonSize.small,
                                              shapeAt: RoundedWithShapeAt
                                                  .bottomRight,
                                              backgroundColor: Colors.grey,
                                              // color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  AnimatedButton(
                                    context,
                                    onPressed: () {
                                      onTap();
                                    },
                                    // text: textButton,
                                    iconData: difficultyIcon,
                                    shapeAt: RoundedWithShapeAt.topLeft,
                                    backgroundColor: difficultyColor,
                                    // color: Colors.black87,
                                  ),
                                ],
                              ),
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
