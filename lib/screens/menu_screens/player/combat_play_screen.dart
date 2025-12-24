import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CombatPlayScreen extends StatefulWidget {
  const CombatPlayScreen({super.key});

  @override
  State<CombatPlayScreen> createState() => _CombatPlayScreenState();
}

class _CombatPlayScreenState extends State<CombatPlayScreen> {
  double get screenWidth => max(MediaQuery.of(context).size.width, 600);

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
      fontSize = 24;
    } else if (numberOfCharactor >= 8) {
      fontSize = 32;
    } else if (numberOfCharactor >= 6) {
      fontSize = 40;
    } else if (numberOfCharactor >= 4) {
      fontSize = 45;
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

    combatBloc.add(CombatLostLife(
      lifeRemaining: combatBloc.state.lifeRemaining,
    ));

    _currentLifeRemaining = combatBloc.state.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapper(
      key: _animationKey,
      child: BlocListener<CombatBloc, CombatState>(
        listener: _handleAnimationEvents,
        child: Scaffold(
          body: BlocBuilder<CombatBloc, CombatState>(
            builder: (context, combatState) {
              if (combatState.hasGameEnded) {
                return Container(
                  decoration: LayoutConfig(context).gradientDecoration,
                  child: SafeArea(
                    child: DeviceWrapper(
                      child: _buildGameEndScreen(combatState),
                    ),
                  ),
                );
              }

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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
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
    if (combatState.status == CombatStatus.intro) {
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
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: getCountdownGradient(time),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: CustomElevatedButton(
                                    buttonRadius: 1000,
                                    shapeAt: RoundedWithShapeAt.all,
                                    gradient: LinearGradient(
                                        colors:
                                            getCountdownGradient(time).colors)),
                              ),
                              // Circular progress indicator
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CircularProgressIndicator(
                                        value: secondProgress,
                                        strokeWidth: 8,
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
                                            fontSize: 40,
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
                                            fontSize: 16,
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
                                            fontSize: 32,
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

    // Waiting/watching opponent
    if (combatState.isWaitingForOpponent) {
      return Center(
        child: Text(
          lang(context).waitingForOpponent,
          style: LayoutConfig(context).contentSectionStyle().copyWith(
                color: Colors.yellow,
                fontSize: 24,
              ),
        ),
      );
    }

    if (combatState.isOpponentActive) {
      return Center(
        child: Text(
          lang(context).watchingOpponent,
          style: LayoutConfig(context).contentSectionStyle().copyWith(
                color: Colors.orange,
                fontSize: 24,
              ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGameEndScreen(CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 100,
            color: isWinner ? const Color(0xFFFFD700) : Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            isWinner ? lang(context).youWin : lang(context).youLose,
            style: LayoutConfig(context)
                .displaySmallStyle(
                  isActiveShadow: true,
                )
                .copyWith(
                  fontSize: 48,
                  color: isWinner ? Colors.green : Colors.red,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            _getGameEndReason(combatState.gameEndReason),
            style: LayoutConfig(context).contentSectionStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          CustomElevatedButton(
            text: 'Return to Menu',
            shapeAt: RoundedWithShapeAt.all,
            onPressed: () {
              // Just navigate to menu - game state will be reset on next game start
              context.read<PlayerNavCubit>().showSelectPlayMode();
            },
          ),
        ],
      ),
    );
  }

  String _getGameEndReason(String? reason) {
    switch (reason) {
      case 'opponent_lives_out':
        return lang(context).opponentRanOutOfLives;
      case 'my_lives_out':
        return lang(context).youRanOutOfLives;
      case 'opponent_disconnected':
        return lang(context).opponentDisconnected;
      default:
        return '';
    }
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
          const buttonSpacing = 10.0;

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
