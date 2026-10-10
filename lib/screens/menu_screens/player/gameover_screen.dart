// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' show Platform;
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/admob_config.dart';
import 'package:skeleton_core/skeleton_core.dart' hide LoadData;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';

import 'package:nucatch/widgets/game_over_regular.dart';
import 'package:nucatch/widgets/game_over_pick_right.dart';
import 'package:nucatch/widgets/tutorial_overlay.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  UserBloc get userBloc => context.read<UserBloc>();

  TurnBloc get turnBloc => context.read<TurnBloc>();
  TurnState get turnState => turnBloc.state;

  PlayerNavCubit get playerNavCubit => context.read<PlayerNavCubit>();

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;

  @override
  void initState() {
    // await _onSaveRecorded(SaveRecorded(savingRecord: itemModel), emitter);
    // turnBloc.add(SaveRecorded(context: context));

    turnRecordedListBloc.add(
      LoadData(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    // fillOverscroll: true,
                    child: DeviceWrapper(
                      // Any landscape (not just tablet) switches to the 2-pane
                      // layout below, which needs the full screen width.
                      maxWidth: context.isLandscapeOrientation ? 1200 : null,
                      child: Builder(builder: (context) {
                        final resultWidget =
                            turnState.difficultyModel?.isPickRightMode == true
                                ? GameOverPickRight(turnState: turnState)
                                : GameOverRegular(turnState: turnState);

                        final actionButtons = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<TurnRecordedListBloc,
                                TurnRecordedListState>(
                              builder: (context, state) {
                                return AnimatedButton(
                                  context,
                                  onPressed: () {
                                    playerNavCubit.showPlay();

                                    turnBloc.add(
                                      Start(),
                                    );
                                  },
                                  iconData: FontAwesomeIcons.arrowRotateLeft,
                                  // The main action: labelled, and larger
                                  // than the two secondary buttons below.
                                  text: coreLang(context).playAgain,
                                  style: AppTextStyles.titleMediumBold(context),
                                  buttonSize: ButtonSize.medium,
                                  backgroundBuilder: (context, borderRadius) {
                                    return LightningWidget(
                                        baseColor:
                                            Theme.of(context).primaryColor,
                                        seed: 'Restart'.hashCode,
                                        borderRadius: borderRadius);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: kSpaceL),
                            // Wrap, not Row: when a translation makes the
                            // two buttons wider than the screen, the second
                            // drops to its own line instead of squeezing the
                            // labels.
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: kSpaceM,
                              runSpacing: kSpaceM,
                              children: [
                                // Change Difficulty button
                                AnimatedButton(
                                  context,
                                  iconData: Helper.getIconFromDifficulty(
                                    context,
                                    turnState.difficultyModel?.difficulty,
                                  ),
                                  // Secondary, so it takes the standard
                                  // colour: the bright difficulty colour
                                  // drew the eye away from Play Again. The
                                  // icon still names the difficulty.
                                  text: coreLang(context).difficultySetting,
                                  shapeAt: RoundedWithShapeAt.topLeft,
                                  buttonSize: ButtonSize.small,
                                  onPressed: () {
                                    playerNavCubit.selectPlayMode(
                                      PlayMode.solo,
                                    );
                                  },
                                  backgroundBuilder: (context, borderRadius) {
                                    return LightningWidget(
                                      baseColor: Theme.of(context).primaryColor,
                                      seed: coreLang(context)
                                          .difficultySetting
                                          .hashCode,
                                      borderRadius: borderRadius,
                                    );
                                  },
                                ),
                                // Main Menu button
                                AnimatedButton(
                                  context,
                                  iconData: FontAwesomeIcons.bars,
                                  text: coreLang(context).mainMenu,
                                  shapeAt: RoundedWithShapeAt.topRight,
                                  buttonSize: ButtonSize.small,
                                  onPressed: () {
                                    context.read<MenuBloc>().add(ShowMenu());
                                  },
                                  backgroundBuilder: (context, borderRadius) {
                                    return LightningWidget(
                                      baseColor: Theme.of(context).primaryColor,
                                      seed: 'Menu'.hashCode,
                                      borderRadius: borderRadius,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        );

                        final adBanner = AdMobBanner(
                          adUnitId: (!kIsWeb && Platform.isIOS)
                              ? AdMobConfig.instance.iosGameOverBannerId
                              : AdMobConfig.instance.androidGameOverBannerId,
                        );

                        if (context.isLandscapeOrientation) {
                          // 2-pane split: result/stats on the left, all action
                          // buttons on the right — the ad banner stays full
                          // width below both. Scrollable so the largest font sizes
                          // (which push this taller than the short landscape
                          // viewport) scroll instead of overflowing the bottom.
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: resultWidget),
                                      const SizedBox(width: kSpaceXL),
                                      Expanded(child: actionButtons),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: kSpace4XL),
                                adBanner,
                              ],
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: resultWidget),
                            const SizedBox(
                              height: kSpace4XL,
                            ),
                            const SizedBox(
                              height: kSpaceXS,
                            ),
                            actionButtons,
                            const SizedBox(
                              height: kSpace4XL,
                            ),
                            adBanner,
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const TutorialOverlay(),
        ],
      ),
    );
  }
}
