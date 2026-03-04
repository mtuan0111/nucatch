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
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/widgets/pick_right_buttons.dart';
import 'package:nucatch/widgets/combat_status_badge.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';
import 'package:nucatch/widgets/countdown_bar.dart';

class CombatPlayScreen extends StatefulWidget {
  const CombatPlayScreen({super.key});

  @override
  State<CombatPlayScreen> createState() => _CombatPlayScreenState();
}

class _CombatPlayScreenState extends State<CombatPlayScreen> {
  double get screenWidth =>
      max(MediaQuery.of(context).size.width, kMinScreenWidth);

  late bool wasLifeIncreased;
  late bool wasLifeDecreased;
  int? _prevLifeRemaining;
  late int _currentLifeRemaining;

  // Animation system
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  final GlobalKey _scoreKey = GlobalKey();
  final GlobalKey _heartKey = GlobalKey();
  final GlobalKey _opponentScoreKey = GlobalKey();
  final GlobalKey _opponentHeartKey =
      GlobalKey(); // For opponent life blink animation

  // Track which character indices have triggered fireworks
  final Set<int> _triggeredFireworkIndices = {};

  // Removed: boldedStyleFont - now using AppTextStyles.forChallenge()

  @override
  void initState() {
    super.initState();

    // Initialize life animation tracking
    final combatBloc = context.read<CombatBloc>();

    _currentLifeRemaining = combatBloc.state.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;
  }

  bool _isMenuShowing = false;

  void _handleMenuButton(BuildContext context) {
    // If menu is already showing, do nothing
    if (_isMenuShowing) return;

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
    return AnimatedGameWrapper(
      key: _animationKey,
      child: BlocListener<CombatBloc, CombatState>(
        listener: _handleAnimationEvents,
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
                        child: SafeArea(
                          child: DeviceWrapper(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
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
                                  ),
                                ),

                                // Keyboard
                                Builder(builder: (context) {
                                  // Check if Pick Right mode
                                  final isPickRightMode =
                                      combatState.difficultyModel?.difficulty ==
                                          Difficulty.pickRight;

                                  if (isPickRightMode
                                      //  &&
                                      //     !combatState.opponentJustSucceeded
                                      ) {
                                    return Expanded(
                                        flex: 3,
                                        child: _buildPickRightControls(
                                            combatState));
                                  }
                                  return Expanded(
                                      flex: 2,
                                      child: _buildKeyboard(combatState));
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Full-screen countdown overlay (blur + centered)
                      _buildCountDown(combatState),
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

  Widget _buildCountDownBar(CombatState combatState) {
    // Calculate effective timer duration based on difficulty
    final isPickRight =
        combatState.difficultyModel?.difficulty == Difficulty.pickRight;
    final effectiveDuration = isPickRight
        ? kCombatPickRightTimerPerTurn.toDouble()
        : tapTimerDuration;

    return CountDownBar(
      timerDuration: effectiveDuration,
      tapTimerRemaining: combatState.tapTimerRemaining.toInt(),
      isPlaying: combatState.combatStatus == CombatStatus.playing,
    );
  }

  Widget _buildCombatHeader(CombatState combatState) {
    return Padding(
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
                    Icon(
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
                            text: combatState.levelAndTimeCorrect,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  key: _scoreKey,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
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
                    text: combatState.isMyTurn
                        ? lang(context).yourTurn
                        : lang(context).opponentTurn,
                    isPositive: combatState.isMyTurn,
                    icon: combatState.isMyTurn
                        ? Icons.emoji_events
                        : Icons.hourglass_bottom,
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
                  key: _opponentScoreKey,
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
                        ? Colors.red.withOpacity(0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(kBorderRadiusL),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        combatState.opponentJustLostLife ? kPaddingS : 0,
                    vertical: combatState.opponentJustLostLife ? kPaddingSM : 0,
                  ),
                  child: Wrap(
                    key: _opponentHeartKey, // Add key for animation
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
                        child: Icon(
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
        // Update life animation tracking
        wasLifeIncreased = _prevLifeRemaining != null &&
            state.lifeRemaining > _prevLifeRemaining!;
        wasLifeDecreased = _prevLifeRemaining != null &&
            state.lifeRemaining < _prevLifeRemaining!;
        if (_prevLifeRemaining == null ||
            state.lifeRemaining != _prevLifeRemaining) {
          setState(() {
            _prevLifeRemaining = state.lifeRemaining;
          });

          // Update current life remaining for both increases and decreases
          if (wasLifeIncreased || wasLifeDecreased) {
            setState(() {
              _currentLifeRemaining = state.lifeRemaining;
            });
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Wrap(
                key: _heartKey,
                spacing: kLifeStarSpacing,
                children: List.generate(
                  _currentLifeRemaining,
                  (index) {
                    final isLast = index == _currentLifeRemaining - 1;

                    bool shouldAnimateAdd = wasLifeIncreased && isLast;
                    bool shouldAnimateRemove = wasLifeDecreased && isLast;

                    if (shouldAnimateAdd) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(
                            milliseconds: kAnimationDurationMedium),
                        curve: Curves.elasticOut,
                        onEnd: () {},
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: LifeStar(value: value),
                          );
                        },
                      );
                    }
                    if (shouldAnimateRemove) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: 0.0),
                        duration: const Duration(
                            milliseconds: kAnimationDurationMedium),
                        curve: Curves.elasticIn,
                        onEnd: () async {
                          await Future.delayed(
                            const Duration(
                                milliseconds: kAnimationDurationMedium),
                          ).then((_) {
                            if (!mounted) return;
                            wasLifeDecreased = false;
                            shouldAnimateRemove = false;
                            setState(() {
                              _currentLifeRemaining =
                                  _prevLifeRemaining ?? _currentLifeRemaining;
                            });
                          });
                        },
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: LifeStar(value: value),
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
        return Expanded(
          child: Center(
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
          ),
        );
      }

      // Show typing area with animations (user input) - ONLY when it's my turn
      // Skip for Pick Right mode - it uses button taps instead of typing
      if (combatState.isMyTurn && combatState.isTimeForTyping) {
        return Expanded(
          child: Center(
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
                                  _animationKey.currentState!.triggers
                                      .onAddPoint(center);
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
                              child: Icon(
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
          ),
        );
      }

      // Waiting/watching opponent - show mirror view
      if (combatState.isOpponentActive && !combatState.isMyTurn) {
        // Show the opponent's challenge and progress as a mirror
        if (combatState.requirementString != null &&
            combatState.expect != null) {
          return Expanded(
            child: Center(
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
                                  combatState.requirementString!.length,
                                  context)
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
                            child: Icon(
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
      return Expanded(
        child: Center(
          child: Text(
            lang(context).whichOneIsCorrect,
            style: AppTextStyles.titleLarge(context),
          ),
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
                  ? Icons.emoji_events
                  : Icons.hourglass_bottom,
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildKeyboard(CombatState combatState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keys = keyboardArray.entries.toList();
        const columns = 3;
        const rows = 4;
        final buttonWidth = constraints.maxWidth / columns;
        final buttonHeight = constraints.maxHeight / rows;
        const buttonSpacing = 20.0;

        List<Widget> columnChildren = [];
        for (int r = 0; r < rows; r++) {
          List<Widget> rowChildren = [];
          for (int c = 0; c < columns; c++) {
            int idx = r * columns + c;
            Widget cell;
            if (idx < keys.length) {
              final e = keys[idx];
              Duration duration = const Duration(milliseconds: 200);
              Widget button;
              if (e.key == KeyboardOption.reset) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.arrowsRotate,
                  isEnable:
                      combatState.isAbleToReset && combatState.isAbleToTap,
                  onPressed: () {
                    context.read<CombatBloc>().add(
                          CombatNumberReset(duration: duration),
                        );
                  },
                );
              } else if (e.key == KeyboardOption.mainMenu) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.bars,
                  onPressed: () => _handleMenuButton(context),
                );
              } else {
                button = AnimatedButton(
                  context,
                  text: e.value.toString(),
                  style: AppTextStyles.displayLarge(context),
                  isEnable: combatState.isAbleToTap,
                  onPressed: () {
                    context.read<CombatBloc>().add(
                          CombatTap(keyValue: e.key),
                        );
                  },
                );
              }
              cell = SizedBox(
                width: buttonWidth - buttonSpacing,
                height: buttonHeight - buttonSpacing,
                child: button,
              );
            } else {
              cell = SizedBox(
                width: buttonWidth - buttonSpacing,
                height: buttonHeight - buttonSpacing,
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: columnChildren,
        );
      },
    );
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
              equations: combatState.equations ?? [],
              selectedOption: combatState.selectedOption,
              isEnabled: combatState.isAbleToTap &&
                  combatState.isMyTurn &&
                  combatState.tapTimerRemaining > 0,
              isCorrectAnimating: combatState.pickRightJustCorrect,
              onButtonTap: (buttonIndex, position) {
                context.read<CombatBloc>().add(
                      CombatPickRightButtonTap(buttonIndex: buttonIndex),
                    );

                // Trigger fireworks simultaneously if correct
                if (buttonIndex == combatState.correctIndex &&
                    position != null) {
                  // Firework at the correct button position
                  _animationKey.currentState?.triggers.onAddPoint(position);
                  // Firework at the life star position (same timing)
                  final heartPosition = _getWidgetPosition(_heartKey);
                  _animationKey.currentState?.triggers
                      .onGainLife(heartPosition);
                }
              },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Animation event handler
  int? _prevPointForAnimation;
  int? _prevLifeForAnimation;
  int? _prevOpponentScoreForAnimation;

  void _handleAnimationEvents(BuildContext context, CombatState state) {
    // Track point changes

    // Track life changes
    final wasLifeIncreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining > _prevLifeForAnimation!;
    final wasLifeDecreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining < _prevLifeForAnimation!;

    // Track opponent score changes

    // // Trigger point animation
    // if (wasPointIncreased) {
    //   final scorePosition = _getWidgetPosition(_scoreKey);
    //   _animationKey.currentState?.triggers.onAddPoint(scorePosition);
    // }

    // Trigger opponent score animation (small firework)
    // This triggers IMMEDIATELY when opponent succeeds, before score updates
    if (state.opponentJustSucceeded) {
      final opponentScorePosition = _getWidgetPosition(_opponentScoreKey);
      _animationKey.currentState?.triggers.onAddPoint(opponentScorePosition);
    }
    // // Also trigger if score actually increased (fallback)
    // else if (wasOpponentScoreIncreased) {
    //   final opponentScorePosition = _getWidgetPosition(_opponentScoreKey);
    //   _animationKey.currentState?.triggers.onAddPoint(opponentScorePosition);
    // }

    // Trigger life gain animation
    // Skip for Pick Right mode - already triggered simultaneously in onButtonTap
    final isPickRight =
        state.difficultyModel?.difficulty == Difficulty.pickRight;
    if (wasLifeIncreasedForAnimation && !isPickRight) {
      final heartPosition = _getWidgetPosition(_heartKey);
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
      child: Icon(
        FontAwesomeIcons.solidStar,
        color: Theme.of(context).colorScheme.onPrimary,
        size: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
