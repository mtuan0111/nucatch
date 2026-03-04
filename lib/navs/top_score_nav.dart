import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide TopScoreNavCubit, TopScoreNavState, TopScoreRootState, TopScoreDetailState;
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_state.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/screens/menu_screens/top_score_details_screen.dart';
import 'package:nucatch/screens/menu_screens/top_score_screen.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';

class TopScoreNav extends StatefulWidget {
  const TopScoreNav({super.key});

  @override
  State<TopScoreNav> createState() => _TopScoreNavState();
}

class _TopScoreNavState extends State<TopScoreNav> {
  TopScoreNavCubit get topScoreCubit => context.read<TopScoreNavCubit>();
  TopScoreNavState get topScoreState => topScoreCubit.state;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopScoreNavCubit, TopScoreNavState>(
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
            MaterialPage(
              child: TopScoreScreen(
                title: menuArray(context)[MenuOption.topScore]!['text']!,
              ),
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
                  child: TopScoreDetailScreen(
                    title: menuArray(context)[MenuOption.topScore]!['text']!,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
