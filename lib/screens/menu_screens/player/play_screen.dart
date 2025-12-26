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
import 'package:nucatch/helpers/animations/animated_game_wrapper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

import 'package:timer_count_down/timer_count_down.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String get screenTitle => widget.title;
  double get screenWidth =>
      max(MediaQuery.of(context).size.width, kMinScreenWidth);

  double get buttonSpace => kSpaceXL;
  String inputtedValue = "";

  late bool wasLifeIncreased;
  late bool wasLifeDecreased;
  int? _prevLifeRemaining;
  late int _currentLifeRemaining;

  // Animation system
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  final GlobalKey _scoreKey = GlobalKey();
  final GlobalKey _heartKey = GlobalKey();

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

  // Font size constants
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
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: fontSize,
        );
  }

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

  void _handleMenuButton() {
    // Pause timer when menu opens
    turnBloc.add(TapTimerPause());

    Helper.pressMainMenu(context).then((confirmedMenu) {
      if (confirmedMenu) {
        turnBloc.add(End(
          isCauseGameOver: false,
        ));
        menuBloc.add(
          SelectOption(
            option: null,
          ),
        );
      } else {
        // Resume timer when menu closes
        turnBloc.add(TapTimerResume());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isTablet = screenWidth > 600; // Adjust layout for tablets
    // // final padding = isTablet ? 40.0 : 20.0;
    // final buttonSize = 50.0; // Fixed button size for simplicity
    // // final buttonSize = isTablet
    // //     ? (screenWidth / 5) - buttonSpace * 2
    // //     : (screenWidth / 3) - buttonSpace * 2;

    return AnimatedGameWrapper(
      key: _animationKey,
      child: BlocListener<TurnBloc, TurnState>(
        listener: _handleAnimationEvents,
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              _handleMenuButton();
            }
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
                                            child: turnState.status ==
                                                    TurnStatus.playing
                                                ? Countdown(
                                                    seconds: turnState
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
                                                          // .clamp(0, 100)
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
                                    const SizedBox(height: kSpaceM),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Helper.getIconFromDifficulty(
                                                    context,
                                                    turnState.difficultyModel
                                                        ?.difficulty),
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
                                                          "${lang(context).level}: ",
                                                      style: LayoutConfig(
                                                              context)
                                                          .contentSectionStyle()
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    TextSpan(
                                                      text: turnState
                                                          .levelAndTimeCorrect,
                                                      style: LayoutConfig(
                                                              context)
                                                          .contentSectionStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            key: _scoreKey,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
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
                                                "${lang(context).score}: ",
                                                style: LayoutConfig(context)
                                                    .contentSectionStyle()
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              Text(
                                                "${turnState.point}",
                                                style: LayoutConfig(context)
                                                    .contentSectionStyle(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                    wasLifeIncreased =
                                        _prevLifeRemaining != null &&
                                            state.lifeRemaining >
                                                _prevLifeRemaining!;
                                    wasLifeDecreased =
                                        _prevLifeRemaining != null &&
                                            state.lifeRemaining <
                                                _prevLifeRemaining!;
                                    if (_prevLifeRemaining == null ||
                                        state.lifeRemaining !=
                                            _prevLifeRemaining) {
                                      setState(() {
                                        _prevLifeRemaining =
                                            state.lifeRemaining;
                                        // Don't update _currentLifeRemaining here, let animation handle it
                                      });

                                      if (wasLifeIncreased) {
                                        setState(() {
                                          _currentLifeRemaining =
                                              state.lifeRemaining;
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Wrap(
                                            key: _heartKey,
                                            spacing: kLifeStarSpacing,
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
                                                    builder: (context, value,
                                                        child) {
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
                                                        wasLifeDecreased =
                                                            false;
                                                        shouldAnimateRemove =
                                                            false;
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
                                                    builder: (context, value,
                                                        child) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (!context.read<TurnBloc>().isClosed)
                                          Builder(
                                            builder: (widgetContext) {
                                              // Capture localized strings using the widget context
                                              final readyText =
                                                  "${lang(widgetContext).ready}!!";
                                              final goText =
                                                  lang(widgetContext).go;

                                              return Countdown(
                                                seconds: turnState.countDown,
                                                interval: const Duration(
                                                    milliseconds: 10),
                                                build: (BuildContext context,
                                                    double time) {
                                                  // Calculate which second we're in (1, 2, or 3)
                                                  // Calculate progress within current second (0.0 to 1.0)
                                                  final secondProgress =
                                                      time - time.floor();

                                                  Gradient getCountdownGradient(
                                                      double time) {
                                                    if (time >= 3) {
                                                      return LinearGradient(
                                                        colors: [
                                                          Colors.green.shade300,
                                                          Colors.green.shade700
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      );
                                                    }
                                                    if (time >= 2) {
                                                      return LinearGradient(
                                                        colors: [
                                                          Colors.blue.shade300,
                                                          Colors.blue.shade700
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      );
                                                    }
                                                    if (time >= 1) {
                                                      return LinearGradient(
                                                        colors: [
                                                          Colors
                                                              .orange.shade300,
                                                          Colors.orange.shade700
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      );
                                                    }
                                                    return LinearGradient(
                                                      colors: [
                                                        Colors.red.shade300,
                                                        Colors.red.shade700
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    );
                                                  }

                                                  return AnimatedScale(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    scale: time > 0.5 ? 1.0 : 5,
                                                    curve: Curves.easeOutQuart,
                                                    child: AnimatedOpacity(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      opacity: time > 0.5
                                                          ? 1.0
                                                          : 0.0,
                                                      curve:
                                                          Curves.easeOutQuart,
                                                      child: Container(
                                                        width:
                                                            kCountdownCircleSize,
                                                        height:
                                                            kCountdownCircleSize,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              getCountdownGradient(
                                                                  time),
                                                        ),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Positioned.fill(
                                                              child: CustomElevatedButton(
                                                                  buttonRadius:
                                                                      kBorderRadiusCircular,
                                                                  shapeAt:
                                                                      RoundedWithShapeAt
                                                                          .all,
                                                                  gradient: LinearGradient(
                                                                      colors: getCountdownGradient(
                                                                              time)
                                                                          .colors)),
                                                            ),
                                                            // Circular progress indicator - completes once per second
                                                            SizedBox(
                                                              width:
                                                                  kCountdownCircleInnerSize,
                                                              height:
                                                                  kCountdownCircleInnerSize,
                                                              child: Stack(
                                                                children: [
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      value:
                                                                          secondProgress,
                                                                      strokeWidth:
                                                                          kProgressStrokeWidth,
                                                                      backgroundColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.3),
                                                                      valueColor:
                                                                          const AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Text content
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                if (time >= 1)
                                                                  AnimatedDefaultTextStyle(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    style: LayoutConfig(
                                                                            context)
                                                                        .displaySmallStyle()
                                                                        .copyWith(
                                                                          fontSize:
                                                                              kFontSize3XL,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                    child: Text(
                                                                      time
                                                                          .truncate()
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                if (time >= 1)
                                                                  AnimatedDefaultTextStyle(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    style: LayoutConfig(
                                                                            context)
                                                                        .titleSectionStyle(
                                                                            isItalic:
                                                                                true)
                                                                        .copyWith(
                                                                          fontSize:
                                                                              kFontSizeM,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                    child: Text(
                                                                        readyText),
                                                                  )
                                                                else
                                                                  AnimatedDefaultTextStyle(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    style: LayoutConfig(
                                                                            context)
                                                                        .titleSectionStyle(
                                                                            isItalic:
                                                                                true)
                                                                        .copyWith(
                                                                          fontSize:
                                                                              kFontSize2XL,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                    child: Text(
                                                                        goText),
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
                                    ),
                                  ),
                                if (turnState.isShowExpect)
                                  Expanded(
                                    child: Center(
                                      child: Wrap(
                                        children: List.generate(
                                          turnState.requirementString!.length,
                                          (index) {
                                            String inputted = turnState
                                                .requirementString![index];
                                            return SizedBox(
                                              width: (boldedStyleFont(
                                                          numberOfCharactor:
                                                              turnState
                                                                  .requirementString!
                                                                  .length)
                                                      .fontSize! *
                                                  0.65),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    inputted,
                                                    textAlign: TextAlign.center,
                                                    style: boldedStyleFont(
                                                      numberOfCharactor:
                                                          turnState
                                                              .requirementString!
                                                              .length,
                                                    ),
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
                                                    index <
                                                        turnState.typing.length
                                                ? 1
                                                : 0;

                                            String inputted =
                                                turnState.expect![index];

                                            return SizedBox(
                                              width: (boldedStyleFont(
                                                          numberOfCharactor:
                                                              turnState
                                                                  .requirementString!
                                                                  .length)
                                                      .fontSize! *
                                                  0.65),
                                              child: Builder(
                                                builder: (context) {
                                                  // Trigger firework when finished
                                                  if (turnState
                                                          .isFinishTarget &&
                                                      hide == 1) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      final RenderBox?
                                                          renderBox =
                                                          context.findRenderObject()
                                                              as RenderBox?;
                                                      if (renderBox != null) {
                                                        final position =
                                                            renderBox
                                                                .localToGlobal(
                                                                    Offset
                                                                        .zero);
                                                        final size =
                                                            renderBox.size;
                                                        final center = position +
                                                            Offset(
                                                                size.width / 2,
                                                                size.height /
                                                                    2);

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
                                                            _animationKey
                                                                .currentState!
                                                                .triggers
                                                                .onAddPoint(
                                                                    center);
                                                          }
                                                        });
                                                      }
                                                    });
                                                  }

                                                  return Column(
                                                    children: [
                                                      AnimatedOpacity(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        opacity: hide,
                                                        child: AnimatedOpacity(
                                                          curve: Curves
                                                              .easeOutQuart,
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  boldedStyleFont(
                                                                numberOfCharactor:
                                                                    turnState
                                                                        .requirementString!
                                                                        .length,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      AnimatedOpacity(
                                                        opacity:
                                                            (hide == 0) ? 1 : 0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          color:
                                                              Theme.of(context)
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
                              ],
                            ),
                          ),
                          // Tap Timer Progress Bar

                          Expanded(
                            flex: 2,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Prepare 3x4 grid
                                final keys = keyboardArray.entries.toList();
                                const columns = 3;
                                const rows = 4;
                                final buttonWidth =
                                    constraints.maxWidth / columns;
                                final buttonHeight =
                                    constraints.maxHeight / rows;
                                const buttonSpacing = 20.0;
                                const tableGap = 10.0;

                                List<TableRow> tableRows = [];
                                for (int r = 0; r < rows; r++) {
                                  List<Widget> rowChildren = [];
                                  for (int c = 0; c < columns; c++) {
                                    int idx = r * columns + c;
                                    Widget cell;
                                    if (idx < keys.length) {
                                      final e = keys[idx];
                                      Duration duration =
                                          const Duration(milliseconds: 200);
                                      Widget button;
                                      if (e.key == KeyboardOption.reset) {
                                        button = AnimatedButton(
                                          context,
                                          iconData:
                                              FontAwesomeIcons.arrowsRotate,
                                          isEnable: turnState.isAbleToReset &&
                                              turnState.isAbleToTap,
                                          onPressed: () {
                                            context.read<TurnBloc>().add(
                                                  ResetNewNumber(
                                                      duration: duration),
                                                );
                                          },
                                        );
                                      } else if (e.key ==
                                          KeyboardOption.mainMenu) {
                                        button = AnimatedButton(
                                          context,
                                          iconData: FontAwesomeIcons.bars,
                                          onPressed: _handleMenuButton,
                                        );
                                      } else {
                                        button = AnimatedButton(
                                          context,
                                          text: e.value.toString(),
                                          style:
                                              LayoutConfig(context).boldedStyle,
                                          isEnable: turnState.isAbleToTap,
                                          onPressed: () {
                                            context.read<TurnBloc>().add(
                                                  Tap(keyValue: e.key),
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
                                      cell = Padding(
                                        padding: const EdgeInsets.all(
                                            buttonSpacing / 2),
                                        child: SizedBox(
                                          width: buttonWidth - buttonSpacing,
                                          height: buttonHeight - buttonSpacing,
                                        ),
                                      );
                                    }
                                    // Add gap to the right except for last column
                                    if (c < columns - 1) {
                                      rowChildren.add(Padding(
                                        padding: const EdgeInsets.only(
                                            right: tableGap),
                                        child: cell,
                                      ));
                                    } else {
                                      rowChildren.add(cell);
                                    }
                                  }
                                  // Add gap to the bottom except for last row
                                  if (r < rows - 1) {
                                    tableRows.add(
                                      TableRow(
                                        children: rowChildren,
                                      ),
                                    );
                                    // Add a gap row
                                    tableRows.add(
                                      TableRow(
                                        children: List.generate(
                                          columns,
                                          (_) =>
                                              const SizedBox(height: tableGap),
                                        ),
                                      ),
                                    );
                                  } else {
                                    tableRows.add(
                                      TableRow(
                                        children: rowChildren,
                                      ),
                                    );
                                  }
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
          ),
        ),
      ),
    );
  }

  Future<void> pressReset() async {
    return;
  }

  // Animation event handler
  int? _prevPointForAnimation;
  int? _prevLifeForAnimation;

  void _handleAnimationEvents(BuildContext context, TurnState state) {
    // Track point changes using same pattern as life changes
    final wasPointIncreased =
        _prevPointForAnimation != null && state.point > _prevPointForAnimation!;

    // Track life changes using same pattern as existing life animation
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

    // Update previous values for next comparison
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
