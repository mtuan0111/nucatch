import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/navs/menu_nav.dart';

class TopScoreScreen extends StatefulWidget {
  const TopScoreScreen({super.key, required this.title});
  final String title;

  @override
  State<TopScoreScreen> createState() => _TopScoreScreenState();
}

class _TopScoreScreenState extends State<TopScoreScreen> {
  String get screenTitle => widget.title;
  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();

  MenuBloc get mainMenuBloc => context.read<MenuBloc>();

  // Track selected tab with enum
  RankingPeriod _selectedPeriod = RankingPeriod.weekly;

  @override
  void initState() {
    // Load all time data initially
    turnRecordedListBloc.add(LoadDataByPeriod(period: _selectedPeriod));
    super.initState();
  }

  void _onTabChanged(RankingPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    turnRecordedListBloc.add(LoadDataByPeriod(period: period));
  }

  String _getPeriodTitle() {
    switch (_selectedPeriod) {
      case RankingPeriod.daily:
        return lang(context).dailyDescription;
      case RankingPeriod.weekly:
        return lang(context).weeklyDescription;
      case RankingPeriod.all:
        return lang(context).allTimeDescription;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
      builder: (context, turnRecordedListState) {
        return Scaffold(
          // appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {
              // Clear cache and reload data for current period
              turnRecordedListBloc.add(
                LoadDataByPeriod(
                  period: _selectedPeriod,
                  isRefresh: true, // This will clear the cache
                ),
              );
            },
            child: Container(
              decoration: LayoutConfig(context).gradientDecoration,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      pinned: true,
                      stretch: true,
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final double appBarHeight =
                              constraints.biggest.height;
                          final bool isCollapsed = appBarHeight <=
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            color: isCollapsed
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            child: FlexibleSpaceBar(
                              centerTitle: true,
                              titlePadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  screenTitle,
                                  textAlign: TextAlign.center,
                                  style:
                                      LayoutConfig(context).displaySmallStyle(
                                    isActiveShadow: true,
                                    isItalic: true,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      leading: IconButton(
                        onPressed: () {
                          mainMenuBloc.add(ShowMenu());
                        },
                        icon: const Icon(
                          FontAwesomeIcons.chevronLeft,
                        ),
                      ),
                      expandedHeight: 100, // Increased to accommodate buttons
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: AnimatedButton(
                                    context,
                                    text: lang(context).daily,
                                    buttonSize: ButtonSize.small,
                                    shapeAt: RoundedWithShapeAt.topLeft,
                                    isActive:
                                        _selectedPeriod == RankingPeriod.daily,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    onPressed: () =>
                                        _onTabChanged(RankingPeriod.daily),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AnimatedButton(
                                    context,
                                    text: lang(context).weekly,
                                    buttonSize: ButtonSize.small,
                                    shapeAt: RoundedWithShapeAt.topRight,
                                    isActive:
                                        _selectedPeriod == RankingPeriod.weekly,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    onPressed: () =>
                                        _onTabChanged(RankingPeriod.weekly),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AnimatedButton(
                                    context,
                                    text: lang(context).allTime,
                                    buttonSize: ButtonSize.small,
                                    shapeAt: RoundedWithShapeAt.bottomLeft,
                                    isActive:
                                        _selectedPeriod == RankingPeriod.all,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    onPressed: () =>
                                        _onTabChanged(RankingPeriod.all),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: _buildRankingList(turnRecordedListState),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankingList(TurnRecordedListState turnRecordedListState) {
    return RefreshIndicator(
      onRefresh: () async {
        // Reload data for current period with cache clearing
        turnRecordedListBloc.add(LoadDataByPeriod(
          period: turnRecordedListState.currentPeriod,
          isRefresh: true, // This will clear the cache
        ));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: SafeArea(
            child: DeviceWrapper(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Period title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      _getPeriodTitle(),
                      style: LayoutConfig(context).titleSectionStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 50,
                    spacing: 50,
                    children: [
                      if (turnRecordedListState.listModel != null &&
                          turnRecordedListState.listModel!.isNotEmpty)
                        ...turnRecordedListState.listModel!.asMap().entries.map(
                          (entry) {
                            int index = entry.key;
                            var e = entry.value;
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<TopScoreNavCubit>()
                                    .showTopScoreDetail(e, index + 1);
                              },
                              child: RankingItem(
                                ranking: index + 1,
                                turnRecordedModel: e,
                              ),
                            );
                          },
                        )
                      else if (!turnRecordedListState.isLoading)
                        Text(
                          lang(context).no_turn_yet,
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                      if (turnRecordedListState.isLoading)
                        const LoadingWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
