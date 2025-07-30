import 'dart:developer';

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
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
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

    if (turnState.difficulty == null) {
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
    final isTablet = screenWidth > 600; // Adjust layout for tablets
    final padding = isTablet ? 40.0 : 20.0;
    final buttonSize = isTablet
        ? (screenWidth / 5) - buttonSpace * 2
        : (screenWidth / 3) - buttonSpace * 2;

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
              child: Padding(
                padding: EdgeInsets.all(padding),
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
                                    FontAwesomeIcons.layerGroup,
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
                                            log("message: Last life icon at index $index, shouldAnimateAdd: $shouldAnimateAdd, shouldAnimateRemove: $shouldAnimateRemove");
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
                                    turnState.expect!.length,
                                    (index) {
                                      String inputted =
                                          turnState.expect![index];
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
                                            Icon(
                                              FontAwesomeIcons.minus,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
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
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: (buttonSize + buttonSpace) *
                                3, // Make it in 3 column
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: buttonSpace,
                            runSpacing: buttonSpace,
                            children: keyboardArray.entries.map(
                              (e) {
                                Duration duration =
                                    const Duration(milliseconds: 200);
                                if (e.key == KeyboardOption.reset) {
                                  return AnimatedButton(
                                    context,
                                    buttonSize: buttonSize,
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
                                }

                                if (e.key == KeyboardOption.mainMenu) {
                                  return AnimatedButton(
                                    context,
                                    buttonSize: buttonSize,
                                    iconData: FontAwesomeIcons.bars,
                                    onPressed: () {
                                      Helper.pressMainMenu(context)
                                          .then((confirmedMenu) {
                                        if (confirmedMenu) {
                                          turnBloc.add(End(
                                            context,
                                            isCauseGameOver: false,
                                          ));

                                          // if (turnState.recordedItem != null) {
                                          //   turnBloc.add(SaveRecorded(context: context));
                                          // }

                                          menuBloc.add(
                                            SelectOption(
                                              option: null,
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  );
                                }

                                // return AnimatedOpacity(
                                //   opacity: turnState.isAbleToTap ? 1 : 0.5,
                                //   duration: const Duration(milliseconds: 200),
                                //   child: CustomElevatedButton(
                                //     text: e.value.toString(),
                                //     onPressed: () {
                                //       context.read<TurnBloc>().add(
                                //             Tap(context, keyValue: e.key),
                                //           );

                                //       setState(
                                //         () {
                                //           originalScale = 0.8;
                                //           // milisecondDuation = 100;
                                //         },
                                //       );
                                //     },
                                //   ),
                                // );

                                return AnimatedButton(
                                  context,
                                  buttonSize: buttonSize,
                                  text: e.value.toString(),
                                  isEnable: turnState.isAbleToTap,
                                  onPressed: () {
                                    context.read<TurnBloc>().add(
                                          Tap(context, keyValue: e.key),
                                        );
                                  },
                                );
                                // double originalScale = 1;
                                // int milisecondDuation = 50;
                                // return AnimatedScale(
                                //   scale: originalScale,
                                //   duration:
                                //       Duration(milliseconds: milisecondDuation),
                                //   child: SizedBox(
                                //     width: buttonSize,
                                //     height: buttonSize,
                                //     child: Builder(
                                //       builder: (context) {
                                //         Duration duration =
                                //             const Duration(milliseconds: 200);
                                //         if (e.key == KeyboardOption.reset) {
                                //           return AnimatedOpacity(
                                //             opacity: (turnState.isAbleToReset &&
                                //                     turnState.isAbleToTap)
                                //                 ? 1
                                //                 : 0.5,
                                //             duration: duration,
                                //             child: CustomElevatedButton(
                                //               icon:
                                //                   FontAwesomeIcons.arrowsRotate,
                                //               onPressed: () async {
                                //                 context.read<TurnBloc>().add(
                                //                       ResetNewNumber(context,
                                //                           duration: duration),
                                //                     );
                                //               },
                                //             ),
                                //           );
                                //         }

                                //         if (e.key == KeyboardOption.mainMenu) {
                                //           return AnimatedOpacity(
                                //             opacity: (turnState.isAbleToTap)
                                //                 ? 1
                                //                 : 0.5,
                                //             duration: const Duration(
                                //                 milliseconds: 200),
                                //             child: CustomElevatedButton(
                                //               icon: FontAwesomeIcons.bars,
                                //               onPressed: () {
                                //                 pressMainMenu(context)
                                //                     .then((confirmedMenu) {
                                //                   if (confirmedMenu) {}
                                //                 });
                                //               },
                                //             ),
                                //           );
                                //         }

                                //         return AnimatedOpacity(
                                //           opacity:
                                //               turnState.isAbleToTap ? 1 : 0.5,
                                //           duration:
                                //               const Duration(milliseconds: 200),
                                //           child: CustomElevatedButton(
                                //             text: e.value.toString(),
                                //             onPressed: () {
                                //               context.read<TurnBloc>().add(
                                //                     Tap(context,
                                //                         keyValue: e.key),
                                //                   );

                                //               setState(
                                //                 () {
                                //                   originalScale = 0.8;
                                //                   // milisecondDuation = 100;
                                //                 },
                                //               );
                                //             },
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // );
                              },
                            ).toList(),
                          ),
                        ),
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

class CustomeAlert extends StatefulWidget {
  final int point;
  final int? rank;

  const CustomeAlert({
    super.key,
    this.point = 0,
    this.rank = 0,
  });

  @override
  State<CustomeAlert> createState() => _CustomeAlertState();
}

class _CustomeAlertState extends State<CustomeAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        lang(context).confirmExit,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.rank != null) RankingSortingWidget(position: widget.rank!),
          if (widget.rank != null) const SizedBox(height: 20),
          Text(
            "${lang(context).score}: ${widget.point}",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            lang(context).no,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            return Navigator.of(context).pop(true);
          },
          child: Text(
            lang(context).yes,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
