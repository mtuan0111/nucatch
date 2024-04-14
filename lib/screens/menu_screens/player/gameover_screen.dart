import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
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
                    RankingItem(
                      ranking: 1,
                      playerName: userBloc.state.model.name,
                      createdAt: DateTime.now(),
                      turnedPoint: turnBloc.state.point,
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
