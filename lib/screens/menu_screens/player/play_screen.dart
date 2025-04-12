import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch_with_bloc/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/helpers/template.dart';

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
  double get buttonSpace => 20;
  String inputtedValue = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TurnBloc, TurnState>(
        builder: (context, turnState) {
          if (turnState.status == TurnStatus.gameOver) {
            if (turnState is! GameOverState) {
              BlocProvider.of<PlayerNavCubit>(context).showGameover();
            }
          }

          if (turnState.status == TurnStatus.intro ||
              turnState.status == TurnStatus.initial) {
            if (turnState is! PlayingState) {
              BlocProvider.of<PlayerNavCubit>(context).showPlay();
            }
          }

          return Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Level: ${turnState.level}",
                                style:
                                    LayoutConfig(context).contentSectionStyle(),
                              ),
                              Wrap(
                                spacing: 5,
                                children: List.generate(
                                  turnState.lifeRemaining,
                                  (index) => Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize,
                                  ),
                                ),
                              ),
                              Text(
                                "Point: ${turnState.point}",
                                style:
                                    LayoutConfig(context).contentSectionStyle(),
                              ),
                            ],
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
                                        print(time);
                                        return AnimatedOpacity(
                                          opacity: time >= 1 ? 1 : 0,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: AnimatedScale(
                                            scale: time >= 1 ? 1 : 15,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: Text(
                                              time >= 1 ? "Ready!!" : "Go",
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
                                      onFinished: () {
                                        print('Let start!');
                                      },
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
                                )
                                // ??
                                // Text(
                                //   turnState.expect!,
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .displaySmall,
                                // )
                                ,
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
                                )
                                // ??
                                // Text(
                                //   turnState.typing,
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .displaySmall,
                                // )
                                ,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: buttonSpace,
                        runSpacing: buttonSpace,
                        children: keyboardArray.entries.map(
                          (e) {
                            double originalScale = 1;
                            int milisecondDuation = 50;
                            return AnimatedScale(
                              scale: originalScale,
                              duration:
                                  Duration(milliseconds: milisecondDuation),
                              child: SizedBox(
                                width: (screenWidth / 3) - buttonSpace * 2,
                                height: (screenWidth / 3) - buttonSpace * 2,
                                child: Builder(
                                  builder: (context) {
                                    if (e.key == KeyboardOption.reset) {
                                      return AnimatedOpacity(
                                        opacity: (turnState.isAbleToReset &&
                                                turnState.isAbleToTap)
                                            ? 1
                                            : 0.5,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: CustomElevatedButton(
                                          icon: FontAwesomeIcons.arrowsRotate,
                                          onPressed: () async {
                                            context.read<TurnBloc>().add(
                                                  ResetNewNumber(),
                                                );
                                          },
                                        ),
                                      );
                                    }

                                    if (e.key == KeyboardOption.mainMenu) {
                                      return AnimatedOpacity(
                                        opacity:
                                            (turnState.isAbleToTap) ? 1 : 0.5,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: CustomElevatedButton(
                                          icon: FontAwesomeIcons.bars,
                                          onPressed: () async {
                                            await pressMainMenu(context);
                                          },
                                        ),
                                      );
                                    }

                                    return AnimatedOpacity(
                                      opacity: turnState.isAbleToTap ? 1 : 0.5,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child:
                                          // buttonWidget(
                                          //       context,
                                          //       text: e.value.toString(),
                                          //       onTap: () {
                                          //         context.read<TurnBloc>().add(
                                          //               Tap(keyValue: e.key),
                                          //             );

                                          //         setState(
                                          //           () {
                                          //             originalScale = 0.8;
                                          //             milisecondDuation = 10;
                                          //           },
                                          //         );
                                          //       },
                                          //     ) ??
                                          CustomElevatedButton(
                                        text: e.value.toString(),
                                        onPressed: () {
                                          context.read<TurnBloc>().add(
                                                Tap(keyValue: e.key),
                                              );

                                          setState(
                                            () {
                                              originalScale = 0.8;
                                              milisecondDuation = 10;
                                            },
                                          );
                                        },
                                        // child: Text(
                                        //   e.value.toString(),
                                        //   style: LayoutConfig(context)
                                        //       .displaySmallStyle()
                                        //       .copyWith(
                                        //         color: Colors.black87,
                                        //       ),
                                        // ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ).toList(),
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

  Future<void> pressMainMenu(BuildContext context) async {
    // context.read<MenuBloc>().add(SelectOption(option: null),);
    BlocProvider.of<MenuBloc>(context).add(
      SelectOption(
        option: null,
      ),
    );
    return;
  }
}
