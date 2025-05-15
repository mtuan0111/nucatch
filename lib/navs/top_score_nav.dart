import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_cubit.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_state.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';

class TopScoreNav extends StatefulWidget {
  const TopScoreNav({super.key});

  @override
  State<TopScoreNav> createState() => _TopScoreNavState();
}

class _TopScoreNavState extends State<TopScoreNav> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopScoreCubit, TopScoreState>(
      builder: (context, state) {
        if (state is TopScoreRootState) {
          return const TopScoreScreen();
        } else if (state is TopScoreDetailState) {}
        return const Placeholder();
      },
    );
  }
}
