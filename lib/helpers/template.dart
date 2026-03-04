import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';

import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/models/turn_record_model.dart';

/// Re-export all generic template widgets from skeleton_core
export 'package:skeleton_core/src/widgets/template_widgets.dart';

// ============================================================================
// Nucatch-specific widgets (not migrated to skeleton_core)
// ============================================================================

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.turnRecordedModel,
    required this.ranking,
    this.iconData,
    this.isCurrentUser = false,
    this.heroTagSuffix,
  });

  final TurnRecordedModel? turnRecordedModel;
  final int? ranking;
  final IconData? iconData;
  final bool isCurrentUser;
  final String? heroTagSuffix;

  String? get playerName => turnRecordedModel?.playedUsername;
  DateTime get createdAt => turnRecordedModel?.recordedTime ?? DateTime.now();
  int get turnedPoint => turnRecordedModel?.point ?? 0;
  Difficulty get difficulty => turnRecordedModel?.difficulty ?? Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ranking-${turnRecordedModel!.turnId}${heroTagSuffix ?? ''}",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          if (ranking != null)
            Expanded(
              flex: 2,
              child: RankingSortingWidget(
                position: ranking!,
              ),
            )
          else
            Expanded(
              flex: 2,
              child: RankingSortingWidget(
                position: 0,
                childElement: Icon(iconData),
              ),
            ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RankingInfoRow(
                      icon: Icons.star,
                      text: turnedPoint.toString(),
                      style: AppTextStyles.titleLarge(context),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: kSpaceS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPaddingXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(kBorderRadiusS),
                        ),
                        child: Text(
                          lang(context).you,
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                RankingInfoRow(
                  icon: Icons.person,
                  text: playerName ?? lang(context).anonymous,
                ),
                RankingInfoRow(
                  icon: Icons.calendar_today,
                  text: createdAt.formatClient().replaceFirst(
                      ' ', '\n'), // Split date and time into 2 lines
                ),
                RankingInfoRow(
                  icon: Helper.getIconFromDifficulty(context, difficulty),
                  text: Helper.getTitleFromDifficulty(context, difficulty),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RankingInfoRow extends StatelessWidget {
  const RankingInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.style,
    this.color,
  });

  final IconData icon;
  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: Theme.of(context).textTheme.titleLarge?.fontSize,
          color: color ?? Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(width: kSpaceM),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: (style ?? AppTextStyles.bodyLarge(context)),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
