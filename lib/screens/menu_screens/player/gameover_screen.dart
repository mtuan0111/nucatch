import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';

import 'package:nucatch_with_bloc/helpers/template.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  UserBloc get userBloc => BlocProvider.of<UserBloc>(context);
  TurnBloc get turnBloc => BlocProvider.of<TurnBloc>(context);

  TurnRecordedListBloc get turnListBloc =>
      BlocProvider.of<TurnRecordedListBloc>(context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;

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
                      "Gameover",
                      style: LayoutConfig(context).displaySmallStyle(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "The correct is ${turnBloc.state.expect}",
                      style: LayoutConfig(context).contentSectionStyle(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
                      builder: (context, state) {
                        return RankingItem(
                          ranking: state.listModel
                                  ?.indexOf(turnBloc.state.recordedItem!) ??
                              1,
                          playerName:
                              turnBloc.state.recordedItem!.playedUsername,
                          createdAt: turnBloc.state.recordedItem!.recordedTime,
                          turnedPoint: turnBloc.state.recordedItem!.point,
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
                          child: ElevatedButton(
                            style: LayoutConfig.elevatedButtonStyle,
                            onPressed: () {
                              BlocProvider.of<TurnBloc>(context).add(
                                Start(),
                              );
                            },
                            child: Icon(
                              FontAwesomeIcons.arrowRotateLeft,
                              size: buttonStyle.fontSize,
                              color: Colors.black87,
                            ),
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
