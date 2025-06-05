import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_cubit.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_state.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TopScoreDetailScreen extends StatefulWidget {
  const TopScoreDetailScreen({super.key});

  @override
  State<TopScoreDetailScreen> createState() => _TopScoreDetailScreenState();
}

class _TopScoreDetailScreenState extends State<TopScoreDetailScreen> {
  String get screenTitle => menuArray(context)[MenuOption.topScore]!;

  TopScoreCubit get topScoreCubit => context.read<TopScoreCubit>();
  TopScoreDetailState get topScoreDetailState =>
      topScoreCubit.state as TopScoreDetailState;

  TurnRecordedModel get turnRecordedModel =>
      topScoreDetailState.turnRecordedModel;

  int? get ranking => topScoreDetailState.ranking;

  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  // TurnRecordedListBloc get turnRecordedListBloc =>
  //     context.read<TurnRecordedListBloc>();

  TurnRecordedBloc get turnRecordedBloc => context.read<TurnRecordedBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnRecordedListBloc, TurnRecordedListState>(
      builder: (context, turnRecordedListState) {
        return Scaffold(
          // appBar: AppBar(),
          body: Container(
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
                      return const FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        // title: Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Text(
                        //     screenTitle,
                        //     textAlign: TextAlign.center,
                        //     style: LayoutConfig(context).displaySmallStyle(
                        //       isActiveShadow: true,
                        //       isItalic: true,
                        //     ),
                        //   ),
                        // ),
                      );
                    },
                  ),
                  leading: IconButton(
                    onPressed: () {
                      topScoreCubit.showTopScore();
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
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RankingItem(
                            ranking: ranking,
                            turnRecordedModel: turnRecordedModel,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  String shareMessage = '';
                                  String shareSubject = lang(context)
                                      .messageSharePlayedLeaderSubject;

                                  // TODO: Implement share functionality
                                  if (userState.username == null) {
                                    shareMessage = lang(context)
                                        .messageSharePlayedLeaderBodyAnonymousBody(
                                      turnRecordedModel.point,
                                      turnRecordedModel.recordedTime
                                          .formatClient(),
                                    );
                                  } else {
                                    shareMessage = lang(context)
                                        .messageSharePlayedLeaderBody(
                                      userState.username!,
                                      turnRecordedModel.point,
                                      turnRecordedModel.recordedTime
                                          .formatClient(),
                                    );
                                    // Share.share(
                                    //   lang(context).messageSharePlayedLeaderBody(
                                    //     userState.username ??
                                    //         lang(context).anonymous,
                                    //     turnRecordedModel.point,
                                    //     turnRecordedModel.recordedTime
                                    //         .formatClient(),
                                    //   ),
                                    // );
                                  }
                                  turnRecordedBloc.add(
                                    ShareEvent(
                                      message: shareMessage,
                                      subject: shareSubject,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implement challenge functionality
                                },
                                icon: const Icon(Icons.sports_kabaddi),
                                label: const Text('Challenge'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
