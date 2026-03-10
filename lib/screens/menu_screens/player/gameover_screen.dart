// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:skeleton_core/skeleton_core.dart' hide LoadData;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';

import 'package:nucatch/widgets/admob_banner.dart';
import 'package:nucatch/widgets/game_over_regular.dart';
import 'package:nucatch/widgets/game_over_pick_right.dart';

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
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                // fillOverscroll: true,
                child: DeviceWrapper(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child:
                            turnState.difficultyModel?.isPickRightMode == true
                                ? GameOverPickRight(turnState: turnState)
                                : GameOverRegular(turnState: turnState),
                      ),

                      const SizedBox(
                        height: kSpace4XL,
                      ),
                      const SizedBox(
                        height: kSpaceXS,
                      ),
                      BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
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
                            backgroundBuilder: (context, borderRadius) {
                              return LightningWidget(
                                  baseColor: Theme.of(context).primaryColor,
                                  seed: 'Restart'.hashCode,
                                  borderRadius: borderRadius);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: kSpaceL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Change Difficulty button
                          AnimatedButton(
                            context,
                            iconData: Helper.getIconFromDifficulty(
                              context,
                              turnState.difficultyModel?.difficulty,
                            ),
                            backgroundColor: Helper.getColorIconFromDifficulty(
                              context,
                              turnState.difficultyModel?.difficulty,
                            ),
                            text: coreLang(context).difficultySetting,
                            shapeAt: RoundedWithShapeAt.topLeft,
                            buttonSize: ButtonSize.smallest,
                            onPressed: () {
                              playerNavCubit.selectPlayMode(
                                PlayMode.solo,
                              );
                            },
                            backgroundBuilder: (context, borderRadius) {
                              return LightningWidget(
                                baseColor: Helper.getColorIconFromDifficulty(
                                  context,
                                  turnState.difficultyModel?.difficulty,
                                ),
                                seed: coreLang(context)
                                    .difficultySetting
                                    .hashCode,
                                borderRadius: borderRadius,
                              );
                            },
                          ),
                          const SizedBox(width: kSpaceM),
                          // Main Menu button
                          AnimatedButton(
                            context,
                            iconData: FontAwesomeIcons.bars,
                            text: coreLang(context).mainMenu,
                            shapeAt: RoundedWithShapeAt.topRight,
                            buttonSize: ButtonSize.smallest,
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
                      const SizedBox(
                        height: kSpace4XL,
                      ),
                      // AdMob Banner Ad
                      AdMobBanner(
                        adUnitId: Platform.isIOS
                            ? AdMobConfig.iosGameOverBannerId
                            : AdMobConfig.androidGameOverBannerId,
                        useTestAds: AdMobConfig.useTestAds,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
