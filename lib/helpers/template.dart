import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              Center(
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Container(
                    width: LayoutConfig.boxSize + 20,
                    height: LayoutConfig.boxSize + 20,
                    decoration: LayoutConfig(context).boxDecoration.copyWith(
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                  ),
                ),
              ),
              // Transform.rotate(
              //   angle: -math.pi / 2,
              //   child: Container(
              //     width: LayoutConfig.boxSize,
              //     height: LayoutConfig.boxSize,
              //     decoration: LayoutConfig(context).boxDecoration.copyWith(
              //           border: Border.all(
              //             width: 2,
              //             color: Theme.of(context).scaffoldBackgroundColor,
              //           ),
              //         ),
              //   ),
              // ),
              Positioned(
                // top: 0,
                // right: 0,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.certificate,
                    color: Theme.of(context).primaryColor,
                    size: LayoutConfig.boxSize,
                  ),
                ),
              ),
              if (ranking == 1)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    FontAwesomeIcons.trophy,
                    color: Colors.amber,
                    size: 30, // Increased size for a bigger icon
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                const SizedBox(width: 5),
                Text(
                  playerName,
                  style: LayoutConfig(context).titleSectionStyle(),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                const SizedBox(width: 5),
                Text(
                  createdAt.formatClient(),
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                const SizedBox(width: 5),
                Text(
                  "${lang(context).score}: $turnedPoint",
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double opacity;
  final String? text;
  final IconData? icon;
  final Color? color;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    this.child,
    this.opacity = 1.0,
    this.text,
    this.icon,
    this.color,
  }) : super(key: key);

  Widget children(context) {
    if (text != null) {
      return Text(
        text!,
        style: LayoutConfig(context)
            .displaySmallStyle(
                // fontFamily: 'Lobster',
                // fontSizeDelta: 1,
                )
            .copyWith(
              color: color ?? Theme.of(context).secondaryHeaderColor,
            ),
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        color: color ?? Theme.of(context).secondaryHeaderColor,
        size: LayoutConfig(context).displaySmallStyle().fontSize,
      );
    }
    return child ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        style: LayoutConfig.elevatedButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(
            Theme.of(context).primaryColor,
          ),
          // shape: WidgetStateProperty.all(
          //   RoundedRectangleBorder(
          //     borderRadius:
          //         BorderRadius.circular(LayoutConfig.layoutBorderRadius),
          //   ),
          // ),
        ),
        onPressed: onPressed,
        child: children(context),
      ),
    );
  }
}

// Widget buttonWidget(
//   BuildContext context, {
//   required String text,
//   required Function onTap,
//   Color? color,
//   Color? textColor,
// }) {
//   return GestureDetector(
//     onTap: () {
//       onTap();
//     },
//     child: SizedBox(
//       width: LayoutConfig.boxSize,
//       height: LayoutConfig.boxSize,
//       child: Stack(
//         children: [
//           Transform.rotate(
//             angle: -math.pi / 4,
//             child: Container(
//               width: LayoutConfig.boxSize,
//               height: LayoutConfig.boxSize,
//               decoration: LayoutConfig(context).boxDecoration.copyWith(
//                     border: Border.all(
//                       width: 2,
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                     ),
//                   ),
//             ),
//           ),
//           // Transform.rotate(
//           //   angle: -math.pi / 2,
//           //   child: Container(
//           //     width: LayoutConfig.boxSize,
//           //     height: LayoutConfig.boxSize,
//           //     decoration: LayoutConfig(context).boxDecoration.copyWith(
//           //           border: Border.all(
//           //             width: 2,
//           //             color: Theme.of(context).scaffoldBackgroundColor,
//           //           ),
//           //         ),
//           //   ),
//           // ),
//           // Positioned(
//           //   // top: 0,
//           //   // right: 0,
//           //   child: Center(
//           //     child: Icon(
//           //       FontAwesomeIcons.certificate,
//           //       color: Theme.of(context).primaryColor,
//           //       size: LayoutConfig.boxSize,
//           //     ),
//           //   ),
//           // ),

//           Center(
//             child: Text(
//               text,
//               style: LayoutConfig(context).displaySmallStyle(),
//             ),
//           ),
//         ],
//       ),
//     ),
//     // const SizedBox(
//     //   width: 20,
//     // ),
//   );
// }
