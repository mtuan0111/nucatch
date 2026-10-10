import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:skeleton_core/skeleton_core.dart';

class NucatchRankingItem extends StatelessWidget {
  final TurnRecordedModel turnRecordedModel;
  final int? ranking;
  final String heroTag;
  final bool isCurrentUser;

  /// False where the score is already shown larger right above the item
  /// (the game-over screen), so it isn't repeated.
  final bool showScore;

  const NucatchRankingItem({
    super.key,
    required this.turnRecordedModel,
    this.ranking,
    required this.heroTag,
    this.isCurrentUser = false,
    this.showScore = true,
  });

  @override
  Widget build(BuildContext context) {
    return RankingItem(
      ranking: ranking,
      iconData: FontAwesomeIcons.trophy,
      heroTag: heroTag,
      currentUserLabel: lang(context).you,
      isCurrentUser: isCurrentUser,
      // The score is what a ranking is about, so it leads, larger and bold;
      // who, mode and when follow as secondary detail.
      infoRows: [
        if (showScore)
          RankingInfoRow(
            icon: FontAwesomeIcons.solidStar,
            text: turnRecordedModel.point.toString(),
            style: AppTextStyles.titleLarge(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        RankingInfoRow(
          icon: FontAwesomeIcons.solidUser,
          text: turnRecordedModel.playedUsername ?? coreLang(context).anonymous,
        ),
        RankingInfoRow(
          icon: Helper.getIconFromDifficulty(
              context, turnRecordedModel.difficulty),
          text: Helper.getTitleFromDifficulty(
              context, turnRecordedModel.difficulty),
        ),
        RankingInfoRow(
          icon: FontAwesomeIcons.solidCalendar,
          text: turnRecordedModel.recordedTime
              .formatClient()
              .replaceFirst(' ', '\n'),
        ),
      ],
    );
  }
}
