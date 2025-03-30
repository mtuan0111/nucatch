import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/helpers/template.dart';
import 'package:nucatch_with_bloc/navs/menu_nav.dart';

class TopScoreScreen extends StatefulWidget {
  const TopScoreScreen({super.key});

  @override
  State<TopScoreScreen> createState() => _TopScoreScreenState();
}

class _TopScoreScreenState extends State<TopScoreScreen> {
  String get screenTitle => menuArray[MenuOption.topScore]!;
  @override
  Widget build(BuildContext context) {
    // TurnRecordedListState turnRecordedListState =
    //     BlocProvider.of<TurnRecordedListBloc>(context).state;

    return BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
      builder: (context, turnRecordedListState) {
        return Scaffold(
          // appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<TurnRecordedListBloc>().add(
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
                    // surfaceTintColor: Colors.transparent,
                    backgroundColor: Theme.of(context).primaryColor,

                    pinned: true,
                    stretch: true,

                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          screenTitle,
                          style: LayoutConfig(context).displaySmallStyle(
                            isActiveShadow: true,
                            isItalic: true,
                          ),
                        ),
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(FontAwesomeIcons.chevronLeft),
                    ),
                    expandedHeight: 100,

                    // leading: Expanded(child: Center(child: Text("back"))),
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
                          runAlignment: WrapAlignment.spaceBetween,
                          runSpacing: 50,
                          spacing: 50,
                          children: [
                            ...(turnRecordedListState.listModel
                                    ?.map(
                                      (e) => RankingItem(
                                        ranking:
                                            turnRecordedListState.indexOf(e),
                                        playerName: e.playedUsername,
                                        createdAt: e.recordedTime,
                                        turnedPoint: e.point,
                                      ),
                                    )
                                    .toList() ??
                                List.generate(
                                  5,
                                  (index) => RankingItem(
                                    ranking: index + 1,
                                    playerName: "playerName",
                                    createdAt: DateTime.now(),
                                    turnedPoint: 2,
                                  ),
                                ).toList()),
                            if (turnRecordedListState.isLoading)
                              const LoadingWidget()
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
