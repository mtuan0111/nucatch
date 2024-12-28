import 'package:flutter/material.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'dart:math' as math;

import 'package:nucatch_with_bloc/helpers/extension.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.ranking,
    required this.playerName,
    required this.createdAt,
    required this.turnedPoint,
  });

  final int ranking;
  final String playerName;
  final DateTime createdAt;
  final int turnedPoint;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: WrapCrossAlignment.start,
      // alignment: WrapAlignment.start,
      // runAlignment: WrapAlignment.start,

      spacing: 20,
      runSpacing: 20,
      children: [
        SizedBox(
          width: LayoutConfig.boxSize,
          height: LayoutConfig.boxSize,
          child: Stack(
            children: [
              Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  width: LayoutConfig.boxSize,
                  height: LayoutConfig.boxSize,
                  decoration: LayoutConfig(context).boxDecoration.copyWith(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                ),
              ),
              Transform.rotate(
                angle: -math.pi / 2,
                child: Container(
                  width: LayoutConfig.boxSize,
                  height: LayoutConfig.boxSize,
                  decoration: LayoutConfig(context).boxDecoration.copyWith(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                ),
              ),
              Center(
                child: Text(
                  ranking.toString(),
                  style: LayoutConfig(context).displaySmallStyle(),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   width: 20,
        // ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playerName,
              style: LayoutConfig(context).titleSectionStyle(),
            ),
            Text(
              createdAt.formatClient(),
              style: LayoutConfig(context).contentSectionStyle(),
            ),
            Text("Point $turnedPoint",
                style: LayoutConfig(context).contentSectionStyle()),
          ],
        )
      ],
    );
  }
}
