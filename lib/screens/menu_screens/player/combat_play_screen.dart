import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
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

  // Font size for challenge display
  TextStyle boldedStyleFont({int numberOfCharactor = 1}) {
    double fontSize = 50;

    if (numberOfCharactor >= 10) {
      fontSize = kFontSizeXL;
    } else if (numberOfCharactor >= 8) {
      fontSize = kFontSize2XL;
    } else if (numberOfCharactor >= 6) {
      fontSize = kFontSize3XL;
    } else if (numberOfCharactor >= 4) {
      fontSize = kFontSize4XL;
    }
    return LayoutConfig(context).boldedStyle.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: fontSize,
        );
  }

  @override
  void initState() {
    super.initState();

    // Initialize life animation tracking
    final combatBloc = context.read<CombatBloc>();

    _currentLifeRemaining = combatBloc.state.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapper(
      key: _animationKey,
      child: BlocListener<CombatBloc, CombatState>(
        listenWhen: (previous, current) {
          // Navigate to end game screen when game ends
          if (!previous.hasGameEnded && current.hasGameEnded) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state.hasGameEnded) {
            context.read<CombatNavCubit>().showEndGame();
          }
        },
        child: BlocListener<CombatBloc, CombatState>(
          listener: _handleAnimationEvents,
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
                                                                  flex: percent,
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
                                                                child: Opacity(
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
                                                    clipBehavior: Clip.hardEdge,
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
                                    const SizedBox(height: kSpaceS),
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
                          if (combatState.canTap) _buildKeyboard(combatState),
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
    );
  }

  Widget _buildCombatHeader(CombatState combatState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Helper.getIconFromDifficulty(
                          context, combatState.difficultyModel?.difficulty),
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${lang(context).level}: ${combatState.levelAndTimeCorrect}',
                        style: LayoutConfig(context).contentSectionStyle(),
                      ),
                    ),
                  ],
                ),
                Row(
                  key: _scoreKey,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartLine,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${lang(context).score}: ${combatState.point}',
                        style: LayoutConfig(context).contentSectionStyle(),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: combatState.isMyTurn ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    combatState.isMyTurn
                        ? lang(context).yourTurn
                        : lang(context).opponentTurn,
                    style: LayoutConfig(context).boldSubtitleStyle(),
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
                  'Opponent',
                  style: LayoutConfig(context)
                      .contentSectionStyle()
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${lang(context).score}: ${combatState.opponentScore}',
                  style: LayoutConfig(context).contentSectionStyle(),
                ),

                Wrap(
                  spacing: 0,
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

                // Turn indicator
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

          if (wasLifeIncreased) {
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
                spacing: 0,
                children: List.generate(
                  _currentLifeRemaining,
                  (index) {
                    final isLast = index == _currentLifeRemaining - 1;

                    bool shouldAnimateAdd = wasLifeIncreased && isLast;
                    bool shouldAnimateRemove = wasLifeDecreased && isLast;

                    if (shouldAnimateAdd) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
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
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.elasticIn,
                        onEnd: () async {
                          await Future.delayed(
                            const Duration(milliseconds: 300),
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
      return Column(
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
                      if (time >= 3) {
                        return LinearGradient(
                          colors: [
                            Colors.green.shade300,
                            Colors.green.shade700
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        );
                      }
                      if (time >= 2) {
                        return LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade700],
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
                      duration: const Duration(milliseconds: 500),
                      scale: time > 0.5 ? 1.0 : 5,
                      curve: Curves.easeOutQuart,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
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
                                        colors:
                                            getCountdownGradient(time).colors)),
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
                                            .onPrimary
                                            .withOpacity(0.3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
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
                                      style: LayoutConfig(context)
                                          .displaySmallStyle()
                                          .copyWith(
                                            fontSize: kFontSize3XL,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                      child: Text(
                                        time.truncate().toString(),
                                      ),
                                    ),
                                  if (time >= 1)
                                    AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      style: LayoutConfig(context)
                                          .titleSectionStyle(isItalic: true)
                                          .copyWith(
                                            fontSize: kFontSizeM,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                      child: Text(readyText),
                                    )
                                  else
                                    AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      style: LayoutConfig(context)
                                          .titleSectionStyle(isItalic: true)
                                          .copyWith(
                                            fontSize: kFontSize2XL,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                      child: Text(goText),
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
        ],
      );
    }

    // Show requirement string (what to memorize/solve)
    if (combatState.isShowExpect && combatState.requirementString != null) {
      return Center(
        child: Wrap(
          children: List.generate(
            combatState.requirementString!.length,
            (index) {
              String char = combatState.requirementString![index];
              return SizedBox(
                width: (boldedStyleFont(
                            numberOfCharactor:
                                combatState.requirementString!.length)
                        .fontSize! *
                    0.65),
                child: Column(
                  children: [
                    Text(
                      char,
                      textAlign: TextAlign.center,
                      style: boldedStyleFont(
                        numberOfCharactor:
                            combatState.requirementString!.length,
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

    // Show typing area with animations (user input)
    if (combatState.isTimeForTyping && combatState.expect != null) {
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

              return SizedBox(
                width: (boldedStyleFont(
                            numberOfCharactor:
                                combatState.requirementString!.length)
                        .fontSize! *
                    0.65),
                child: Builder(
                  builder: (context) {
                    // Trigger firework animation at character position when finished
                    if (combatState.isFinishTarget && hide == 1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final RenderBox? renderBox =
                            context.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          final position = renderBox.localToGlobal(Offset.zero);
                          final size = renderBox.size;
                          final center = position +
                              Offset(size.width / 2, size.height / 2);

                          // Trigger firework with cascading delay
                          Future.delayed(Duration(milliseconds: index * 50),
                              () {
                            if (mounted && _animationKey.currentState != null) {
                              _animationKey.currentState!.triggers
                                  .onAddPoint(center);
                            }
                          });
                        }
                      });
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
                                style: boldedStyleFont(
                                  numberOfCharactor:
                                      combatState.requirementString!.length,
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
      );
    }

    // Waiting/watching opponent - show mirror view
    if (combatState.isOpponentActive) {
      // Show the opponent's challenge and progress as a mirror
      if (combatState.requirementString != null && combatState.expect != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang(context).watchingOpponent,
              style: LayoutConfig(context).contentSectionStyle().copyWith(
                    color: Colors.orange,
                    fontSize: kFontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: kSpace4XL),
            // Show opponent's challenge (mirrored)
            Wrap(
              children: List.generate(
                combatState.requirementString!.length,
                (index) {
                  String char = combatState.requirementString![index];
                  return SizedBox(
                    width: (boldedStyleFont(
                                numberOfCharactor:
                                    combatState.requirementString!.length)
                            .fontSize! *
                        0.65),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: 0.6, // Dimmed to show it's opponent's
                          child: Text(
                            char,
                            textAlign: TextAlign.center,
                            style: boldedStyleFont(
                              numberOfCharactor:
                                  combatState.requirementString!.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: kSpaceXL),
            // Show opponent's typing progress if available
            if (combatState.opponentInput != null &&
                combatState.opponentInput!.isNotEmpty)
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
                      width: (boldedStyleFont(
                                  numberOfCharactor:
                                      combatState.requirementString!.length)
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
                              style: boldedStyleFont(
                                numberOfCharactor:
                                    combatState.requirementString!.length,
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
              )
            else
              // Show waiting indicator if no input yet
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
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
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: kSpaceXL),
            Text(
              lang(context).watchingOpponent,
              style: LayoutConfig(context).contentSectionStyle().copyWith(
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
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: kSpaceXL),
            Text(
              lang(context).waitingForOpponent,
              style: LayoutConfig(context).contentSectionStyle().copyWith(
                    color: Colors.yellow,
                    fontSize: kFontSizeXL,
                  ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildKeyboard(CombatState combatState) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keys = keyboardArray.entries.toList();
          const columns = 3;
          const rows = 4;
          final buttonWidth = constraints.maxWidth / columns;
          final buttonHeight = 80.0;
          const buttonSpacing = kSpaceM;

          List<TableRow> tableRows = [];
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
                    isEnable: combatState.isAbleToReset && combatState.canTap,
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
                    onPressed: () {
                      // Handle menu - maybe show end game dialog
                    },
                  );
                } else {
                  button = AnimatedButton(
                    context,
                    text: e.value.toString(),
                    style: LayoutConfig(context).boldedStyle,
                    isEnable: combatState.canTap,
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
            tableRows.add(TableRow(children: rowChildren));
          }

          return Table(
            children: tableRows,
          );
        },
      ),
    );
  }

  // Animation event handler
  int? _prevPointForAnimation;
  int? _prevLifeForAnimation;

  void _handleAnimationEvents(BuildContext context, CombatState state) {
    // Track point changes
    final wasPointIncreased =
        _prevPointForAnimation != null && state.point > _prevPointForAnimation!;

    // Track life changes
    final wasLifeIncreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining > _prevLifeForAnimation!;
    final wasLifeDecreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining < _prevLifeForAnimation!;

    // Trigger point animation
    if (wasPointIncreased) {
      final scorePosition = _getWidgetPosition(_scoreKey);
      _animationKey.currentState?.triggers.onAddPoint(scorePosition);
    }

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
