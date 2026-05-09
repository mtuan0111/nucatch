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

  const NucatchRankingItem({
    super.key,
    required this.turnRecordedModel,
    this.ranking,
    required this.heroTag,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return RankingItem(
      ranking: ranking,
      iconData: FontAwesomeIcons.trophy,
      heroTag: heroTag,
      currentUserLabel: lang(context).you,
      isCurrentUser: isCurrentUser,
      infoRows: [
        RankingInfoRow(
          icon: Icons.person,
          text: turnRecordedModel.playedUsername ?? coreLang(context).anonymous,
        ),
        RankingInfoRow(
          icon: Icons.calendar_today,
          text: turnRecordedModel.recordedTime
              .formatClient()
              .replaceFirst(' ', '\n'),
        ),
        RankingInfoRow(
          icon: Helper.getIconFromDifficulty(
              context, turnRecordedModel.difficulty),
          text: Helper.getTitleFromDifficulty(
              context, turnRecordedModel.difficulty),
        ),
        RankingInfoRow(
          icon: Icons.star_rounded,
          text: turnRecordedModel.point.toString(),
        ),
      ],
    );
  }
}
