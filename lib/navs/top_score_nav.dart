import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_cubit.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_state.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/screens/menu_screens/top_score_details_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';

class TopScoreNav extends StatefulWidget {
  const TopScoreNav({super.key});

  @override
  State<TopScoreNav> createState() => _TopScoreNavState();
}

class _TopScoreNavState extends State<TopScoreNav> {
  TopScoreCubit get topScoreCubit => context.read<TopScoreCubit>();
  TopScoreState get topScoreState => topScoreCubit.state;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopScoreCubit, TopScoreState>(
      builder: (context, state) {
        return Navigator(
          // onPopPage: (route, result) {
          //   context.read<TopScoreCubit>().showTopScore();
          //   return route.didPop(result);
          // },
          // onGenerateRoute: (routeSettings) {
          //   return MaterialPageRoute(
          //     builder: (context) {
          //       return const TopScoreScreen();
          //     },
          //   );
          // },
          // onGenerateInitialRoutes: (navigator, initialRoute) {
          //   return [
          //     MaterialPageRoute(
          //       builder: (context) {
          //         return const TopScoreScreen();
          //       },
          //     ),
          //     if (state is TopScoreDetailState)
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return const TopScoreDetailScreen();
          //         },
          //       ),
          //   ];
          // },
          onDidRemovePage: (page) async {
            if ((page as MaterialPage).child is TopScoreScreen) {
              // await Future.delayed(const Duration(seconds: 1));
              return context.read<MenuBloc>().add(ShowMenu());
            }
            // if (state is TopScoreRootState) {
            //   context.read<MenuBloc>().add(ShowMenu());
            //   return;
            // } else {}
          },

          // onPopPage: (route, result) {
          //   if (state is TopScoreRootState) {
          //     // context.read<MenuBloc>().add(ShowMenu());
          //     context.read<MenuBloc>().add(ShowMenu());
          //   }
          //   return route.didPop(result);
          // },

          pages: [
            const MaterialPage(
              child: TopScoreScreen(),
            ),
            if (state is TopScoreDetailState)
              MaterialPage(
                child: BlocProvider(
                  create: (context) {
                    return TurnRecordedBloc(
                      TurnRecordedState(
                        model: state.turnRecordedModel,
                      ),
                    );
                  },
                  child: const TopScoreDetailScreen(),
                ),
              ),
          ],
        );
      },
    );
  }
}
