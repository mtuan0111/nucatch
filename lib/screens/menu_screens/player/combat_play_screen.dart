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
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';

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
          color: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${lang(context).level}: ${combatState.levelAndTimeCorrect}',
                      style: LayoutConfig(context).contentSectionStyle(),
                    ),
                  ],
                ),
                Row(
                  key: _scoreKey,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartLine,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${lang(context).score}: ${combatState.point}',
                      style: LayoutConfig(context).contentSectionStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Turn indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: combatState.isMyTurn ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              combatState.isMyTurn
                  ? lang(context).yourTurn
                  : lang(context).opponentTurn,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                Text(
                  '❤️ ${combatState.opponentLives}',
                  style: LayoutConfig(context).contentSectionStyle(),
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

    // Show typing area (user input)
    if (combatState.isTimeForTyping && combatState.expect != null) {
      return Center(
        child: Wrap(
          children: List.generate(
            combatState.expect!.length,
            (index) {
              String? inputted;
              if (index < combatState.typing.length) {
                inputted = combatState.typing[index];
              }

              return SizedBox(
                width: (boldedStyleFont(
                            numberOfCharactor: combatState.expect!.length)
                        .fontSize! *
                    0.65),
                child: Column(
                  children: [
                    Text(
                      inputted ?? "_",
                      textAlign: TextAlign.center,
                      style: boldedStyleFont(
                        numberOfCharactor: combatState.expect!.length,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.minus,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ],
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
                            CombatPlayerTapped(keyValue: e.key),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        size: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}
