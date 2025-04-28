import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/helpers/extension.dart';

import 'package:nucatch_with_bloc/helpers/template.dart';
import 'package:nucatch_with_bloc/navs/menu_nav.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  UserBloc get userBloc => context.read<UserBloc>();

  TurnBloc get turnBloc => context.read<TurnBloc>();
  TurnState get turnState => turnBloc.state;

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;

  @override
  void initState() {
    // TODO: implement initState
    turnRecordedListBloc.add(
      LoadData(),
    );

    // await _onSaveRecorded(SaveRecorded(savingRecord: itemModel), emitter);
    turnBloc.add(SaveRecorded(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang(context).gameOver,
                      style: LayoutConfig(context).displaySmallStyle(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${lang(context).theCorrectIs} ${turnState.expect}",
                      style: LayoutConfig(context).contentSectionStyle(),
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
                          playerName: turnState.recordedItem!.playedUsername ??
                              lang(context).anonymous,
                          createdAt: turnState.recordedItem!.recordedTime,
                          turnedPoint: turnState.recordedItem!.point,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: buttonSpace,
                      runSpacing: buttonSpace,
                      children: [
                        SizedBox(
                          width: (screenWidth / 3) - buttonSpace * 2,
                          height: (screenWidth / 3) - buttonSpace * 2,
                          child: BlocBuilder<TurnRecordedListBloc,
                              TurnRecordedListState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                style: LayoutConfig.elevatedButtonStyle,
                                onPressed: () {
                                  turnBloc.add(
                                    Start(),
                                  );
                                },
                                child: Icon(
                                  FontAwesomeIcons.arrowRotateLeft,
                                  size: buttonStyle.fontSize,
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
