// ignore: unused_import
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/widgets/countdown_overlay.dart';
import 'package:nucatch/widgets/countdown_bar.dart';
import 'package:nucatch/widgets/pick_right_mode_controls.dart';
import 'package:nucatch/widgets/regular_mode_controls.dart';


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

  // Track which character indices have triggered fireworks
  final Set<int> _triggeredFireworkIndices = {};

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

  // Removed: boldedStyleFont - now using AppTextStyles.forChallenge()

  @override
  void initState() {
    // turnRecordedListBloc.add(LoadData());

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

  bool _isMenuShowing = false;

  void _handleMenuButton() {
    // If menu is already showing, do nothing
    if (_isMenuShowing) return;

    // Mark menu as showing
    _isMenuShowing = true;

    // Pause timer when menu opens
    turnBloc.add(TapTimerPause());

    Helper.pressMainMenu(context).then((confirmedMenu) {
      // Mark menu as no longer showing
      _isMenuShowing = false;

      if (confirmedMenu) {
        turnBloc.add(End(
          isCauseGameOver: false,
        ));
        menuBloc.add(
          ShowMenu(),
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
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            // Since canPop is false, didPop will always be false
            // Always trigger menu button when back is pressed
            // _handleMenuButton();
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

                return Stack(
                  children: [
                    Container(
                      decoration: LayoutConfig(context).gradientDecoration,
                      child: SafeArea(
                        child: DeviceWrapper(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    CountDownBar(
                                      timerDuration:
                                          turnState.effectiveTimerDuration,
                                      tapTimerRemaining:
                                          turnState.tapTimerRemaining.toInt(),
                                      isPlaying: turnState.status ==
                                          TurnStatus.playing,
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                        "${coreLang(context).level}: ",
                                                    style: AppTextStyles
                                                        .bodyLargeBold(context),
                                                  ),
                                                  TextSpan(
                                                    text: turnState
                                                        .levelAndTimeCorrect,
                                                    style:
                                                        AppTextStyles.bodyLarge(
                                                            context),
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
                                              "${coreLang(context).score}: ",
                                              style:
                                                  AppTextStyles.bodyLargeBold(
                                                      context),
                                            ),
                                            Text(
                                              "${turnState.point}",
                                              style: AppTextStyles.bodyLarge(
                                                  context),
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

                                          // Update current life remaining for both increases and decreases
                                          if (wasLifeIncreased ||
                                              wasLifeDecreased) {
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
                                                        _currentLifeRemaining -
                                                            1;

                                                    bool shouldAnimateAdd =
                                                        wasLifeIncreased &&
                                                            isLast;
                                                    bool shouldAnimateRemove =
                                                        wasLifeDecreased &&
                                                            isLast;

                                                    if (isLast) {
                                                      // Handle last life icon specific logic
                                                      dev.log(
                                                          "message: Last life icon at index $index, shouldAnimateAdd: $shouldAnimateAdd, shouldAnimateRemove: $shouldAnimateRemove");
                                                    }

                                                    if (shouldAnimateAdd) {
                                                      return TweenAnimationBuilder<
                                                          double>(
                                                        tween: Tween<double>(
                                                            begin: 0.0,
                                                            end: 1.0),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve:
                                                            Curves.elasticOut,
                                                        onEnd: () {},
                                                        builder: (context,
                                                            value, child) {
                                                          return Transform
                                                              .scale(
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
                                                            begin: 1.0,
                                                            end: 0.0),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.elasticIn,
                                                        onEnd: () async {
                                                          await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                          ).then((_) {
                                                            wasLifeDecreased =
                                                                false;
                                                            shouldAnimateRemove =
                                                                false;
                                                            if (mounted) {
                                                              setState(() {
                                                                _currentLifeRemaining =
                                                                    _prevLifeRemaining ??
                                                                        _currentLifeRemaining;
                                                              });
                                                            }
                                                          });
                                                          // setState(() {
                                                          //   _currentLifeRemaining =
                                                          //       _prevLifeRemaining ??
                                                          //           _currentLifeRemaining;
                                                          // });
                                                        },
                                                        builder: (context,
                                                            value, child) {
                                                          return Transform
                                                              .scale(
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

                                    if (turnState.isShowExpect &&
                                        turnState.difficultyModel
                                                ?.isPickRightMode !=
                                            true)
                                      Expanded(
                                        child: Center(
                                          child: Wrap(
                                            children: List.generate(
                                              turnState
                                                  .requirementString!.length,
                                              (index) {
                                                String inputted = turnState
                                                    .requirementString![index];
                                                return SizedBox(
                                                  width: (AppTextStyles
                                                              .forChallenge(
                                                                  turnState
                                                                      .requirementString!
                                                                      .length,
                                                                  context)
                                                          .fontSize! *
                                                      0.65),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        inputted,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTextStyles
                                                            .forChallenge(
                                                          turnState
                                                              .requirementString!
                                                              .length,
                                                          context,
                                                        ).copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
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
                                    if (turnState.isTimeForTyping &&
                                        turnState.difficultyModel
                                                ?.isPickRightMode !=
                                            true)
                                      Expanded(
                                        child: Center(
                                          child: Wrap(
                                            children: List.generate(
                                              turnState.expect!.length,
                                              (index) {
                                                double hide = turnState
                                                            .isTypingNotEmpty &&
                                                        index <
                                                            turnState
                                                                .typing.length
                                                    ? 1
                                                    : 0;

                                                String inputted =
                                                    turnState.expect![index];

                                                return SizedBox(
                                                  width: (AppTextStyles
                                                              .forChallenge(
                                                                  turnState
                                                                      .requirementString!
                                                                      .length,
                                                                  context)
                                                          .fontSize! *
                                                      0.65),
                                                  child: Builder(
                                                    builder: (context) {
                                                      // Trigger firework when finished
                                                      // Only trigger once per character index
                                                      if (turnState
                                                              .isFinishTarget &&
                                                          hide == 1 &&
                                                          !_triggeredFireworkIndices
                                                              .contains(
                                                                  index)) {
                                                        _triggeredFireworkIndices
                                                            .add(index);
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          final RenderBox?
                                                              renderBox =
                                                              context.findRenderObject()
                                                                  as RenderBox?;
                                                          if (renderBox !=
                                                              null) {
                                                            final position = renderBox
                                                                .localToGlobal(
                                                                    Offset
                                                                        .zero);
                                                            final size =
                                                                renderBox.size;
                                                            final center = position +
                                                                Offset(
                                                                    size.width /
                                                                        2,
                                                                    size.height /
                                                                        2);

                                                            // Delay each firework slightly for cascading effect
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        index *
                                                                            50),
                                                                () {
                                                              if (mounted &&
                                                                  _animationKey
                                                                          .currentState !=
                                                                      null) {
                                                                // Per-character cascade: lightning only
                                                                // Full firework fires via _handleAnimationEvents on level-up
                                                                _animationKey
                                                                    .currentState!
                                                                    .triggers
                                                                    .onLightningOnly(
                                                                        center);
                                                              }
                                                            });
                                                          }
                                                        });
                                                      } else if (!turnState
                                                          .isFinishTarget) {
                                                        // Reset set when starting a new turn
                                                        _triggeredFireworkIndices
                                                            .clear();
                                                      }

                                                      return Column(
                                                        children: [
                                                          AnimatedOpacity(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            opacity: hide,
                                                            child:
                                                                AnimatedOpacity(
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
                                                              child:
                                                                  AnimatedScale(
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
                                                                  style: AppTextStyles
                                                                      .forChallenge(
                                                                    turnState
                                                                        .requirementString!
                                                                        .length,
                                                                    context,
                                                                  ).copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          AnimatedOpacity(
                                                            opacity: (hide == 0)
                                                                ? 1
                                                                : 0,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .minus,
                                                              color: Theme.of(
                                                                      context)
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

                                    if (turnState
                                            .difficultyModel?.isPickRightMode ==
                                        true) ...[
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            lang(context).whichOneIsCorrect,
                                            style: AppTextStyles.titleLarge(
                                                context),
                                          ),
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                              // Tap Timer Progress Bar

                              Expanded(
                                flex: 2,
                                child: turnState
                                            .difficultyModel?.isPickRightMode ==
                                        true
                                    ? PickRightModeControls(
                                        turnState: turnState,
                                        animationKey: _animationKey,
                                        onMenuPressed: _handleMenuButton,
                                      )
                                    : RegularModeControls(
                                        turnState: turnState,
                                        keyboardArray: keyboardArray,
                                        onMenuPressed: _handleMenuButton,
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (turnState.status == TurnStatus.intro)
                      CountdownOverlay(seconds: turnState.countDown),
                    // Quick settings overlay — always accessible, not affected by layout
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
                                  _QuickSettingButton(
                                    icon: settingState.isMuted
                                        ? FontAwesomeIcons.volumeXmark
                                        : settingState.vol > 7
                                            ? FontAwesomeIcons.volumeHigh
                                            : settingState.vol > 4
                                                ? FontAwesomeIcons.volumeLow
                                                : settingState.vol > 0
                                                    ? FontAwesomeIcons.volumeOff
                                                    : FontAwesomeIcons.volumeXmark,
                                    onTap: () {
                                      context.read<SettingBloc>().add(
                                            ToggleMute(),
                                          );
                                    },
                                    isActive: !settingState.isMuted,
                                  ),
                                  const SizedBox(height: kSpaceXS),
                                  // Vibration toggle
                                  _QuickSettingButton(
                                    icon: settingState.isVibrate
                                        ? FontAwesomeIcons.mobileScreenButton
                                        : FontAwesomeIcons.mobile,
                                    onTap: () {
                                      context.read<SettingBloc>().add(
                                            ChangedIsVibrate(
                                              isVibrate: !settingState.isVibrate,
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
                  ],
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
  int? _prevLevelForAnimation;

  void _handleAnimationEvents(BuildContext context, TurnState state) {
    // Track point changes using same pattern as life changes
    final wasPointIncreased =
        _prevPointForAnimation != null && state.point > _prevPointForAnimation!;

    // Track level changes (level-up = firework; correct answer only = lightning)
    final wasLevelIncreased = _prevLevelForAnimation != null &&
        state.level > _prevLevelForAnimation!;

    // Track life changes using same pattern as existing life animation
    final wasLifeIncreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining > _prevLifeForAnimation!;
    final wasLifeDecreasedForAnimation = _prevLifeForAnimation != null &&
        state.lifeRemaining < _prevLifeForAnimation!;

    // Trigger animation based on what happened:
    if (wasPointIncreased) {
      final scorePosition = _getWidgetPosition(_scoreKey);
      if (wasLevelIncreased) {
        // Level-up: full firework explosion
        _animationKey.currentState?.triggers.onAddPoint(scorePosition);
      } else {
        // Correct answer only: lightning glow without explosion
        _animationKey.currentState?.triggers.onLightningOnly(scorePosition);
      }
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
      child: Icon(
        FontAwesomeIcons.solidStar,
        color: Theme.of(context).colorScheme.onPrimary,
        size: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
    );
  }
}

/// Small semi-transparent toggle button used in the quick settings overlay
class _QuickSettingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _QuickSettingButton({
    required this.icon,
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: isActive ? 0.6 : 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 14,
            color: color.withValues(alpha: isActive ? 1.0 : 0.35),
          ),
        ),
      ),
    );
  }
}
