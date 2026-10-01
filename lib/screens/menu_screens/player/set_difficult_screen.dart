// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:skeleton_core/skeleton_core.dart' hide LoadData;
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
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nucatch/helpers/preferences_key.dart';

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

  /// The difficulty the player used most recently. Surfaced as a Smart Default
  /// (UX psychology §4): the option most likely wanted is flagged with a
  /// "Last played" badge so choosing becomes recognising, not deciding. Read
  /// from the same persisted key the menu's Instant Start uses, so the two
  /// entry points always agree.
  Difficulty? _savedDifficulty;

  @override
  void initState() {
    // await _onSaveRecorded(SaveRecorded(savingRecord: itemModel), emitter);
    // turnBloc.add(SaveRecorded(context: context));

    turnRecordedListBloc.add(
      LoadData(),
    );

    _loadSavedDifficulty();

    // Auto-start if this is instant start (instant start feature)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final playerNavCubit = context.read<PlayerNavCubit>();
      final playerNavState = playerNavCubit.state;

      // Only auto-start for instant start, not regular start
      if (playerNavState is SetDifficultyState &&
          playerNavState.isInstantStart) {
        // Check if difficulty is pre-selected
        Difficulty? difficulty = playerNavState.difficulty;

        // If no pre-selected difficulty, load from SharedPreferences (instant start case)
        if (difficulty == null) {
          final prefs = await SharedPreferences.getInstance();
          final savedDifficulty = prefs.getString(
            NucatchPreferencesKey.LAST_USED_DIFFICULTY,
          );

          difficulty = Difficulty.easy;
          if (savedDifficulty != null) {
            try {
              difficulty = Difficulty.values.firstWhere(
                (d) => d.name == savedDifficulty,
              );
            } catch (e) {
              difficulty = Difficulty.easy;
            }
          }
        }

        final playMode = playerNavCubit.currentPlayMode;

        // Auto-select the difficulty and start the game
        turnBloc.add(
          SetDifficulty(
            difficulty: difficulty,
            onChanged: () {
              turnBloc.add(Start());
              playerNavCubit.showPlay(playMode: playMode);
            },
          ),
        );
      }
    });

    super.initState();
  }

  Future<void> _loadSavedDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName =
        prefs.getString(NucatchPreferencesKey.LAST_USED_DIFFICULTY);
    if (savedName == null) return;
    try {
      final difficulty =
          Difficulty.values.firstWhere((d) => d.name == savedName);
      if (mounted) setState(() => _savedDifficulty = difficulty);
    } catch (_) {
      // Unknown/legacy value — leave the badge off rather than guess.
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerNavCubit = context.read<PlayerNavCubit>();

    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              CustomSliverAppBar(
                title: coreLang(context).difficultySetting,
                onBackPressed: () {
                  if (Theme.of(context).platform == TargetPlatform.iOS) {
                    context.read<MenuBloc>().add(ShowMenu());
                  } else {
                    // Navigate back to select play mode screen
                    playerNavCubit.showSelectPlayMode();
                  }
                },
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
                        // Any landscape (not just tablet) gives the
                        // ResponsiveGrid below room for a 2-3 column layout.
                        maxWidth: context.isLandscapeOrientation ? 1200 : null,
                        child: ResponsiveGrid(
                          spacing: buttonSpace,
                          runSpacing: buttonSpace,
                          children: Difficulty.values.map((difficulty) {
                            FaIconData difficultyIcon =
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

                            final card = OptionCard(
                              context: context,
                              title: Helper.getTitleFromDifficulty(
                                  context, difficulty),
                              description: Helper.getDescriptionFromDifficulty(
                                  context, difficulty),
                              icon: difficultyIcon,
                              color: difficultyColor,
                              onTap: onTap,
                              backgroundBuilder: (context, borderRadius) {
                                return LightningWidget(
                                  baseColor: difficultyColor,
                                  seed: difficulty.hashCode,
                                  borderRadius: borderRadius,
                                );
                              },
                            );

                            // Smart Default (§4): only the most-recently-played
                            // difficulty gets the "Last played" badge, so the
                            // likely choice is recognised at a glance. The badge
                            // floats over the card's empty top-left, mirroring
                            // OptionCard's own pills, and rides its own filled
                            // container for legibility over any card colour.
                            if (_savedDifficulty != difficulty) return card;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                card,
                                const Positioned(
                                  top: -10,
                                  left: 4,
                                  child: _LastPlayedBadge(),
                                ),
                              ],
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

/// Small "Last played" pill marking the Smart Default difficulty (§4).
///
/// Rides its own filled, primary-coloured container with an icon — never a
/// bare label over the card art — so it stays legible on top of any card
/// colour (UI design system: controls over changing content sit on a
/// container, not as bare marks).
class _LastPlayedBadge extends StatelessWidget {
  const _LastPlayedBadge();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingM,
        vertical: kPaddingXS + 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kBorderRadiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.clockRotateLeft,
            size: kIconSizeS,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: kSpaceSM),
          Text(
            lang(context).lastPlayedLabel,
            style: AppTextStyles.labelMedium(context, color),
          ),
        ],
      ),
    );
  }
}
