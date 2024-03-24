import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  TurnBloc get turnBloc => BlocProvider.of<TurnBloc>(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Gameover",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Correct ${turnBloc.state.expect}",
                    ),
                    Text(
                      "Point ${turnBloc.state.point}",
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TurnBloc>(context).add(
                          Restart(),
                        );
                      },
                      child: const Icon(
                        FontAwesomeIcons.arrowRotateLeft,
                      ),
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
