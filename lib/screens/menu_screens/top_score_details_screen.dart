import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_cubit.dart';
import 'package:nucatch/blocs/navs/top_score/top_score_nav_state.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TopScoreDetailScreen extends StatefulWidget {
  const TopScoreDetailScreen({super.key});

  @override
  State<TopScoreDetailScreen> createState() => _TopScoreDetailScreenState();
}

class _TopScoreDetailScreenState extends State<TopScoreDetailScreen> {
  String get screenTitle => menuArray(context)[MenuOption.topScore]!;

  TopScoreNavCubit get topScoreCubit => context.read<TopScoreNavCubit>();
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
  late GlobalKey rankingKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnRecordedBloc, TurnRecordedState>(
      builder: (context, state) {
        return Scaffold(
          // appBar: AppBar(),
          body: WidgetToImage(builder: (key) {
            rankingKey = key;
            return Container(
              decoration: LayoutConfig(context).gradientDecoration,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: Opacity(
                      opacity: state.isCapturing ? 0.0 : 1.0,
                      child: LayoutBuilder(
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
                    ),
                    leading: Opacity(
                      opacity: state.isCapturing ? 0.0 : 1.0,
                      child: IconButton(
                        onPressed: () {
                          topScoreCubit.showTopScore();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.chevronLeft,
                        ),
                      ),
                    ),
                    expandedHeight: 100,
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RankingItem(
                                  ranking: ranking,
                                  turnRecordedModel: turnRecordedModel,
                                ),
                                const SizedBox(height: 32),
                                Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          lang(context).scanQrToViewDetails,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 180,
                                          width: 180,
                                          child: QrImageView(
                                            data: state.secureLink,
                                            version: QrVersions.auto,
                                            size: 180.0,
                                            embeddedImage: const AssetImage(
                                              'assets/images/nuCatch-launcher-512.png',
                                            ),
                                            // 6 modules in a 180x180 QR means each module is 30px,
                                            // so embedded image should be about 6*moduleSize = 36px
                                            embeddedImageStyle:
                                                const QrEmbeddedImageStyle(
                                              size: Size(36, 36),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Opacity(
                              opacity: state.isCapturing ? 0.0 : 1.0,
                              child: Row(
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
                                        shareSubject = lang(context)
                                            .messageSharePlayedLeaderSubjectWithUsername(
                                          userState.username!,
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
                                          objectKey: rankingKey,
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
