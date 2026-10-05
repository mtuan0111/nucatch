import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_tutorial_driver.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/blocs/objects/timer_pause.dart';
import 'package:nucatch/helpers/game_layout.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/widgets/pick_right_buttons.dart';
import 'package:nucatch/widgets/combat_status_badge.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';
import 'package:nucatch/widgets/game_layout_body.dart';
import 'package:nucatch/widgets/game_pause_guard.dart';
import 'package:nucatch/widgets/opponent_paused_overlay.dart';
import 'package:nucatch/widgets/countdown_bar.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/widgets/quick_setting_button.dart';
import 'package:nucatch/widgets/tutorial_overlay.dart';

class CombatPlayScreen extends StatefulWidget {
  const CombatPlayScreen({super.key});

  @override
  State<CombatPlayScreen> createState() => _CombatPlayScreenState();
}

class _CombatPlayScreenState extends State<CombatPlayScreen>
    with GamePauseGuard {
  /// Cached for [GamePauseGuard], which releases its holds from [dispose].
  late final CombatBloc _guardedCombatBloc = context.read<CombatBloc>();

  @override
  bool get isRoundLive =>
      _guardedCombatBloc.state.combatStatus == CombatStatus.playing;

  @override
  void onTimerHold(TimerPauseReason reason) =>
      _guardedCombatBloc.add(CombatTapTimerPause(reason));

  @override
  void onTimerRelease(TimerPauseReason reason) =>
      _guardedCombatBloc.add(CombatTapTimerResume(reason));

  // Both players pause together (plan §4.3): tell the opponent when this
  // device loses the board, and when its 3-2-1 starts so theirs runs too.
  @override
  void onGuardAway() =>
      _guardedCombatBloc.add(CombatLocalPauseChanged(paused: true));

  @override
  void onGuardResuming() =>
      _guardedCombatBloc.add(CombatLocalPauseChanged(paused: false));

  late bool wasLifeIncreased;
  late bool wasLifeDecreased;
  int? _prevLifeRemaining;
  late int _currentLifeRemaining;

  // Animation system
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  // Score/life/opponent keys are shared statics (TourKeys) — see
  // play_screen.dart's identical note; PlayScreen and CombatPlayScreen are
  // never mounted simultaneously.

  CombatTutorialDriver? _tutorialDriver;
  String? _lastPlayedOpponentScriptToken;

  // Track which character indices have triggered fireworks
  final Set<int> _triggeredFireworkIndices = {};

  // Removed: boldedStyleFont - now using AppTextStyles.forChallenge()

  @override
  void initState() {
    super.initState();
    _guardedCombatBloc; // resolve while the element is active

    // Initialize life animation tracking
    final combatBloc = context.read<CombatBloc>();

    _currentLifeRemaining = combatBloc.state.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;

    _tutorialDriver = CombatTutorialDriver(combatBloc: combatBloc);

    // See PlayScreen.initState's identical note — the seed BlocListener
    // only reacts to emissions after it subscribes, which can miss the
    // combat arc's very first lesson.
    final tutorial = context.read<TutorialCubit>().state;
    if (tutorial.isActive &&
        tutorial.lesson.hostScreen == TutorialHostScreen.combatPlayScreen &&
        tutorial.lesson.combatSeed != null) {
      final seed = tutorial.lesson.combatSeed!;
      combatBloc.add(SeedTutorialCombat(
        difficulty: seed.difficulty,
        requirementString: seed.requirementString,
        expect: seed.expect,
        level: seed.level,
        lifeRemaining: seed.lifeRemaining,
        opponentLives: seed.opponentLives,
        opponentScore: seed.opponentScore,
        tapTimerSeconds: seed.tapTimerSeconds,
        startTimer: seed.startTimer,
      ));
    }
  }

  CombatState? _prevCombatStateForTutorial;

  void _handleTutorialProgress(BuildContext context, CombatState state) {
    final previous = _prevCombatStateForTutorial;
    _prevCombatStateForTutorial = state;

    final tutorialCubit = context.read<TutorialCubit>();
    final tutorial = tutorialCubit.state;
    if (!tutorial.isActive ||
        tutorial.lesson.hostScreen != TutorialHostScreen.combatPlayScreen) {
      return;
    }

    final lesson = tutorial.lesson;
    final token = '${tutorial.lessonIndex}-${tutorial.seedToken}';
    if (lesson.opponentScript != null &&
        _lastPlayedOpponentScriptToken != token) {
      _lastPlayedOpponentScriptToken = token;
      // No `mounted` guard: a script that ends in a real win (e.g. C7)
      // causes CombatPlayScreen itself to unmount — navigated away to
      // CombatGameEndScreen — before this completes. TutorialCubit is a
      // long-lived, screen-independent provider; it doesn't need this
      // widget to still be mounted to be told the lesson resolved.
      _tutorialDriver?.play(lesson.opponentScript!).then((_) {
        tutorialCubit.onActionResolved();
      });
      return;
    }

    if (previous == null) return;

    switch (lesson.key) {
      case 'CombatYourTurn':
        if (state.point > previous.point) {
          tutorialCubit.onActionResolved();
        }
        break;
    }
  }

  bool _isMenuShowing = false;

  void _handleMenuButton(BuildContext context) {
    // If menu is already showing, do nothing
    if (_isMenuShowing) return;

    // Mid-tutorial, the menu button just ends the tutorial — there's no
    // real match to confirm giving up on.
    if (context.read<CombatBloc>().state.isTutorial) {
      context.read<TutorialCubit>().finish();
      return;
    }

    // Mark menu as showing
    _isMenuShowing = true;

    // Show confirmation dialog
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertTemplate(
        title: coreLang(dialogContext).mainMenu,
        message: lang(dialogContext).confirmEndCombat,
        possitiveButtonLabel: coreLang(dialogContext).yes,
        onPossitiveButtonPressed: () => Navigator.of(dialogContext).pop(true),
        negativeButtonLabel: coreLang(dialogContext).no,
        onNegativeButtonPressed: () => Navigator.of(dialogContext).pop(false),
      ),
    ).then((confirmed) {
      // Mark menu as no longer showing
      _isMenuShowing = false;

      if (confirmed == true) {
        // End game with opponent winning (I gave up)
        context.read<CombatBloc>().add(
              CombatGameEnded(
                isWinner: false,
                reason:
                    GameEndReason.myLivesOut, // Giving up is treated as losing
                sendMessage: true,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final combatBloc = context.read<CombatBloc>();
    return MultiBlocListener(
      listeners: [
        // Seed CombatBloc when the tutorial (re-)enters a lesson hosted here.
        BlocListener<TutorialCubit, TutorialState>(
          listenWhen: (previous, current) =>
              current.isActive &&
              current.lesson.hostScreen ==
                  TutorialHostScreen.combatPlayScreen &&
              current.lesson.combatSeed != null &&
              (previous.seedToken != current.seedToken || !previous.isActive),
          listener: (context, state) {
            final seed = state.lesson.combatSeed!;
            combatBloc.add(SeedTutorialCombat(
              difficulty: seed.difficulty,
              requirementString: seed.requirementString,
              expect: seed.expect,
              level: seed.level,
              lifeRemaining: seed.lifeRemaining,
              opponentLives: seed.opponentLives,
              opponentScore: seed.opponentScore,
              tapTimerSeconds: seed.tapTimerSeconds,
              startTimer: seed.startTimer,
            ));
          },
        ),
        // Teardown (once the tutorial ends) is handled by CombatNav instead
        // of here — CombatWrapUp is hosted on CombatGameEndScreen, a
        // sibling screen this widget won't be mounted alongside, so a
        // listener scoped to this screen alone would miss it.
      ],
      child: AnimatedGameWrapper(
        key: _animationKey,
        child: BlocListener<CombatBloc, CombatState>(
          listener: (context, state) {
            _handleAnimationEvents(context, state);
            _handleTutorialProgress(context, state);
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              // Since canPop is false, didPop will always be false
              // Always trigger menu button when back is pressed
              // _handleMenuButton(context);
            },
            child: BlocListener<CombatBloc, CombatState>(
              listenWhen: (previous, current) {
                // Navigate to end game screen when game ends
                // Check both hasGameEnded transition and combatStatus to handle restarts
                final gameJustEnded =
                    !previous.hasGameEnded && current.hasGameEnded;
                final statusChangedToEnded =
                    previous.combatStatus != CombatStatus.ended &&
                        current.combatStatus == CombatStatus.ended;
                return gameJustEnded || statusChangedToEnded;
              },
              listener: (context, state) {
                if (state.hasGameEnded) {
                  context.read<CombatNavCubit>().showEndGame();
                }
              },
              child: Scaffold(
                body: BlocBuilder<CombatBloc, CombatState>(
                  buildWhen: (previous, current) {
                    // Always rebuild to ensure UI updates
                    return true;
                  },
                  builder: (context, combatState) {
                    return Stack(
                      children: [
                        Container(
                          decoration: LayoutConfig(context).gradientDecoration,
                          child: Builder(builder: (context) {
                            // Check if Pick Right mode
                            final isPickRightMode =
                                combatState.difficultyModel?.difficulty ==
                                    Difficulty.pickRight;

                            final headerColumn = Column(
                              children: [
                                // Tap timer countdown bar
                                _buildCountDownBar(combatState),

                                // Combat header with scores and turn indicator
                                _buildCombatHeader(combatState),

                                // Life display with animation
                                _buildLifeDisplay(combatState),

                                // Game area - shows challenge or typing
                                Expanded(
                                  child: _buildGameArea(combatState),
                                ),
                              ],
                            );

                            // Regular mode splits the numeric keypad
                            // across the gamepad clusters
                            // (_buildKeyboard's `side`); Pick Right
                            // instead duplicates the *entire* set of
                            // answer buttons on both edges
                            // (_buildPickRightGamepadCluster) — there's
                            // no natural left/right split of 3 equations
                            // the way there is for a 0-9 keypad.
                            return GameLayoutBody(
                              header: headerColumn,
                              headerFlex: 2,
                              controlsFlex: isPickRightMode ? 3 : 2,
                              controlsBuilder: (side) => switch (side) {
                                null => isPickRightMode
                                    ? _buildPickRightControls(combatState)
                                    : _buildKeyboard(combatState),
                                final side => isPickRightMode
                                    ? _buildPickRightGamepadCluster(
                                        combatState, side)
                                    : _buildKeyboard(combatState, side: side),
                              },
                            );
                          }),
                        ),
                        // Full-screen countdown overlay (blur + centered)
                        _buildCountDown(combatState),
                        // Opponent folded/closed their phone mid-round.
                        if (combatState.opponentPause == OpponentPause.away ||
                            combatState.opponentPause ==
                                OpponentPause.awayTooLong)
                          OpponentPausedOverlay(
                            canClaimWin: combatState.opponentPause ==
                                OpponentPause.awayTooLong,
                            onClaimWin: () => context
                                .read<CombatBloc>()
                                .add(CombatClaimWinAfterAway()),
                          ),
                        // ...and is back: the same 3-2-1 they're seeing.
                        if (combatState.opponentPause == OpponentPause.resuming)
                          CountdownOverlay(
                            key: const ValueKey('opponent-resume'),
                            seconds: GamePauseGuard.resumeCountdownSeconds,
                            onFinished: () => context
                                .read<CombatBloc>()
                                .add(CombatOpponentResumeFinished()),
                          ),
                        // This player folded/left mid-round.
                        if (resumeCountdownOverlay() case final overlay?)
                          overlay,
                        // Quick settings overlay — always accessible
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
      ),
    );
  }

  Widget _buildCountDownBar(CombatState combatState) {
    // Calculate effective timer duration based on difficulty
    final isPickRight =
        combatState.difficultyModel?.difficulty == Difficulty.pickRight;
    final effectiveDuration = isPickRight
        ? kCombatPickRightTimerPerTurn.toDouble()
        : tapTimerDuration;

    return CountDownBar(
      key: TourKeys.countdownBarKey,
      timerDuration: effectiveDuration,
      tapTimerRemaining: combatState.tapTimerRemaining.toInt(),
      isPlaying: combatState.combatStatus == CombatStatus.playing,
    );
  }

  Widget _buildCombatHeader(CombatState combatState) {
    return Padding(
      key: TourKeys.combatHeaderKey,
      padding: const EdgeInsets.symmetric(
          horizontal: kPaddingL, vertical: kPaddingSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FaIcon(
                      Helper.getIconFromDifficulty(
                          context, combatState.difficultyModel?.difficulty),
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: kSpaceS),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${coreLang(context).level}: ",
                            style: AppTextStyles.bodyLargeBold(context),
                          ),
                          TextSpan(
                            text:
                                "${combatState.levelAndTimeCorrect} / ${combatState.difficultyModel?.numberTurnEachLevel}",
                            style: AppTextStyles.bodyLarge(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  key: TourKeys.scoreKey,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.chartLine,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: kSpaceS),
                    Text(
                      "${coreLang(context).score}: ",
                      style: AppTextStyles.bodyLargeBold(context),
                    ),
                    Text(
                      "${combatState.point}",
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceS),
                Opacity(
                  opacity:
                      combatState.combatStatus != CombatStatus.intro ? 1 : 0,
                  child: CombatStatusBadge(
                    key: TourKeys.combatStatusBadgeKey,
                    text: combatState.isMyTurn
                        ? lang(context).yourTurn
                        : lang(context).opponentTurn,
                    isPositive: combatState.isMyTurn,
                    icon: combatState.isMyTurn
                        ? FontAwesomeIcons.trophy
                        : FontAwesomeIcons.hourglass,
                  ),
                ),
              ],
            ),
          ),

          // Opponent info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lang(context).opponent,
                  style: AppTextStyles.bodyLargeBold(context),
                ),
                const SizedBox(height: kSpaceS),
                Wrap(
                  key: TourKeys.opponentScoreKey,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "${coreLang(context).score}: ",
                      style: AppTextStyles.bodyLargeBold(context),
                    ),
                    Text(
                      "${combatState.opponentScore}",
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceS),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: combatState.opponentJustLostLife
                        ? Colors.red.withValues(alpha: 0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(kBorderRadiusL),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        combatState.opponentJustLostLife ? kPaddingS : 0,
                    vertical: combatState.opponentJustLostLife ? kPaddingSM : 0,
                  ),
                  child: Wrap(
                    key: TourKeys.opponentHeartKey, // Add key for animation
                    spacing: kLifeStarSpacing,
                    children: List.generate(
                      combatState.opponentLives,
                      (index) => SizedBox(
                        width:
                            (Theme.of(context).textTheme.titleLarge!.fontSize ??
                                20.0),
                        height:
                            (Theme.of(context).textTheme.titleLarge!.fontSize ??
                                20.0),
                        child: FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifeDisplay(CombatState combatState) {
    return BlocListener<CombatBloc, CombatState>(
      listener: (context, state) {
        if (_prevLifeRemaining == null) {
          // First time: just sync both values
          setState(() {
            _prevLifeRemaining = state.lifeRemaining;
            _currentLifeRemaining = state.lifeRemaining;
          });
          return;
        }

        if (state.lifeRemaining == _prevLifeRemaining) {
          return; // No change
        }

        final increased = state.lifeRemaining > _prevLifeRemaining!;
        final decreased = state.lifeRemaining < _prevLifeRemaining!;

        setState(() {
          wasLifeIncreased = increased;
          wasLifeDecreased = decreased;
          // Store the NEW target value
          _prevLifeRemaining = state.lifeRemaining;

          if (increased) {
            // For increase: show new count immediately so new star appears & scales in
            _currentLifeRemaining = state.lifeRemaining;
          }
          // For decrease: keep _currentLifeRemaining at OLD value
          // so the last star can animate its shrink, then onEnd will update it.
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Wrap(
                key: TourKeys.heartKey,
                spacing: kLifeStarSpacing,
                children: List.generate(
                  _currentLifeRemaining,
                  (index) {
                    final isLast = index == _currentLifeRemaining - 1;

                    // Life gained: animate the newly added last star scaling in
                    if (wasLifeIncreased && isLast) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.elasticOut,
                        onEnd: () {
                          if (mounted) {
                            setState(() {
                              wasLifeIncreased = false;
                            });
                          }
                        },
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: value,
                              child: LifeStar(value: value),
                            ),
                          );
                        },
                      );
                    }

                    // Life lost: animate the last star shrinking out
                    if (wasLifeDecreased && isLast) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: 0.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInBack,
                        onEnd: () {
                          if (mounted) {
                            setState(() {
                              wasLifeDecreased = false;
                              // NOW remove the star from the list
                              _currentLifeRemaining =
                                  _prevLifeRemaining ?? _currentLifeRemaining;
                            });
                          }
                        },
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: value,
                              child: LifeStar(value: value),
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
    );
  }

  Widget _buildGameArea(CombatState combatState) {
    if (combatState.combatStatus == CombatStatus.intro) {
      return const SizedBox.shrink();
    }
    // Show requirement string (what to memorize/solve)
    // Skip for Pick Right mode - it shows equations in the button area instead
    final isPickRightMode =
        combatState.difficultyModel?.difficulty == Difficulty.pickRight;

    if (!isPickRightMode) {
      if (combatState.isShowExpect) {
        return Center(
          child: Wrap(
            children: List.generate(
              combatState.requirementString!.length,
              (index) {
                String char = combatState.requirementString![index];
                return SizedBox(
                  width: (AppTextStyles.forChallenge(
                              combatState.requirementString!.length, context)
                          .fontSize! *
                      0.65),
                  child: Column(
                    children: [
                      Text(
                        char,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.forChallenge(
                          combatState.requirementString!.length,
                          context,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }

      // Show typing area with animations (user input) - ONLY when it's my turn
      // Skip for Pick Right mode - it uses button taps instead of typing
      if (combatState.isMyTurn && combatState.isTimeForTyping) {
        return Center(
          child: Wrap(
            children: List.generate(
              combatState.expect!.length,
              (index) {
                double hide = combatState.isTypingNotEmpty &&
                        index < combatState.typing.length
                    ? 1
                    : 0;

                String inputted = combatState.expect![index];

                dev.log("inputted: $inputted");
                dev.log("hide: $hide");
                dev.log("index: $index");
                dev.log(
                    "combatState.expect!.length: ${combatState.expect!.length}");
                dev.log("combatState.typing: ${combatState.typing}");

                return SizedBox(
                  width: (AppTextStyles.forChallenge(
                              combatState.requirementString!.length, context)
                          .fontSize! *
                      0.65),
                  child: Builder(
                    builder: (context) {
                      // Trigger firework animation at character position when finished
                      // Only trigger once per character index
                      if (combatState.isFinishTarget &&
                          hide == 1 &&
                          !_triggeredFireworkIndices.contains(index)) {
                        _triggeredFireworkIndices.add(index);
                        dev.log(
                            "Trigger firework animation at character position when finished - index: $index");
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final RenderBox? renderBox =
                              context.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            final position =
                                renderBox.localToGlobal(Offset.zero);
                            final size = renderBox.size;
                            final center = position +
                                Offset(size.width / 2, size.height / 2);

                            // Trigger firework with cascading delay
                            Future.delayed(Duration(milliseconds: index * 50),
                                () {
                              if (mounted &&
                                  _animationKey.currentState != null) {
                                dev.log("firework at index $index");
                                // Per-character cascade: lightning only
                                // Full firework fires via _handleAnimationEvents on level-up
                                _animationKey.currentState!.triggers
                                    .onLightningOnly(center);
                              }
                            });
                          }
                        });
                      } else if (!combatState.isFinishTarget) {
                        // Reset set when starting a new turn
                        _triggeredFireworkIndices.clear();
                      }

                      return Column(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: hide,
                            child: AnimatedOpacity(
                              curve: Curves.easeOutQuart,
                              opacity: combatState.isFinishTarget ? 0 : 1,
                              duration: const Duration(milliseconds: 400),
                              child: AnimatedScale(
                                curve: Curves.easeOutQuart,
                                scale: combatState.isFinishTarget ? 2 : 1,
                                duration: const Duration(milliseconds: 400),
                                child: Text(
                                  inputted,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.forChallenge(
                                    combatState.requirementString!.length,
                                    context,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: (hide == 0) ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Theme.of(context).colorScheme.onPrimary,
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
        );
      }

      // Waiting/watching opponent - show mirror view
      if (combatState.isOpponentActive && !combatState.isMyTurn) {
        // Show the opponent's challenge and progress as a mirror
        if (combatState.requirementString != null &&
            combatState.expect != null) {
          return Center(
            child: Wrap(
              children: List.generate(
                combatState.expect!.length,
                (index) {
                  double hide = combatState.opponentInput != null &&
                          index < combatState.opponentInput!.length
                      ? 1
                      : 0;

                  String inputted = combatState.expect![index];

                  return SizedBox(
                    width: (AppTextStyles.forChallenge(
                                combatState.requirementString!.length, context)
                            .fontSize! *
                        0.65),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: hide * 0.6, // Dimmed
                          child: Text(
                            inputted,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.forChallenge(
                              combatState.requirementString!.length,
                              context,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: (hide == 0) ? 0.6 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: FaIcon(
                            FontAwesomeIcons.minus,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }

        // Fallback if no challenge data
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: kSpaceXL),
              Text(
                lang(context).watchingOpponent,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: Colors.orange,
                  fontSize: kFontSizeXL,
                ),
              ),
            ],
          ),
        );
      }

      // // Waiting for opponent to finish their move
      // if (combatState.isWaitingForOpponent) {
      //   return Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         CircularProgressIndicator(
      //           color: Theme.of(context).colorScheme.onSurface,
      //         ),
      //         const SizedBox(height: kSpaceXL),
      //         Text(
      //           lang(context).waitingForOpponent,
      //           style: AppTextStyles.bodyLarge(context).copyWith(
      //             color: Colors.yellow,
      //             fontSize: kFontSizeXL,
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    } else {
      return Center(
        child: Text(
          combatState.questionExpression ?? lang(context).whichOneIsCorrect,
          style: AppTextStyles.titleLarge(context),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCountDown(CombatState combatState) {
    // Show countdown intro animation
    if (combatState.combatStatus == CombatStatus.intro) {
      return CountdownOverlay(
        seconds: combatState.countDown,
        bottomChildren: [
          // Show turn order notice if available
          if (combatState.willStartFirst != null) ...[
            const SizedBox(height: kSpaceL),
            CombatStatusBadge(
              text: combatState.willStartFirst!
                  ? lang(context).youWillTakeFirst
                  : lang(context).opponentWillTakeFirst,
              isPositive: combatState.willStartFirst!,
              icon: combatState.willStartFirst!
                  ? FontAwesomeIcons.trophy
                  : FontAwesomeIcons.hourglass,
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static const int _keypadColumns = 3;
  static const int _keypadRows = 4;

  /// Builds the button for one keypad entry. [applyTourKey] is false for a
  /// gamepad-cluster's duplicate copy of a middle-column button — a
  /// `GlobalKey` (`TourKeys.keypadKeys[...]`) can only back one mounted
  /// widget at a time, so only one on-screen copy of each button may carry
  /// it.
  Widget _buildKeypadButton(
    BuildContext context,
    CombatState combatState,
    MapEntry<KeyboardOption, int> e, {
    required bool applyTourKey,
    required double keyExtent,
  }) {
    final key = applyTourKey ? TourKeys.keypadKeys[e.key] : null;
    final padding = keypadKeyPadding(keyExtent);
    const duration = Duration(milliseconds: 200);

    if (e.key == KeyboardOption.reset) {
      return AnimatedButton(
        context,
        key: key,
        padding: padding,
        iconData: FontAwesomeIcons.arrowsRotate,
        isEnable: combatState.isAbleToReset && combatState.isAbleToTap,
        onPressed: () {
          context.read<CombatBloc>().add(
                CombatNumberReset(duration: duration),
              );
        },
        backgroundBuilder: (context, borderRadius) {
          return LightningWidget(
              baseColor: Theme.of(context).primaryColor,
              seed: 'Reset'.hashCode,
              borderRadius: borderRadius);
        },
      );
    }
    if (e.key == KeyboardOption.mainMenu) {
      return AnimatedButton(
        context,
        key: key,
        padding: padding,
        iconData: FontAwesomeIcons.bars,
        onPressed: () => _handleMenuButton(context),
        backgroundBuilder: (context, borderRadius) {
          return LightningWidget(
              baseColor: Theme.of(context).primaryColor,
              seed: 'Menu'.hashCode,
              borderRadius: borderRadius);
        },
      );
    }
    return AnimatedButton(
      context,
      key: key,
      padding: padding,
      text: e.value.toString(),
      style: AppTextStyles.displaySmallBold(context),
      isEnable: combatState.isAbleToTap,
      onPressed: () {
        context.read<CombatBloc>().add(
              CombatTap(keyValue: e.key),
            );
      },
      backgroundBuilder: (context, borderRadius) {
        return LightningWidget(
            baseColor: Theme.of(context).primaryColor,
            seed: e.value.toString().hashCode,
            borderRadius: borderRadius);
      },
    );
  }

  /// Full 3x4 keypad grid (default), or — when [side] is given — just that
  /// half of a gamepad-style split layout used on tablet landscape (see
  /// `_buildCombatBody`'s `isTabletLandscape` branch), where two clusters
  /// sit at the screen's outer edges with the game area centered between
  /// them. The middle logical column (digits 2/5/8/0) is duplicated across
  /// both halves so either thumb can reach any digit.
  Widget _buildKeyboard(CombatState combatState, {GamepadKeypadSide? side}) {
    final keys = keyboardArray.entries.toList();

    if (side != null) {
      final columns = side == GamepadKeypadSide.left ? [0, 1] : [1, 2];
      final ownsMiddleColumnKey = side == GamepadKeypadSide.right;
      return LayoutBuilder(builder: (context, constraints) {
        final rawWidth = constraints.maxWidth / columns.length;
        final rawHeight = constraints.maxHeight / _keypadRows;
        final spacing = keypadSpacing(min(rawWidth, rawHeight));
        final cellSize =
            min(rawWidth, rawHeight).clamp(0.0, kMaxKeypadButtonSize + spacing);
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int r = 0; r < _keypadRows; r++)
                Row(
                  // Row fills the cluster's full given width (default
                  // MainAxisSize.max) so spaceEvenly has room to
                  // distribute gaps — mirrors the full-grid path below.
                  // Cell size is cellSize *minus* spacing (not padding
                  // added on top of it), same as the full grid: adding
                  // padding around an already-clamped cell would push the
                  // row's natural width past what the cluster's tight
                  // parent width allows.
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final c in columns)
                      if (r * _keypadColumns + c < keys.length)
                        SizedBox(
                          width: cellSize - spacing,
                          height: cellSize - spacing,
                          child: _buildKeypadButton(
                            context,
                            combatState,
                            keys[r * _keypadColumns + c],
                            applyTourKey: c != 1 || ownsMiddleColumnKey,
                            keyExtent: cellSize - spacing,
                          ),
                        ),
                  ],
                ),
            ],
          ),
        );
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rawWidth = constraints.maxWidth / _keypadColumns;
        final rawHeight = constraints.maxHeight / _keypadRows;
        // Clamp so keypad cells stay roughly square instead of stretching
        // into elongated rectangles — on tablets, where height (an uncapped
        // window-height fraction) can far exceed width (capped by
        // DeviceWrapper), and on any window whose cells would be badly
        // out of proportion (a wide, short tabletop pane). Phones are
        // left untouched — see keypadClampsCells.
        final bool clampCells = keypadClampsCells(context, rawWidth, rawHeight);
        final rawExtent = min(rawWidth, rawHeight);
        final spacing = clampCells
            ? clampedKeypadSpacing(rawExtent)
            : keypadSpacing(rawExtent);
        final double cellSize =
            min(rawWidth, rawHeight).clamp(0.0, kMaxKeypadButtonSize + spacing);
        // Clamped cells may still widen up to kKeypadMaxCellAspect — see
        // RegularModeControls.
        final buttonWidth = clampCells
            ? min(rawWidth, cellSize * kKeypadMaxCellAspect)
            : rawWidth;
        final buttonHeight = clampCells ? cellSize : rawHeight;
        final keyExtent = min(buttonWidth, buttonHeight) - spacing;

        List<Widget> columnChildren = [];
        for (int r = 0; r < _keypadRows; r++) {
          List<Widget> rowChildren = [];
          for (int c = 0; c < _keypadColumns; c++) {
            int idx = r * _keypadColumns + c;
            Widget cell;
            if (idx < keys.length) {
              cell = SizedBox(
                width: buttonWidth - spacing,
                height: buttonHeight - spacing,
                child: _buildKeypadButton(context, combatState, keys[idx],
                    applyTourKey: true, keyExtent: keyExtent),
              );
            } else {
              cell = SizedBox(
                width: buttonWidth - spacing,
                height: buttonHeight - spacing,
              );
            }

            rowChildren.add(cell);
          }

          columnChildren.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowChildren,
            ),
          );
        }

        final grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: clampCells ? MainAxisSize.min : MainAxisSize.max,
          children: columnChildren,
        );
        // Clamped cells no longer fill the available region — center them.
        // Unclamped (mobile) stays exactly as before: unwrapped, filling
        // the full parent via spaceEvenly.
        return clampCells ? Center(child: grid) : grid;
      },
    );
  }

  void _onPickRightEquationTap(
      CombatState combatState, int buttonIndex, Offset? position) {
    context.read<CombatBloc>().add(
          CombatPickRightButtonTap(buttonIndex: buttonIndex),
        );

    // Trigger animations simultaneously if correct
    if (buttonIndex == combatState.correctIndex && position != null) {
      // Lightning only at the correct button position
      // (full firework fires via _handleAnimationEvents on level-up)
      _animationKey.currentState?.triggers.onLightningOnly(position);
      // Life gain animation
      final heartPosition = _getWidgetPosition(TourKeys.heartKey);
      _animationKey.currentState?.triggers.onGainLife(heartPosition);
    }
  }

  /// Build Pick Right controls for Combat mode
  /// Reuses PickRightButtons widget for consistency with Solo mode
  Widget _buildPickRightControls(CombatState combatState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceL),
      child: Column(
        children: [
          // Three equation buttons (same widget as Solo mode)
          Expanded(
            child: PickRightButtons(
              key: ValueKey(combatState.equations?.join(',')),
              buttonKeys: TourKeys.pickRightButtonKeys,
              equations: combatState.equations ?? [],
              selectedOption: combatState.selectedOption,
              isEnabled: combatState.isAbleToTap &&
                  combatState.isMyTurn &&
                  combatState.tapTimerRemaining > 0,
              isCorrectAnimating: combatState.pickRightJustCorrect,
              showCorrectAnswer: combatState.pickRightShowCorrect,
              correctIndex: combatState.correctIndex,
              onButtonTap: (buttonIndex, position) =>
                  _onPickRightEquationTap(combatState, buttonIndex, position),
            ),
          ),
          // Menu button row
          Padding(
            padding: const EdgeInsets.only(top: kSpaceM, bottom: kSpaceS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.bars,
                  onPressed: () => _handleMenuButton(context),
                  backgroundBuilder: (context, borderRadius) {
                    return LightningWidget(
                        baseColor: Theme.of(context).primaryColor,
                        seed: 'Menu'.hashCode,
                        borderRadius: borderRadius);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Gamepad-split counterpart to [_buildPickRightControls] — mirrors
  /// [_buildKeyboard]'s `side` parameter. Combat's Pick Right mode has no
  /// Reset concept (only `CombatPickRightButtonTap`), so unlike the numeric
  /// keypad split there's just one control button, Main Menu, placed on the
  /// right; the *entire* set of answer buttons is duplicated on both edges
  /// (there's no natural left/right split of 3 equations the way there is
  /// for a 0-9 keypad) — only the right copy owns the tutorial-spotlight
  /// `TourKeys.pickRightButtonKeys` (a `GlobalKey` can only back one
  /// mounted widget at a time).
  Widget _buildPickRightGamepadCluster(
      CombatState combatState, GamepadKeypadSide side) {
    final isRight = side == GamepadKeypadSide.right;

    final equationButtons = Expanded(
      child: PickRightButtons(
        key: ValueKey('${side.name}-${combatState.equations?.join(',')}'),
        buttonKeys: isRight ? TourKeys.pickRightButtonKeys : null,
        equations: combatState.equations ?? [],
        selectedOption: combatState.selectedOption,
        isEnabled: combatState.isAbleToTap &&
            combatState.isMyTurn &&
            combatState.tapTimerRemaining > 0,
        isCorrectAnimating: combatState.pickRightJustCorrect,
        showCorrectAnswer: combatState.pickRightShowCorrect,
        correctIndex: combatState.correctIndex,
        onButtonTap: (buttonIndex, position) =>
            _onPickRightEquationTap(combatState, buttonIndex, position),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceM),
      child: Column(
        children: [
          equationButtons,
          if (isRight) ...[
            const SizedBox(height: kSpaceM),
            AnimatedButton(
              context,
              iconData: FontAwesomeIcons.bars,
              onPressed: () => _handleMenuButton(context),
              backgroundBuilder: (context, borderRadius) {
                return LightningWidget(
                    baseColor: Theme.of(context).primaryColor,
                    seed: 'Menu'.hashCode,
                    borderRadius: borderRadius);
              },
            ),
          ],
        ],
      ),
    );
  }

  // Animation event handler
  int? _prevPointForAnimation;
  int? _prevLifeForAnimation;
  int? _prevOpponentScoreForAnimation;
  int? _prevLevelForAnimation;

  void _handleAnimationEvents(BuildContext context, CombatState state) {
    // Track point changes
    final wasPointIncreased =
        _prevPointForAnimation != null && state.point > _prevPointForAnimation!;

    // Track life changes
    final wasLifeIncreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining > _prevLifeForAnimation!;
    final wasLifeDecreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining < _prevLifeForAnimation!;

    // Track opponent score changes

    // Trigger my score animation based on whether it's a level-up or just a correct answer
    if (wasPointIncreased) {
      final scorePosition = _getWidgetPosition(TourKeys.scoreKey);
      // Correct answer only: lightning glow without explosion
      _animationKey.currentState?.triggers.onLightningOnly(scorePosition);
    }

    // Trigger opponent score animation (lightning only; opponent does not trigger level-up locally)
    if (state.opponentJustSucceeded) {
      final opponentScorePosition =
          _getWidgetPosition(TourKeys.opponentScoreKey);
      _animationKey.currentState?.triggers
          .onLightningOnly(opponentScorePosition);
    }

    // Trigger life gain animation
    // Skip for Pick Right mode - already triggered simultaneously in onButtonTap
    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;
    if (wasLifeIncreasedForAnimation && !isPickRight) {
      final heartPosition = _getWidgetPosition(TourKeys.heartKey);
      _animationKey.currentState?.triggers.onGainLife(heartPosition);
    }

    // Trigger life loss animation
    if (wasLifeDecreasedForAnimation) {
      _animationKey.currentState?.triggers.onLostLife(0.8);
    }

    // Update previous values
    if (_prevPointForAnimation == null ||
        state.point != _prevPointForAnimation) {
      _prevPointForAnimation = state.point;
    }
    if (_prevLifeForAnimation == null ||
        state.lifeRemaining != _prevLifeForAnimation) {
      _prevLifeForAnimation = state.lifeRemaining;
    }
    if (_prevOpponentScoreForAnimation == null ||
        state.opponentScore != _prevOpponentScoreForAnimation) {
      _prevOpponentScoreForAnimation = state.opponentScore;
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
      width:
          (Theme.of(context).textTheme.displaySmall!.fontSize ?? 60.0) * value,
      height: (Theme.of(context).textTheme.displaySmall!.fontSize ?? 60.0),
      child: FaIcon(
        FontAwesomeIcons.solidStar,
        color: Theme.of(context).colorScheme.onPrimary,
        size: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
