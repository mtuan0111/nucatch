import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/top_score_nav_types.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide
        TopScoreNavCubit,
        TopScoreNavState,
        TopScoreRootState,
        TopScoreDetailState;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TopScoreDetailScreen extends StatefulWidget {
  const TopScoreDetailScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<TopScoreDetailScreen> createState() => _TopScoreDetailScreenState();
}

class _TopScoreDetailScreenState extends State<TopScoreDetailScreen> {
  String get screenTitle => widget.title;

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

  // Auth services for getting current user ID
  final AuthServices _authServices = AuthServices();

  // Get current user Firebase ID
  String? get _currentUserId =>
      _authServices.currentUser?.uid ?? _authServices.offlineUserId;

  // Check if current user is the owner of this record
  bool get isCurrentUser =>
      _currentUserId != null &&
      turnRecordedModel.firebaseUserId == _currentUserId;

  // Get period text for display
  String _getPeriodText() {
    switch (topScoreDetailState.period) {
      case RankingPeriod.daily:
        return lang(context).daily;
      case RankingPeriod.weekly:
        return lang(context).weekly;
      case RankingPeriod.all:
        return lang(context).allTime;
    }
  }

  // Get filter context text
  String _getFilterContext() {
    return topScoreDetailState.isPersonalView
        ? coreLang(context).personal
        : coreLang(context).global;
  }

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
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // SliverAppBar(
                    //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    //   shadowColor: Colors.transparent,
                    //   backgroundColor: Colors.transparent,
                    //   pinned: true,
                    //   stretch: true,
                    //   flexibleSpace: LayoutBuilder(
                    //     builder:
                    //         (BuildContext context, BoxConstraints constraints) {
                    //       final double appBarHeight =
                    //           constraints.biggest.height;
                    //       final bool isCollapsed = appBarHeight <=
                    //           kToolbarHeight +
                    //               MediaQuery.of(context).padding.top;

                    //       return AnimatedContainer(
                    //         duration: const Duration(
                    //             milliseconds: kAnimationDurationMedium),
                    //         color: isCollapsed
                    //             ? Theme.of(context).primaryColor
                    //             : Colors.transparent,
                    //         child: FlexibleSpaceBar(
                    //           centerTitle: true,
                    //           titlePadding: EdgeInsets.zero,
                    //           title: Padding(
                    //             padding: const EdgeInsets.all(10.0),
                    //             child: Text(
                    //               lang(context).combatMode,
                    //               textAlign: TextAlign.center,
                    //               style: AppTextStyles.displaySmallTitleScreen(
                    //                   context),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    //   leading: IconButton(
                    //     onPressed: () {
                    //       context.read<PlayerNavCubit>().showSelectPlayMode();
                    //     },
                    //     icon: const Icon(FontAwesomeIcons.chevronLeft),
                    //   ),
                    //   expandedHeight: 100,
                    // ),
                    CustomSliverAppBar(
                      title:
                          '${_getPeriodText()} - ${coreLang(context).rank} ${ranking ?? ''} - ${_getFilterContext()}',
                      opacity: state.isCapturing ? 0.0 : 1.0,
                      onBackPressed: () {
                        topScoreCubit.showTopScore();
                      },
                      expandedHeight: 100,
                    ),
                    SliverFillRemaining(
                      child: DeviceWrapper(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RankingItem(
                                    ranking: ranking,
                                    iconData: FontAwesomeIcons.trophy,
                                    heroTag:
                                        "ranking-${turnRecordedModel.turnId}",
                                    titleIcon: Icons.star,
                                    titleText: '${turnRecordedModel.point}',
                                    currentUserLabel: lang(context).you,
                                    infoRows: [
                                      RankingInfoRow(
                                        icon: Icons.person,
                                        text:
                                            turnRecordedModel.playedUsername ??
                                                coreLang(context).anonymous,
                                      ),
                                      RankingInfoRow(
                                        icon: Icons.calendar_today,
                                        text: turnRecordedModel.recordedTime
                                            .formatClient()
                                            .replaceFirst(' ', '\n'),
                                      ),
                                      RankingInfoRow(
                                        icon: Helper.getIconFromDifficulty(
                                            context,
                                            turnRecordedModel.difficulty),
                                        text: Helper.getTitleFromDifficulty(
                                            context,
                                            turnRecordedModel.difficulty),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: kSpace3XL),
                                  CustomElevatedButton(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kPaddingXL),
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
                                          const SizedBox(height: kSpaceM),
                                          SizedBox(
                                            height: 180,
                                            width: 180,
                                            child: QrImageView(
                                              data: state.secureLink,
                                              version: QrVersions.auto,
                                              size: kIconSizeS,
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
                            const SizedBox(height: kSpace2XL),
                            // Share button - only visible if user owns this record
                            if (isCurrentUser)
                              Expanded(
                                flex: 1,
                                child: Opacity(
                                  opacity: state.isCapturing ? 0.0 : 1.0,
                                  child: IntrinsicWidth(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedButton(
                                          context,
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
                                              //         coreLang(context).anonymous,
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
                                          text: coreLang(context).share,
                                          iconData: FontAwesomeIcons.shareNodes,
                                          backgroundBuilder:
                                              (context, borderRadius) {
                                            return LightningWidget(baseColor: Theme.of(context)
                                                    .primaryColor, seed: coreLang(context)
                                                    .share
                                                    .hashCode, borderRadius: borderRadius);
                                          },
                                          buttonSize: ButtonSize.small,
                                        ),
                                      ],
                                    ),
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
              ),
            );
          }),
        );
      },
    );
  }
}
