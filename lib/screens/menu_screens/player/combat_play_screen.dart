import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/widgets/pick_right_buttons.dart';
import 'package:timer_count_down/timer_count_down.dart';

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
        title: lang(dialogContext).mainMenu,
        message: lang(dialogContext).confirmEndCombat,
        possitiveButtonLabel: lang(dialogContext).yes,
        onPossitiveButtonPressed: () => Navigator.of(dialogContext).pop(true),
        negativeButtonLabel: lang(dialogContext).no,
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
                  return Container(
                    decoration: LayoutConfig(context).gradientDecoration,
                    child: SafeArea(
                      child: DeviceWrapper(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // Tap timer countdown bar
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          // Calculate time values using the same formulas
                                          final totalSeconds =
                                              tapTimerDuration.toInt();
                                          final halfSeconds =
                                              (tapTimerDuration / 2).toInt();
                                          final quarterSeconds =
                                              (tapTimerDuration / 4).toInt();

                                          return Tooltip(
                                            message:
                                                lang(context).tapTimerTooltip(
                                              totalSeconds,
                                              halfSeconds,
                                              quarterSeconds,
                                            ),
                                            child: SizedBox(
                                              height: kTimerBarHeight,
                                              child: combatState.combatStatus ==
                                                      CombatStatus.playing
                                                  ? Countdown(
                                                      seconds: combatState
                                                          .tapTimerRemaining
                                                          .toInt(),
                                                      interval: const Duration(
                                                          milliseconds: 100),
                                                      build:
                                                          (BuildContext context,
                                                              double time) {
                                                        // Calculate percentage (0-100)
                                                        final percent = (time /
                                                                tapTimerDuration *
                                                                100)
                                                            .toInt();

                                                        // Determine color based on remaining time
                                                        Color backgroundColor = time >
                                                                tapTimerDuration /
                                                                    2
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : time >
                                                                    tapTimerDuration /
                                                                        4
                                                                ? Colors.orange
                                                                : Colors.red;

                                                        return Stack(
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          children: [
                                                            Positioned.fill(
                                                              child:
                                                                  CustomElevatedButton(
                                                                shapeAt:
                                                                    RoundedWithShapeAt
                                                                        .all,
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .secondaryHeaderColor,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                if (percent > 0)
                                                                  Expanded(
                                                                    flex:
                                                                        percent,
                                                                    child:
                                                                        CustomElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      shapeAt:
                                                                          RoundedWithShapeAt
                                                                              .all,
                                                                      backgroundColor:
                                                                          backgroundColor,
                                                                    ),
                                                                  ),
                                                                Expanded(
                                                                  flex: 100 -
                                                                      percent,
                                                                  child:
                                                                      Opacity(
                                                                    opacity: 0,
                                                                    child:
                                                                        Container(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      onFinished: () {},
                                                    )
                                                  : Stack(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      children: [
                                                        Positioned.fill(
                                                          child:
                                                              CustomElevatedButton(
                                                            shapeAt:
                                                                RoundedWithShapeAt
                                                                    .all,
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .secondaryHeaderColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: kSpaceM),
                                    ],
                                  ),

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
                            Expanded(
                              flex: 3,
                              child: _buildKeyboard(combatState),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
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
                            text: "${lang(context).level}: ",
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
                      "${lang(context).score}: ",
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kPaddingL, vertical: kPaddingSM),
                    decoration: BoxDecoration(
                      color:
                          combatState.isMyTurn ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      combatState.isMyTurn
                          ? lang(context).yourTurn
                          : lang(context).opponentTurn,
                      style: AppTextStyles.bodyLargeBold(context),
                    ),
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
                      "${lang(context).score}: ",
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
    // Show countdown intro animation
    if (combatState.combatStatus == CombatStatus.intro) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!context.read<CombatBloc>().isClosed)
              Builder(
                builder: (widgetContext) {
                  // Capture localized strings using the widget context
                  final readyText = "${lang(widgetContext).ready}!!";
                  final goText = lang(widgetContext).go;

                  return Countdown(
                    seconds: combatState.countDown,
                    interval: const Duration(milliseconds: 10),
                    build: (BuildContext context, double time) {
                      // Calculate progress within current second (0.0 to 1.0)
                      final secondProgress = time - time.floor();

                      Gradient getCountdownGradient(double time) {
                        if (time >= 5) {
                          return LinearGradient(
                            colors: [
                              Colors.green.shade300,
                              Colors.green.shade700
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          );
                        }
                        if (time >= 3) {
                          return LinearGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.blue.shade700
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          );
                        }
                        if (time >= 1) {
                          return LinearGradient(
                            colors: [
                              Colors.orange.shade300,
                              Colors.orange.shade700
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          );
                        }
                        return LinearGradient(
                          colors: [Colors.red.shade300, Colors.red.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        );
                      }

                      return AnimatedScale(
                        duration: const Duration(
                            milliseconds: kAnimationDurationSlow),
                        scale: time > 0.5 ? 1.0 : 5,
                        curve: Curves.easeOutQuart,
                        child: AnimatedOpacity(
                          duration: const Duration(
                              milliseconds: kAnimationDurationSlow),
                          opacity: time > 0.5 ? 1.0 : 0.0,
                          curve: Curves.easeOutQuart,
                          child: Container(
                            width: kCountdownCircleSize,
                            height: kCountdownCircleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: getCountdownGradient(time),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: CustomElevatedButton(
                                      buttonRadius: kBorderRadiusCircular,
                                      shapeAt: RoundedWithShapeAt.all,
                                      gradient: LinearGradient(
                                          colors: getCountdownGradient(time)
                                              .colors)),
                                ),
                                // Circular progress indicator
                                SizedBox(
                                  width: kCountdownCircleInnerSize,
                                  height: kCountdownCircleInnerSize,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CircularProgressIndicator(
                                          value: secondProgress,
                                          strokeWidth: kProgressStrokeWidth,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text content
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (time >= 1)
                                      AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        style:
                                            AppTextStyles.forCountdown(context),
                                        child: Text(
                                          time.truncate().toString(),
                                          style: AppTextStyles.forCountdown(
                                              context),
                                        ),
                                      ),
                                    if (time >= 1)
                                      AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        style: AppTextStyles.forCountdownReady(
                                            context),
                                        child: Text(
                                          readyText,
                                          style:
                                              AppTextStyles.forCountdownReady(
                                                  context),
                                        ),
                                      )
                                    else
                                      AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        style: AppTextStyles.forCountdownGo(
                                            context),
                                        child: Text(
                                          goText,
                                          style: AppTextStyles.forCountdownGo(
                                              context),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    onFinished: () {},
                  );
                },
              ),
            // Show turn order notice if available
            if (combatState.willStartFirst != null) ...[
              const SizedBox(height: kSpaceL),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSpaceL,
                  vertical: kSpaceS,
                ),
                decoration: BoxDecoration(
                  color: combatState.willStartFirst!
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(kBorderRadiusL),
                  border: Border.all(
                    color: combatState.willStartFirst!
                        ? Colors.green
                        : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      combatState.willStartFirst!
                          ? Icons.emoji_events
                          : Icons.hourglass_bottom,
                      color: combatState.willStartFirst!
                          ? Colors.green
                          : Colors.orange,
                      size: kFontSizeL,
                    ),
                    const SizedBox(width: kSpaceS),
                    Flexible(
                      child: Text(
                        combatState.willStartFirst!
                            ? lang(context).youWillTakeFirst
                            : lang(context).opponentWillTakeFirst,
                        style: AppTextStyles.bodyMediumBold(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: kSpaceXL),
              // // Show opponent's challenge (mirrored)
              // Wrap(
              //   children: List.generate(
              //     combatState.requirementString!.length,
              //     (index) {
              //       String char = combatState.requirementString![index];
              //       return SizedBox(
              //         width: (boldedStyleFont(
              //                     numberOfCharactor:
              //                         combatState.requirementString!.length)
              //                 .fontSize! *
              //             0.65),
              //         child: Column(
              //           children: [
              //             Opacity(
              //               opacity: 0.6, // Dimmed to show it's opponent's
              //               child: Text(
              //                 char,
              //                 textAlign: TextAlign.center,
              //                 style: boldedStyleFont(
              //                   numberOfCharactor:
              //                       combatState.requirementString!.length,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(height: kSpaceXL),
              // Show opponent's typing progress (always show when watching)
              Wrap(
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
            ],
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

      // Waiting for opponent to finish their move
      if (combatState.isWaitingForOpponent) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: kSpaceXL),
              Text(
                lang(context).waitingForOpponent,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: Colors.yellow,
                  fontSize: kFontSizeXL,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Center(
        child: Text(
          lang(context).whichOneIsCorrect,
          style: AppTextStyles.titleLarge(context),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildKeyboard(CombatState combatState) {
    // Check if Pick Right mode
    final isPickRightMode =
        combatState.difficultyModel?.difficulty == Difficulty.pickRight;

    if (isPickRightMode) {
      return _buildPickRightControls(combatState);
    }

    return Expanded(
      child: LayoutBuilder(
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
      ),
    );
  }

  /// Build Pick Right controls for Combat mode
  /// Reuses PickRightButtons widget for consistency with Solo mode
  Widget _buildPickRightControls(CombatState combatState) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpaceL),
        child: Column(
          children: [
            // Three equation buttons (same widget as Solo mode)
            Expanded(
              child: PickRightButtons(
                equations: combatState.equations ?? [],
                selectedOption: combatState.selectedOption,
                isEnabled: combatState.isAbleToTap && combatState.isMyTurn,
                onButtonTap: (buttonIndex, position) {
                  context.read<CombatBloc>().add(
                        CombatPickRightButtonTap(buttonIndex: buttonIndex),
                      );

                  // Trigger firework if correct
                  if (buttonIndex == combatState.correctIndex &&
                      position != null) {
                    _animationKey.currentState?.triggers.onAddPoint(position);
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
    final wasOpponentScoreIncreased = _prevOpponentScoreForAnimation != null &&
        state.opponentScore > _prevOpponentScoreForAnimation!;

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
    if (wasLifeIncreasedForAnimation) {
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
