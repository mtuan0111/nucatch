// ignore: unused_import
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';

import 'package:timer_count_down/timer_count_down.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    super.key,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  double get screenWidth => max(MediaQuery.of(context).size.width, 600);

  double get buttonSpace => 20;
  String inputtedValue = "";

  late bool wasLifeIncreased;
  late bool wasLifeDecreased;
  int? _prevLifeRemaining;
  late int _currentLifeRemaining;

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

  @override
  void initState() {
    turnRecordedListBloc.add(LoadData());

    // Store previous lifeRemaining for animation logic
    // final prevLife = _prevLifeRemaining;
    // _prevLifeRemaining = turnState.lifeRemaining;
    _currentLifeRemaining = turnState.lifeRemaining;
    wasLifeDecreased = false;
    wasLifeIncreased = false;

    if (turnState.difficultyModel == null) {
      playerNavCubit.showSetDifficulty();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No-op, but required for stateful logic
  }

  @override
  Widget build(BuildContext context) {
    // final isTablet = screenWidth > 600; // Adjust layout for tablets
    // // final padding = isTablet ? 40.0 : 20.0;
    // final buttonSize = 50.0; // Fixed button size for simplicity
    // // final buttonSize = isTablet
    // //     ? (screenWidth / 5) - buttonSpace * 2
    // //     : (screenWidth / 3) - buttonSpace * 2;

    return Scaffold(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Helper.getIconFromDifficulty(context,
                                        turnState.difficultyModel?.difficulty),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize,
                                  ),
                                  const SizedBox(width: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${lang(context).level}: ",
                                          style: LayoutConfig(context)
                                              .contentSectionStyle()
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: turnState.levelAndTimeCorrect,
                                          style: LayoutConfig(context)
                                              .contentSectionStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.chartLine,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize,
                                  ),
                                  const SizedBox(width: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${lang(context).score}: ",
                                          style: LayoutConfig(context)
                                              .contentSectionStyle()
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: "${turnState.point}",
                                          style: LayoutConfig(context)
                                              .contentSectionStyle(),
                                        ),
                                      ],
                                    ),
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
                              // Update _currentLifeRemaining only when lifeRemaining changes
                              wasLifeIncreased = _prevLifeRemaining != null &&
                                  state.lifeRemaining > _prevLifeRemaining!;
                              wasLifeDecreased = _prevLifeRemaining != null &&
                                  state.lifeRemaining < _prevLifeRemaining!;
                              if (_prevLifeRemaining == null ||
                                  state.lifeRemaining != _prevLifeRemaining) {
                                setState(() {
                                  _prevLifeRemaining = state.lifeRemaining;
                                  // Don't update _currentLifeRemaining here, let animation handle it
                                });

                                if (wasLifeIncreased) {
                                  setState(() {
                                    _currentLifeRemaining = state.lifeRemaining;
                                  });
                                }
                              }
                              // if (wasLifeIncreased) {
                              //   setState(() {
                              //     _prevLifeRemaining = state.lifeRemaining;
                              //     _currentLifeRemaining = state.lifeRemaining;
                              //   });
                              // }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Wrap(
                                      spacing: 00,
                                      children: List.generate(
                                        _currentLifeRemaining,
                                        (index) {
                                          final isLast = index ==
                                              _currentLifeRemaining - 1;

                                          bool shouldAnimateAdd =
                                              wasLifeIncreased && isLast;
                                          bool shouldAnimateRemove =
                                              wasLifeDecreased && isLast;

                                          if (isLast) {
                                            // Handle last life icon specific logic
                                            dev.log(
                                                "message: Last life icon at index $index, shouldAnimateAdd: $shouldAnimateAdd, shouldAnimateRemove: $shouldAnimateRemove");
                                          }

                                          if (shouldAnimateAdd) {
                                            return TweenAnimationBuilder<
                                                double>(
                                              tween: Tween<double>(
                                                  begin: 0.0, end: 1.0),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.elasticOut,
                                              onEnd: () {},
                                              builder: (context, value, child) {
                                                return Transform.scale(
                                                  scale: value,
                                                  child: LifeStar(
                                                    value: value,
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          if (shouldAnimateRemove) {
                                            return TweenAnimationBuilder<
                                                double>(
                                              tween: Tween<double>(
                                                  begin: 1.0, end: 0.0),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.elasticIn,
                                              onEnd: () async {
                                                await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300),
                                                ).then((_) {
                                                  wasLifeDecreased = false;
                                                  shouldAnimateRemove = false;
                                                  setState(() {
                                                    _currentLifeRemaining =
                                                        _prevLifeRemaining ??
                                                            _currentLifeRemaining;
                                                  });
                                                });
                                                // setState(() {
                                                //   _currentLifeRemaining =
                                                //       _prevLifeRemaining ??
                                                //           _currentLifeRemaining;
                                                // });
                                              },
                                              builder: (context, value, child) {
                                                return Transform.scale(
                                                  scale: value,
                                                  child: LifeStar(
                                                    value: value,
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
                          if (turnState.status == TurnStatus.intro)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!context.read<TurnBloc>().isClosed)
                                    Countdown(
                                      seconds: turnState.countDown,
                                      interval:
                                          const Duration(milliseconds: 400),
                                      build:
                                          (BuildContext context, double time) {
                                        return AnimatedOpacity(
                                          opacity: time >= 1 ? 1 : 0,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: AnimatedScale(
                                            scale: time >= 1 ? 1 : 15,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: Text(
                                              time >= 1
                                                  ? "${lang(context).ready}!!"
                                                  : lang(context).go,
                                              style: LayoutConfig(context)
                                                  .titleSectionStyle(
                                                      isItalic: true)
                                                  .copyWith(
                                                    fontSize: time <= 1
                                                        ? (time /
                                                                turnState
                                                                    .countDown) *
                                                            Theme.of(context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .fontSize!
                                                        : null,
                                                  ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  if (!context.read<TurnBloc>().isClosed)
                                    Countdown(
                                      seconds: turnState.countDown,
                                      interval:
                                          const Duration(milliseconds: 100),
                                      build:
                                          (BuildContext context, double time) =>
                                              AnimatedOpacity(
                                        opacity: time >= 1 ? 1 : 0,
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        curve: Curves.easeOutQuart,
                                        child: AnimatedScale(
                                          scale: time >= 1 ? 1 : 0,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeOutQuart,
                                          child: (time >= 1)
                                              ? Text(
                                                  time.round().toString(),
                                                  style: (LayoutConfig(context)
                                                          .displaySmallStyle())
                                                      .copyWith(
                                                    fontSize: (time <= 1)
                                                        ? (time /
                                                                turnState
                                                                    .countDown) *
                                                            Theme.of(context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .fontSize!
                                                        : null,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                      onFinished: () {},
                                    ),
                                ],
                              ),
                            ),
                          if (turnState.isShowExpect)
                            Expanded(
                              child: Center(
                                child: Wrap(
                                  children: List.generate(
                                    turnState.requirementString!.length,
                                    (index) {
                                      String inputted =
                                          turnState.requirementString![index];
                                      return SizedBox(
                                        width: (LayoutConfig(context)
                                                .displaySmallStyle()
                                                .fontSize! *
                                            0.65),
                                        child: Column(
                                          children: [
                                            Text(
                                              inputted,
                                              textAlign: TextAlign.center,
                                              style: LayoutConfig(context)
                                                  .displaySmallStyle(),
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
                          if (turnState.isTimeForTyping)
                            Expanded(
                              child: Center(
                                child: Wrap(
                                  children: List.generate(
                                    turnState.expect!.length,
                                    (index) {
                                      double hide = turnState
                                                  .isTypingNotEmpty &&
                                              index < turnState.typing.length
                                          ? 1
                                          : 0;

                                      String inputted =
                                          turnState.expect![index];
                                      return SizedBox(
                                        width: (LayoutConfig(context)
                                                .displaySmallStyle()
                                                .fontSize! *
                                            0.65),
                                        child: Column(
                                          children: [
                                            AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              opacity: hide,
                                              child: AnimatedOpacity(
                                                curve: Curves.easeOutQuart,
                                                opacity:
                                                    turnState.isFinishTarget
                                                        ? 0
                                                        : 1,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                child: AnimatedScale(
                                                  curve: Curves.easeOutQuart,
                                                  scale:
                                                      turnState.isFinishTarget
                                                          ? 2
                                                          : 1,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child: Text(
                                                    inputted,
                                                    textAlign: TextAlign.center,
                                                    style: LayoutConfig(context)
                                                        .displaySmallStyle(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              opacity: (hide == 0) ? 1 : 0,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: Icon(
                                                FontAwesomeIcons.minus,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Prepare 3x4 grid
                          final keys = keyboardArray.entries.toList();
                          const columns = 3;
                          const rows = 4;
                          final buttonWidth = constraints.maxWidth / columns;
                          final buttonHeight = constraints.maxHeight / rows;
                          const buttonSpacing = 20.0;

                          List<TableRow> tableRows = [];
                          for (int r = 0; r < rows; r++) {
                            List<Widget> rowChildren = [];
                            for (int c = 0; c < columns; c++) {
                              int idx = r * columns + c;
                              if (idx < keys.length) {
                                final e = keys[idx];
                                Duration duration =
                                    const Duration(milliseconds: 200);
                                Widget button;
                                if (e.key == KeyboardOption.reset) {
                                  button = AnimatedButton(
                                    context,
                                    buttonSize: buttonWidth < buttonHeight
                                        ? buttonWidth - buttonSpacing
                                        : buttonHeight - buttonSpacing,
                                    iconData: FontAwesomeIcons.arrowsRotate,
                                    isEnable: turnState.isAbleToReset &&
                                        turnState.isAbleToTap,
                                    onPressed: () {
                                      context.read<TurnBloc>().add(
                                            ResetNewNumber(context,
                                                duration: duration),
                                          );
                                    },
                                  );
                                } else if (e.key == KeyboardOption.mainMenu) {
                                  button = AnimatedButton(
                                    context,
                                    buttonSize: buttonWidth < buttonHeight
                                        ? buttonWidth - buttonSpacing
                                        : buttonHeight - buttonSpacing,
                                    iconData: FontAwesomeIcons.bars,
                                    onPressed: () {
                                      Helper.pressMainMenu(context)
                                          .then((confirmedMenu) {
                                        if (confirmedMenu) {
                                          turnBloc.add(End(
                                            context,
                                            isCauseGameOver: false,
                                          ));
                                          menuBloc.add(
                                            SelectOption(
                                              option: null,
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  );
                                } else {
                                  button = AnimatedButton(
                                    context,
                                    buttonSize: buttonWidth < buttonHeight
                                        ? buttonWidth - buttonSpacing
                                        : buttonHeight - buttonSpacing,
                                    text: e.value.toString(),
                                    isEnable: turnState.isAbleToTap,
                                    onPressed: () {
                                      context.read<TurnBloc>().add(
                                            Tap(context, keyValue: e.key),
                                          );
                                    },
                                  );
                                }
                                rowChildren.add(
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(buttonSpacing / 2),
                                    child: SizedBox(
                                      width: buttonWidth - buttonSpacing,
                                      height: buttonHeight - buttonSpacing,
                                      child: button,
                                    ),
                                  ),
                                );
                              } else {
                                rowChildren.add(
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(buttonSpacing / 2),
                                    child: SizedBox(
                                      width: buttonWidth - buttonSpacing,
                                      height: buttonHeight - buttonSpacing,
                                    ),
                                  ),
                                );
                              }
                            }
                            tableRows.add(TableRow(
                              children: rowChildren,
                            ));
                          }
                          return Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: tableRows,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> pressReset() async {
    return;
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

class MenuAlert extends StatelessWidget {
  final int point;
  final int? rank;
  final TurnBloc turnBloc;
  final TurnState turnState;
  final PlayerNavCubit playerNavCubit;

  const MenuAlert({
    super.key,
    this.point = 0,
    this.rank,
    required this.turnBloc,
    required this.turnState,
    required this.playerNavCubit,
  });

  @override
  Widget build(BuildContext context) {
    return _AlertTemplate(
      title: lang(context).confirmExit,
      message: lang(context).areYouSure,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null) RankingSortingWidget(position: rank!),
          if (rank != null) const SizedBox(height: 20),
          Text(
            "${lang(context).score}: $point",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${lang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, turnState.difficultyModel!.difficulty)}",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        _buildActionButton(
          context,
          label: lang(context).no,
          color: Theme.of(context).colorScheme.error,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        _buildActionButton(
          context,
          label: lang(context).yes,
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        _buildActionButton(
          context,
          label: lang(context).difficultySetting,
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (context) => _AlertTemplate(
                title: lang(context).confirmChangeDifficulty,
                message: lang(context).areYouSure,
                content: Text(lang(context).areYouSure),
                actions: [
                  _buildActionButton(
                    context,
                    label: lang(context).yes,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                  _buildActionButton(
                    context,
                    label: lang(context).no,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  // TextButton(
                  //   onPressed: () => Navigator.of(context).pop(false),
                  //   child: Text(lang(context).no),
                  // ),
                  // TextButton(
                  //   onPressed: () => Navigator.of(context).pop(true),
                  //   child: Text(lang(context).yes),
                  // ),
                ],
              ),
            ).then((confirmed) {
              if (confirmed == true) {
                turnBloc.add(SaveRecorded(
                  context,
                  callback: () {
                    playerNavCubit.showSetDifficulty();
                    Navigator.of(context).pop(false);
                  },
                ));
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AlertTemplate extends StatelessWidget {
  final String title;
  final String? message;
  final Widget content;
  final List<Widget> actions;

  const _AlertTemplate({
    required this.title,
    this.message,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                message!,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions,
        )
      ],
    );
  }
}
