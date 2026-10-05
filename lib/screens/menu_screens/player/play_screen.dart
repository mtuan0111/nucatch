import 'dart:math' as math;
// ignore: unused_import
import 'dart:developer';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/timer_pause.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';
import 'package:nucatch/widgets/game_layout_body.dart';
import 'package:nucatch/widgets/game_pause_guard.dart';
import 'package:nucatch/widgets/countdown_bar.dart';
import 'package:nucatch/widgets/pick_right_mode_controls.dart';
import 'package:nucatch/widgets/regular_mode_controls.dart';
import 'package:nucatch/widgets/quick_setting_button.dart';
import 'package:nucatch/widgets/tutorial_overlay.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with GamePauseGuard {
  String get screenTitle => widget.title;

  double get buttonSpace => kSpaceXL;
  String inputtedValue = "";

  late bool wasLifeIncreased;
  late bool wasLifeDecreased;
  int? _prevLifeRemaining;
  late int _currentLifeRemaining;

  // Animation system
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  // Score/life keys are shared statics (TourKeys) rather than private
  // fields — the in-game rule tutorial spotlights the exact same widgets
  // via the exact same keys, and a GlobalKey can only back one mounted
  // widget at a time anyway. PlayScreen and CombatPlayScreen are never
  // mounted simultaneously, so reuse is safe.

  // Track which character indices have triggered fireworks
  final Set<int> _triggeredFireworkIndices = {};

  PlayerNavCubit get playerNavCubit => context.read<PlayerNavCubit>();
  PlayerNavState get playerNavState => playerNavCubit.state;

  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;

  TurnBloc get turnBloc => context.read<TurnBloc>();
  TurnState get turnState => turnBloc.state;

  SettingBloc get settingBloc => context.read<SettingBloc>();
  SettingState get settingState => settingBloc.state;

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  // Removed: boldedStyleFont - now using AppTextStyles.forChallenge()

  /// Cached for [GamePauseGuard], which releases its holds from [dispose].
  late final TurnBloc _guardedTurnBloc = context.read<TurnBloc>();

  @override
  bool get isRoundLive => turnState.status == TurnStatus.playing;

  @override
  void onTimerHold(TimerPauseReason reason) =>
      _guardedTurnBloc.add(TapTimerPause(reason));

  @override
  void onTimerRelease(TimerPauseReason reason) =>
      _guardedTurnBloc.add(TapTimerResume(reason));

  @override
  void initState() {
    _guardedTurnBloc; // resolve while the element is active
    // turnRecordedListBloc.add(LoadData());

    // Store previous lifeRemaining for animation logic
    // final prevLife = _prevLifeRemaining;
    // _prevLifeRemaining = turnState.lifeRemaining;
    _currentLifeRemaining = turnState.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;

    // BlocListener only reacts to emissions AFTER it subscribes — if the
    // tutorial already activated (or already landed on a playScreen lesson)
    // before this screen was even mounted (e.g. `TutorialCubit.start()` is
    // called by GlobalTourWrapper one navigation hop before PlayScreen
    // exists), the seed listener below would never fire for that first
    // lesson. Seed synchronously here to cover that case.
    final tutorial = context.read<TutorialCubit>().state;
    if (tutorial.isActive &&
        tutorial.lesson.hostScreen == TutorialHostScreen.playScreen &&
        tutorial.lesson.turnSeed != null) {
      final seed = tutorial.lesson.turnSeed!;
      turnBloc.add(SeedTutorialTurn(
        difficulty: seed.difficulty,
        requirementString: seed.requirementString,
        expect: seed.expect,
        level: seed.level,
        timesCorrect: seed.timesCorrect,
        lifeRemaining: seed.lifeRemaining,
        tapTimerSeconds: seed.tapTimerSeconds,
        startTimer: seed.startTimer,
        equations: seed.equations,
        correctIndex: seed.correctIndex,
        questionExpression: seed.questionExpression,
        showBeforePlaying: seed.showBeforePlaying,
      ));
    } else if (turnState.difficultyModel == null && !tutorial.isActive) {
      playerNavCubit.showSetDifficulty();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No-op, but required for stateful logic
  }

  bool _isMenuShowing = false;

  void _handleMenuButton() {
    // If menu is already showing, do nothing
    if (_isMenuShowing) return;

    // Mark menu as showing
    _isMenuShowing = true;

    // Pause timer when menu opens
    turnBloc.add(TapTimerPause());

    Helper.pressMainMenu(context).then((confirmedMenu) {
      // Mark menu as no longer showing
      _isMenuShowing = false;

      if (confirmedMenu) {
        turnBloc.add(End(
          isCauseGameOver: false,
        ));
        menuBloc.add(
          ShowMenu(),
        );
      } else {
        // Resume timer when menu closes
        turnBloc.add(TapTimerResume());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Seed TurnBloc when the tutorial (re-)enters a lesson hosted here.
        BlocListener<TutorialCubit, TutorialState>(
          listenWhen: (previous, current) =>
              current.isActive &&
              current.lesson.hostScreen == TutorialHostScreen.playScreen &&
              current.lesson.turnSeed != null &&
              (previous.seedToken != current.seedToken || !previous.isActive),
          listener: (context, state) {
            final seed = state.lesson.turnSeed!;
            turnBloc.add(SeedTutorialTurn(
              difficulty: seed.difficulty,
              requirementString: seed.requirementString,
              expect: seed.expect,
              level: seed.level,
              timesCorrect: seed.timesCorrect,
              lifeRemaining: seed.lifeRemaining,
              tapTimerSeconds: seed.tapTimerSeconds,
              startTimer: seed.startTimer,
              equations: seed.equations,
              correctIndex: seed.correctIndex,
              questionExpression: seed.questionExpression,
              showBeforePlaying: seed.showBeforePlaying,
            ));
          },
        ),
        // Tear the tutorial down once it ends while hosted anywhere in the
        // Play branch — reset the real game state and hand off to TourBloc.
        BlocListener<TutorialCubit, TutorialState>(
          listenWhen: (previous, current) =>
              previous.isActive && !current.isActive,
          listener: (context, state) {
            turnBloc.add(Renew());
            // Backing out into the menu tour: it navigates to its own step.
            if (state.backedOutToMenuTour) return;
            menuBloc.add(ShowMenu());
            context.read<TourBloc>().add(TourCompleted());
          },
        ),
      ],
      child: AnimatedGameWrapper(
        key: _animationKey,
        child: BlocListener<TurnBloc, TurnState>(
          listener: (context, state) {
            _handleAnimationEvents(context, state);
            _handleTutorialProgress(context, state);
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              // Since canPop is false, didPop will always be false
              // Always trigger menu button when back is pressed
              // _handleMenuButton();
            },
            child: Scaffold(
              body: BlocBuilder<TurnBloc, TurnState>(
                builder: (context, turnState) {
                  if (turnState.status == TurnStatus.gameOver) {
                    if (turnState is! GameOverState) {
                      playerNavCubit.showGameover();
                    }
                  }

                  // if (turnState.status == TurnStatus.intro ||
                  //     turnState.status == TurnStatus.initial) {
                  //   if (turnState is! PlayingState) {
                  //     playerNavCubit.showPlay();
                  //   }
                  // }

                  return Stack(
                    children: [
                      Container(
                        decoration: LayoutConfig(context).gradientDecoration,
                        child: Builder(builder: (context) {
                          final isPickRightMode =
                              turnState.difficultyModel?.isPickRightMode ==
                                  true;
                          final headerColumn = Column(
                            children: [
                              CountDownBar(
                                // Spotlighted by the tutorial's timer lessons.
                                key: TourKeys.countdownBarKey,
                                timerDuration: turnState.effectiveTimerDuration,
                                tapTimerRemaining:
                                    turnState.tapTimerRemaining.toInt(),
                                isPlaying:
                                    turnState.status == TurnStatus.playing,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      FaIcon(
                                        Helper.getIconFromDifficulty(
                                            context,
                                            turnState
                                                .difficultyModel?.difficulty),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        size: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .fontSize,
                                      ),
                                      const SizedBox(width: kSpaceS),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${coreLang(context).level}: ",
                                              style:
                                                  AppTextStyles.bodyLargeBold(
                                                      context),
                                            ),
                                            TextSpan(
                                              text:
                                                  turnState.levelAndTimeCorrect,
                                              style: AppTextStyles.bodyLarge(
                                                  context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    key: TourKeys.scoreKey,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.chartLine,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        size: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .fontSize,
                                      ),
                                      const SizedBox(width: kSpaceS),
                                      Text(
                                        "${coreLang(context).score}: ",
                                        style: AppTextStyles.bodyLargeBold(
                                            context),
                                      ),
                                      Text(
                                        "${turnState.point}",
                                        style: AppTextStyles.bodyLarge(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Expanded(
                              //       child: Stack(
                              //         alignment: Alignment.center,
                              //         children: [
                              //           Positioned(
                              //             child: Wrap(
                              //               spacing: 5,
                              //               runSpacing: 5,
                              //               children: List.generate(
                              //                 turnState.lifeRemaining,
                              //                 (index) => Icon(
                              //                   FontAwesomeIcons.solidStar,
                              //                   color: Theme.of(context)
                              //                       .scaffoldBackgroundColor,
                              //                   size: Theme.of(context)
                              //                       .textTheme
                              //                       .bodyLarge!
                              //                       .fontSize,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              BlocListener<TurnBloc, TurnState>(
                                listener: (context, state) {
                                  if (_prevLifeRemaining == null) {
                                    // First time: just sync both values
                                    setState(() {
                                      _prevLifeRemaining = state.lifeRemaining;
                                      _currentLifeRemaining =
                                          state.lifeRemaining;
                                    });
                                    return;
                                  }

                                  if (state.lifeRemaining ==
                                      _prevLifeRemaining) {
                                    return; // No change
                                  }

                                  final increased =
                                      state.lifeRemaining > _prevLifeRemaining!;
                                  final decreased =
                                      state.lifeRemaining < _prevLifeRemaining!;

                                  setState(() {
                                    wasLifeIncreased = increased;
                                    wasLifeDecreased = decreased;
                                    // Store the NEW target value
                                    _prevLifeRemaining = state.lifeRemaining;

                                    if (increased) {
                                      // For increase: show new count immediately so new star appears & scales in
                                      _currentLifeRemaining =
                                          state.lifeRemaining;
                                    }
                                    // For decrease: keep _currentLifeRemaining at OLD value
                                    // so the last star can animate its shrink, then onEnd will update it.
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Wrap(
                                          key: TourKeys.heartKey,
                                          spacing: kLifeStarSpacing,
                                          children: List.generate(
                                            _currentLifeRemaining,
                                            (index) {
                                              final isLast = index ==
                                                  _currentLifeRemaining - 1;

                                              // Life gained: animate the newly added last star scaling in
                                              if (wasLifeIncreased && isLast) {
                                                return TweenAnimationBuilder<
                                                    double>(
                                                  tween: Tween<double>(
                                                      begin: 0.0, end: 1.0),
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.elasticOut,
                                                  onEnd: () {
                                                    if (mounted) {
                                                      setState(() {
                                                        wasLifeIncreased =
                                                            false;
                                                      });
                                                    }
                                                  },
                                                  builder:
                                                      (context, value, child) {
                                                    return Opacity(
                                                      opacity:
                                                          value.clamp(0.0, 1.0),
                                                      child: Transform.scale(
                                                        scale: value,
                                                        child: LifeStar(
                                                          value: value,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }

                                              // Life lost: animate the last star shrinking out
                                              if (wasLifeDecreased && isLast) {
                                                return TweenAnimationBuilder<
                                                    double>(
                                                  tween: Tween<double>(
                                                      begin: 1.0, end: 0.0),
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.easeInBack,
                                                  onEnd: () {
                                                    if (mounted) {
                                                      setState(() {
                                                        wasLifeDecreased =
                                                            false;
                                                        // NOW remove the star from the list
                                                        _currentLifeRemaining =
                                                            _prevLifeRemaining ??
                                                                _currentLifeRemaining;
                                                      });
                                                    }
                                                  },
                                                  builder:
                                                      (context, value, child) {
                                                    return Opacity(
                                                      opacity:
                                                          value.clamp(0.0, 1.0),
                                                      child: Transform.scale(
                                                        scale: value,
                                                        child: LifeStar(
                                                          value: value,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }

                                              return const LifeStar();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (turnState.isShowExpect &&
                                  turnState.difficultyModel?.isPickRightMode !=
                                      true)
                                Expanded(
                                  key: TourKeys.challengeAreaKey,
                                  child: Center(
                                    child: Wrap(
                                      children: List.generate(
                                        turnState.requirementString!.length,
                                        (index) {
                                          String inputted = turnState
                                              .requirementString![index];
                                          return SizedBox(
                                            width: (AppTextStyles.forChallenge(
                                                        turnState
                                                            .requirementString!
                                                            .length,
                                                        context)
                                                    .fontSize! *
                                                0.65),
                                            child: Column(
                                              children: [
                                                Text(
                                                  inputted,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles
                                                      .forChallenge(
                                                    turnState.requirementString!
                                                        .length,
                                                    context,
                                                  ).copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary),
                                                ),
                                                // if (turnState.expect ==
                                                //     turnState.requirementString)
                                                //   Icon(
                                                //     FontAwesomeIcons.minus,
                                                //     color: Theme.of(context)
                                                //         .scaffoldBackgroundColor,
                                                //   ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              if (turnState.isTimeForTyping &&
                                  turnState.difficultyModel?.isPickRightMode !=
                                      true)
                                Expanded(
                                  key: TourKeys.challengeAreaKey,
                                  child: Center(
                                    child: Wrap(
                                      children: List.generate(
                                        turnState.expect!.length,
                                        (index) {
                                          double hide = turnState
                                                      .isTypingNotEmpty &&
                                                  index <
                                                      turnState.typing.length
                                              ? 1
                                              : 0;

                                          String inputted =
                                              turnState.expect![index];

                                          return SizedBox(
                                            width: (AppTextStyles.forChallenge(
                                                        turnState
                                                            .requirementString!
                                                            .length,
                                                        context)
                                                    .fontSize! *
                                                0.65),
                                            child: Builder(
                                              builder: (context) {
                                                // Trigger firework when finished
                                                // Only trigger once per character index
                                                if (turnState.isFinishTarget &&
                                                    hide == 1 &&
                                                    !_triggeredFireworkIndices
                                                        .contains(index)) {
                                                  _triggeredFireworkIndices
                                                      .add(index);
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    final RenderBox? renderBox =
                                                        context.findRenderObject()
                                                            as RenderBox?;
                                                    if (renderBox != null) {
                                                      final position = renderBox
                                                          .localToGlobal(
                                                              Offset.zero);
                                                      final size =
                                                          renderBox.size;
                                                      final center = position +
                                                          Offset(size.width / 2,
                                                              size.height / 2);

                                                      // Delay each firework slightly for cascading effect
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  index * 50),
                                                          () {
                                                        if (mounted &&
                                                            _animationKey
                                                                    .currentState !=
                                                                null) {
                                                          // Per-character cascade: lightning only
                                                          // Full firework fires via _handleAnimationEvents on level-up
                                                          _animationKey
                                                              .currentState!
                                                              .triggers
                                                              .onLightningOnly(
                                                                  center);
                                                        }
                                                      });
                                                    }
                                                  });
                                                } else if (!turnState
                                                    .isFinishTarget) {
                                                  // Reset set when starting a new turn
                                                  _triggeredFireworkIndices
                                                      .clear();
                                                }

                                                return Column(
                                                  children: [
                                                    AnimatedOpacity(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      opacity: hide,
                                                      child: AnimatedOpacity(
                                                        curve:
                                                            Curves.easeOutQuart,
                                                        opacity: turnState
                                                                .isFinishTarget
                                                            ? 0
                                                            : 1,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        child: AnimatedScale(
                                                          curve: Curves
                                                              .easeOutQuart,
                                                          scale: turnState
                                                                  .isFinishTarget
                                                              ? 2
                                                              : 1,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          child: Text(
                                                            inputted,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppTextStyles
                                                                .forChallenge(
                                                              turnState
                                                                  .requirementString!
                                                                  .length,
                                                              context,
                                                            ).copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    AnimatedOpacity(
                                                      opacity:
                                                          (hide == 0) ? 1 : 0,
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.minus,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                              if (turnState.difficultyModel?.isPickRightMode ==
                                  true) ...[
                                Expanded(
                                  key: TourKeys.challengeAreaKey,
                                  child: Center(
                                    child: Text(
                                      turnState.questionExpression ??
                                          lang(context).whichOneIsCorrect,
                                      style: AppTextStyles.titleLarge(context),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          );
                          // Regular mode splits the numeric keypad across
                          // the gamepad clusters
                          // (RegularModeControls.gamepadSide); Pick Right
                          // instead duplicates the *entire* set of answer
                          // buttons on both edges
                          // (PickRightModeControls.gamepadSide) — there's
                          // no natural left/right split of 3 equations the
                          // way there is for a 0-9 keypad.
                          return GameLayoutBody(
                            header: headerColumn,
                            controlsBuilder: (side) => isPickRightMode
                                ? PickRightModeControls(
                                    turnState: turnState,
                                    animationKey: _animationKey,
                                    onMenuPressed: _handleMenuButton,
                                    gamepadSide: side,
                                  )
                                : RegularModeControls(
                                    turnState: turnState,
                                    keyboardArray: keyboardArray,
                                    onMenuPressed: _handleMenuButton,
                                    gamepadSide: side,
                                  ),
                          );
                        }),
                      ),
                      if (turnState.status == TurnStatus.intro)
                        CountdownOverlay(seconds: turnState.countDown),
                      // Fold/unfold, rotation or leaving the app mid-round.
                      if (resumeCountdownOverlay() case final overlay?) overlay,
                      // Quick settings overlay — always accessible, not affected by layout
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(kSpaceS),
                            child: BlocBuilder<SettingBloc, SettingState>(
                              builder: (context, settingState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Volume toggle
                                    QuickSettingButton(
                                      icon: settingState.isMuted
                                          ? FontAwesomeIcons.volumeXmark
                                          : settingState.vol > 7
                                              ? FontAwesomeIcons.volumeHigh
                                              : settingState.vol > 4
                                                  ? FontAwesomeIcons.volumeLow
                                                  : settingState.vol > 0
                                                      ? FontAwesomeIcons
                                                          .volumeOff
                                                      : FontAwesomeIcons
                                                          .volumeXmark,
                                      onTap: () {
                                        context.read<SettingBloc>().add(
                                              ToggleMute(),
                                            );
                                      },
                                      isActive: !settingState.isMuted,
                                    ),
                                    const SizedBox(height: kSpaceXS),
                                    // Vibration toggle
                                    QuickSettingButton(
                                      icon: settingState.isVibrate
                                          ? Icons.vibration_rounded
                                          : FontAwesomeIcons.mobile,
                                      onTap: () {
                                        context.read<SettingBloc>().add(
                                              ChangedIsVibrate(
                                                isVibrate:
                                                    !settingState.isVibrate,
                                              ),
                                            );
                                      },
                                      isActive: settingState.isVibrate,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const TutorialOverlay(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pressReset() async {
    return;
  }

  // Tutorial progress tracking — mirrors the _prev*ForAnimation pattern
  // above; TurnBloc's own BlocListener only exposes the current state, so
  // the previous value is kept on the widget instead.
  TurnState? _prevTurnStateForTutorial;

  void _handleTutorialProgress(BuildContext context, TurnState state) {
    final previous = _prevTurnStateForTutorial;
    _prevTurnStateForTutorial = state;
    if (previous == null) return;

    final tutorialCubit = context.read<TutorialCubit>();
    final tutorial = tutorialCubit.state;
    if (!tutorial.isActive ||
        tutorial.lesson.hostScreen != TutorialHostScreen.playScreen) {
      return;
    }

    switch (tutorial.lesson.key) {
      case 'RegularMemorize':
        if (previous.isShowExpect && !state.isShowExpect) {
          tutorialCubit.onActionResolved();
        }
        break;
      case 'RegularTypeBack':
      case 'PickRightCorrect':
        if (state.point > previous.point) {
          tutorialCubit.onActionResolved();
        }
        break;
      case 'RegularTimer':
      case 'RegularReset':
      case 'PickRightWrong':
      case 'PickRightTimer':
        if (state.lifeRemaining < previous.lifeRemaining) {
          tutorialCubit.onActionResolved();
        }
        break;
      case 'RegularLevelUp':
        if (state.level > previous.level) {
          tutorialCubit.onActionResolved();
        }
        break;
      case 'RegularGameOver':
        if (state.status == TurnStatus.gameOver &&
            previous.status != TurnStatus.gameOver) {
          tutorialCubit.onActionResolved();
        }
        break;
    }
  }

  // Animation event handler
  int? _prevPointForAnimation;
  int? _prevLifeForAnimation;
  int? _prevLevelForAnimation;

  void _handleAnimationEvents(BuildContext context, TurnState state) {
    // Track point changes using same pattern as life changes
    final wasPointIncreased =
        _prevPointForAnimation != null && state.point > _prevPointForAnimation!;

    // Track life changes using same pattern as existing life animation
    final wasLifeIncreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining > _prevLifeForAnimation!;
    final wasLifeDecreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining < _prevLifeForAnimation!;

    // Trigger animation based on what happened:
    if (wasPointIncreased) {
      final scorePosition = _getWidgetPosition(TourKeys.scoreKey);
      // Correct answer only: lightning glow without explosion
      _animationKey.currentState?.triggers.onLightningOnly(scorePosition);
    }

    // Trigger life gain animation
    if (wasLifeIncreasedForAnimation) {
      final heartPosition = _getWidgetPosition(TourKeys.heartKey);
      _animationKey.currentState?.triggers.onGainLife(heartPosition);
    }

    // Trigger life loss animation
    if (wasLifeDecreasedForAnimation) {
      _animationKey.currentState?.triggers.onLostLife(0.8);
    }

    // Update previous values for next comparison
    if (_prevPointForAnimation == null ||
        state.point != _prevPointForAnimation) {
      _prevPointForAnimation = state.point;
    }
    if (_prevLifeForAnimation == null ||
        state.lifeRemaining != _prevLifeForAnimation) {
      _prevLifeForAnimation = state.lifeRemaining;
    }
    if (_prevLevelForAnimation == null ||
        state.level != _prevLevelForAnimation) {
      _prevLevelForAnimation = state.level;
    }
  }

  // Get widget position for particle effects
  Offset _getWidgetPosition(GlobalKey key) {
    try {
      final RenderBox? box =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final position = box.localToGlobal(Offset.zero);
        return position + Offset(box.size.width / 2, box.size.height / 2);
      }
    } catch (e) {
      dev.log('Error getting widget position: $e');
    }
    // Fallback to screen center
    return Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 3,
    );
  }
}

class LifeStar extends StatelessWidget {
  final double value;
  const LifeStar({
    super.key,
    this.value = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Clamped: the gain/loss animations overshoot, and a star whose
      // animation is cut short by another (lives reset mid-animation) can
      // momentarily get a value below 0 — never a negative width.
      width: (Theme.of(context).textTheme.displaySmall!.fontSize ?? 60.0) *
          math.max(0.0, value),
      height: (Theme.of(context).textTheme.displaySmall!.fontSize ?? 60.0),
      child: FaIcon(
        FontAwesomeIcons.solidStar,
        color: Theme.of(context).colorScheme.onPrimary,
        size: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
