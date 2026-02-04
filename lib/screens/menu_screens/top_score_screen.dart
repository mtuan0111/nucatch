import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_event.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:nucatch/services/auth_services.dart';

class TopScoreScreen extends StatefulWidget {
  const TopScoreScreen({super.key, required this.title});
  final String title;

  @override
  State<TopScoreScreen> createState() => _TopScoreScreenState();
}

class _TopScoreScreenState extends State<TopScoreScreen>
    with SingleTickerProviderStateMixin {
  String get screenTitle => widget.title;
  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();

  MenuBloc get mainMenuBloc => context.read<MenuBloc>();

  // Auth services for getting current user ID
  final AuthServices _authServices = AuthServices();

  // Tab controller for period selection
  late TabController _tabController;

  // Track selected tab with enum
  RankingPeriod _selectedPeriod = RankingPeriod.weekly;

  // Get current user Firebase ID
  String? get _currentUserId =>
      _authServices.currentUser?.uid ?? _authServices.offlineUserId;

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with 3 tabs (daily, weekly, all time)
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabChange);

    // Load weekly data initially (matching initial tab)
    // Check filter state and pass userId if filter is enabled
    final settingState = context.read<SettingBloc>().state;
    final userId = settingState.onlyShowMyRecorded ? _currentUserId : null;
    turnRecordedListBloc
        .add(LoadDataByPeriod(period: _selectedPeriod, userId: userId));
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final periods = [
        RankingPeriod.daily,
        RankingPeriod.weekly,
        RankingPeriod.all
      ];
      final newPeriod = periods[_tabController.index];
      if (newPeriod != _selectedPeriod) {
        // Get current filter state
        final settingState = context.read<SettingBloc>().state;
        final userId = settingState.onlyShowMyRecorded ? _currentUserId : null;
        _onTabChanged(newPeriod, userId: userId);
      }
    }
  }

  void _onTabChanged(RankingPeriod period, {String? userId}) {
    setState(() {
      _selectedPeriod = period;
    });
    turnRecordedListBloc.add(LoadDataByPeriod(period: period, userId: userId));
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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
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
              // Get current filter state
              final settingState = context.read<SettingBloc>().state;
              final userId =
                  settingState.onlyShowMyRecorded ? _currentUserId : null;

              // Clear cache and reload data for current period
              turnRecordedListBloc.add(
                LoadDataByPeriod(
                  period: _selectedPeriod,
                  isRefresh: true, // This will clear the cache
                  userId: userId,
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
                            duration: const Duration(
                                milliseconds: kAnimationDurationMedium),
                            color: isCollapsed
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            child: FlexibleSpaceBar(
                              centerTitle: true,
                              titlePadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.all(kPaddingM),
                                child: BlocBuilder<TurnRecordedListBloc,
                                    TurnRecordedListState>(
                                  builder: (context, state) {
                                    return Text(
                                      "$screenTitle ${state.numberOfTopBoard}",
                                      textAlign: TextAlign.center,
                                      style:
                                          AppTextStyles.displaySmallTitleScreen(
                                              context),
                                    );
                                  },
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
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kPaddingXL, vertical: kPaddingXL),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(
                                  LayoutConfig.layoutBorderRadius),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                    LayoutConfig.layoutBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              unselectedLabelColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withValues(alpha: 0.6),
                              labelStyle: AppTextStyles.bodyMediumBold(context),
                              unselectedLabelStyle:
                                  AppTextStyles.bodyMedium(context),
                              tabs: [
                                Tab(text: lang(context).daily),
                                Tab(text: lang(context).weekly),
                                Tab(text: lang(context).allTime),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: BlocBuilder<SettingBloc, SettingState>(
                        builder: (context, settingState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Switch(
                                value: settingState.onlyShowMyRecorded,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (val) {
                                  context.read<SettingBloc>().add(
                                        ChangedOnlyShowMyRecorded(
                                          onlyShowMyRecorded: val,
                                        ),
                                      );

                                  // Reload data with or without userId filter
                                  final userId = val ? _currentUserId : null;
                                  turnRecordedListBloc.add(
                                    LoadDataByPeriod(
                                      period: _selectedPeriod,
                                      userId: userId,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: kSpaceS),
                              Text(
                                lang(context).onlyShowMyRecorded,
                                style: AppTextStyles.bodyLarge(context),
                              ),
                            ],
                          );
                        },
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
                      style: AppTextStyles.titleLarge(context),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  BlocBuilder<SettingBloc, SettingState>(
                    builder: (context, settingState) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 50,
                        spacing: 50,
                        children: [
                          if (turnRecordedListState.listModel != null &&
                              turnRecordedListState.listModel!.isNotEmpty)
                            ...turnRecordedListState.listModel!
                                .asMap()
                                .entries
                                .map(
                              (entry) {
                                int index = entry.key;
                                var e = entry.value;

                                // No UI-level filtering - filtering happens at database query level

                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<TopScoreNavCubit>()
                                        .showTopScoreDetail(
                                          e,
                                          index + 1,
                                          _selectedPeriod,
                                          settingState.onlyShowMyRecorded,
                                        );
                                  },
                                  child: RankingItem(
                                    ranking: index + 1,
                                    turnRecordedModel: e,
                                    isCurrentUser: _currentUserId != null &&
                                        e.firebaseUserId == _currentUserId,
                                    heroTagSuffix:
                                        settingState.onlyShowMyRecorded
                                            ? '-filtered'
                                            : '',
                                  ),
                                );
                              },
                            )
                          else if (!turnRecordedListState.isLoading)
                            Text(
                              lang(context).no_turn_yet,
                              style: AppTextStyles.bodyLarge(context),
                            ),
                          if (turnRecordedListState.isLoading)
                            const LoadingWidget(),
                        ],
                      );
                    },
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
