import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';

import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/navs/menu_nav.dart';

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang(context).gameOver,
                      style: LayoutConfig(context).boldedStyle.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    if (turnState.expect != turnState.requirementString)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          turnState.requirementString ?? '',
                          style: LayoutConfig(context).boldedStyle.copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 24,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lang(context).theCorrectIs,
                          style: LayoutConfig(context)
                              .contentSectionStyle()
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          turnState.expect ?? '',
                          style: LayoutConfig(context).boldedStyle.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
                      builder: (context, state) {
                        if (state.isLoading || turnState.recordedItem == null) {
                          return const LoadingWidget();
                        }

                        int? indexOfItem = state.listModel!
                            .indexOfTurn(turnState.recordedItem!);

                        return RankingItem(
                          ranking: indexOfItem,
                          turnRecordedModel: turnState.recordedItem!,
                          // playerName: turnState.recordedItem!.playedUsername ??
                          //     lang(context).anonymous,
                          // createdAt: turnState.recordedItem!.recordedTime,
                          // turnedPoint: turnState.recordedItem!.point,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
