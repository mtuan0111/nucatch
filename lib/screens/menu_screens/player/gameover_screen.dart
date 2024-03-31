import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'dart:math' as math;

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
        decoration: LayoutConfig.gradientDecoration(context),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Gameover",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Correct ${turnBloc.state.expect}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.ranking,
    required this.playerName,
    required this.createdAt,
    required this.turnedPoint,
  });

  final int ranking;
  final String playerName;
  final DateTime createdAt;
  final int turnedPoint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: LayoutConfig.boxSize,
          height: LayoutConfig.boxSize,
          child: Stack(
            children: [
              Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  width: LayoutConfig.boxSize,
                  height: LayoutConfig.boxSize,
                  decoration: LayoutConfig.boxDecoration.copyWith(
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Transform.rotate(
                angle: -math.pi / 2,
                child: Container(
                  width: LayoutConfig.boxSize,
                  height: LayoutConfig.boxSize,
                  decoration: LayoutConfig.boxDecoration.copyWith(
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  ranking.toString(),
                  style: LayoutConfig.displaySmallStyle(
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playerName,
              style: LayoutConfig.displaySmallStyle(context),
            ),
            Text(
              createdAt.toString(),
            ),
            Text(
              "Point $turnedPoint",
              style: LayoutConfig.titleMediumStyle(context),
            ),
          ],
        )
      ],
    );
  }
}
