import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/const.dart';
import 'dart:math' as math;

import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/models/turn_record_model.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.turnRecordedModel,
    required this.ranking,
    // required this.playerName,
    // required this.createdAt,
    // required this.turnedPoint,
  });

  final TurnRecordedModel? turnRecordedModel;
  final int? ranking;

  String? get playerName => turnRecordedModel?.playedUsername;
  DateTime get createdAt => turnRecordedModel?.recordedTime ?? DateTime.now();
  int get turnedPoint => turnRecordedModel?.point ?? 0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ranking-${turnRecordedModel!.turnId}",
      child: Wrap(
        key: key,
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: [
          if (ranking != null) RankingSortingWidget(position: ranking!),
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
                    size: Theme.of(context).textTheme.titleLarge!.fontSize,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    playerName ?? lang(context).anonymous,
                    style: LayoutConfig(context).titleSectionStyle(),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: Theme.of(context).textTheme.titleLarge!.fontSize,
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
                    size: Theme.of(context).textTheme.titleLarge!.fontSize,
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
      ),
    );
  }
}

class RankBadge extends StatelessWidget {
  const RankBadge({
    super.key,
    required this.ranking,
  });

  final int ranking;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                FontAwesomeIcons.trophy,
                color: Colors.amber,
                size: Theme.of(context).textTheme.displaySmall!.fontSize!,
                // Increased size for a bigger icon
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
    );
  }
}

class RankingSortingWidget extends StatelessWidget {
  final int position;
  final double wingSize;
  final Widget? childElement;
  final double? size; // Add a size parameter

  const RankingSortingWidget({
    Key? key,
    required this.position,
    this.wingSize = 1,
    this.childElement,
    this.size, // Accept size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = position == 1
        ? theme.cardColor
        : (position > 3 ? theme.canvasColor : theme.canvasColor);
    final strokeColor = theme.primaryColor;

    // Use provided size or fallback to a reasonable default
    final double baseSize = size ?? 60.0;

    Widget buildWing(double width, double height,
        {double opacity = 1.0, EdgeInsets? margin}) {
      return Positioned(
        child: Opacity(
          opacity: opacity,
          child: Container(
            margin: margin,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: strokeColor.withValues(alpha: 0.8),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (position == 1)
          buildWing(baseSize * 2 * wingSize, (baseSize - 20) / 1.2,
              opacity: 0.5, margin: const EdgeInsets.only(top: 20)),
        if (position <= 3)
          buildWing(baseSize * 1.8 * wingSize, (baseSize - 20) / 1.5,
              margin: const EdgeInsets.only(bottom: 10)),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: baseSize - 20,
            minWidth: baseSize * 1.8 * wingSize,
            maxHeight: childElement == null ? baseSize + 10 : baseSize + 40,
          ),
          child: Container(
            alignment: Alignment.center,
            width: baseSize * 1.8 * wingSize,
            height: baseSize * 1.8 * wingSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [fillColor, fillColor, strokeColor],
              ),
              shape: BoxShape.circle,
              border: Border.all(width: baseSize * 0.08, color: strokeColor),
              boxShadow: [
                BoxShadow(
                  color: strokeColor.withValues(alpha: .2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: childElement ??
                Text(
                  position.toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        baseSize / 2.5, // Adjust font size based on widget size
                  ),
                ),
          ),
        ),
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

class MainLogo extends StatelessWidget {
  const MainLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Hero(
      tag: "logo",
      // transitionOnUserGestures: true,
      child: Image(
        height: 160,
        image: AssetImage("assets/images/main-logo.png"),
        fit: BoxFit.contain,
      ),
    );
  }
}

class CustomeTitleButton extends StatelessWidget {
  final String text;
  final Function onTap;
  const CustomeTitleButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: LayoutConfig(context).displaySmallStyle(
            isActiveShadow: true,
            isItalic: true,
          ),
        ),
      ),
    );
  }
}

class WidgetToImage extends StatefulWidget {
  final Function(GlobalKey key) builder;

  const WidgetToImage({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<WidgetToImage> createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  final globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
