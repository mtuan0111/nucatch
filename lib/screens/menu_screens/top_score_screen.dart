import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/navs/menu_nav.dart';

class TopScoreScreen extends StatefulWidget {
  const TopScoreScreen({super.key});

  @override
  State<TopScoreScreen> createState() => _TopScoreScreenState();
}

class _TopScoreScreenState extends State<TopScoreScreen> {
  String get screenTitle => menuArray(context)[MenuOption.topScore]!;
  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();

  MenuBloc get mainMenuBloc => context.read<MenuBloc>();

  @override
  void initState() {
    turnRecordedListBloc.add(LoadData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
      builder: (context, turnRecordedListState) {
        return Scaffold(
          // appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {
              turnRecordedListBloc.add(
                LoadData(),
              );
            },
            child: Container(
              decoration: LayoutConfig(context).gradientDecoration,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: EdgeInsets.zero,
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              screenTitle,
                              textAlign: TextAlign.center,
                              style: LayoutConfig(context).displaySmallStyle(
                                isActiveShadow: true,
                                isItalic: true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    leading: IconButton(
                      onPressed: () {
                        mainMenuBloc.add(ShowMenu());
                        // Navigator.pop(context);
                        // Navigator.pop
                      },
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                      ),
                    ),
                    expandedHeight: 100,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                      horizontal: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: IntrinsicWidth(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 50,
                          spacing: 50,
                          children: [
                            if (turnRecordedListState.listModel != null)
                              ...turnRecordedListState.listModel!.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    context
                                        .read<TopScoreNavCubit>()
                                        .showTopScoreDetail(
                                          e,
                                          turnRecordedListState.indexOf(e),
                                        );
                                  },
                                  child: RankingItem(
                                    ranking: turnRecordedListState.indexOf(e),
                                    turnRecordedModel: e,
                                    // playerName: e.playedUsername ??
                                    //     lang(context).anonymous,
                                    // createdAt: e.recordedTime,
                                    // turnedPoint: e.point,
                                  ),
                                ),
                              ),
                            if (turnRecordedListState.isLoading)
                              const LoadingWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
