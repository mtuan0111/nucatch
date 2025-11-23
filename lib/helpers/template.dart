import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'dart:math' as math;

import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/helper.dart';
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
  Difficulty get difficulty => turnRecordedModel?.difficulty ?? Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ranking-${turnRecordedModel!.turnId}",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: WrapCrossAlignment.center,
        // alignment: WrapAlignment.center,
        // runAlignment: WrapAlignment.center,
        spacing: 20,
        // runSpacing: 20,
        children: [
          if (ranking != null)
            Flexible(
                flex: 1,
                child: RankingSortingWidget(
                  position: ranking!,
                )),
          // const SizedBox(
          //   width: 20,
          // ),
          Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RankingInfoRow(
                  icon: Icons.person,
                  text: playerName ?? lang(context).anonymous,
                  style: LayoutConfig(context).titleSectionStyle(),
                ),
                RankingInfoRow(
                  icon: Icons.calendar_today,
                  text: createdAt.formatClient(),
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
                RankingInfoRow(
                  icon: Icons.star,
                  text: "${lang(context).score}: $turnedPoint",
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
                RankingInfoRow(
                  icon: Helper.getIconFromDifficulty(context, difficulty),
                  text:
                      "${lang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, difficulty)}",
                  style: LayoutConfig(context).contentSectionStyle(),
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
    // super.key,
    required this.icon,
    required this.text,
    required this.style,
    // required this.context,
  });

  final IconData icon;
  final String text;
  final TextStyle style;
  // final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Theme.of(context).textTheme.titleLarge?.fontSize,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        const SizedBox(width: 5),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class Wing extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;
  final Color fillColor;
  final EdgeInsets? margin;
  final double radiusCircle;
  final BorderRadius? borderRadius;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const Wing(
    this.width,
    this.height, {
    super.key,
    this.opacity = 1.0,
    this.fillColor = Colors.white,
    this.margin,
    this.radiusCircle = 50,
    this.borderRadius,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fillColor.getLighter().withValues(alpha: 0.7),
          borderRadius: borderRadius ??
              BorderRadius.vertical(bottom: Radius.circular(radiusCircle)),
          boxShadow: [
            BoxShadow(
              color: fillColor.getDarker().withValues(alpha: 0.8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}

class WingPainter extends CustomPainter {
  final Color color;
  final double opacity;

  WingPainter({required this.color, this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
        alignment: Alignment.center,
        clipBehavior: Clip.none,
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

  final Widget? childElement;
  final double? size; // Add a size parameter

  const RankingSortingWidget({
    Key? key,
    required this.position,
    this.childElement,
    this.size, // Accept size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color fillColor() {
      return switch (position) {
        1 => Colors.pink,
        2 => Colors.blueAccent,
        3 => Colors.green,
        _ => theme.primaryColor,
      };
    }

    Color darkerFillColor = fillColor().getDarker();

    // Use provided size or fallback to a reasonable default
    final double baseSize = size ?? 60.0;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (position == 1)
          Positioned(
            // left: baseSize * 5,
            // right: baseSize * 5,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                // clipBehavior: Clip.none,
                // alignment: WrapAlignment.center,
                // spacing: 0,
                // runSpacing: 0,
                verticalDirection: VerticalDirection.up,
                children: [
                  Flexible(
                    child: Wing(
                      baseSize / 1.5,
                      baseSize,
                      opacity: 0.8,
                      margin: EdgeInsets.only(bottom: baseSize / 2),
                      fillColor: fillColor(),
                      radiusCircle: baseSize / 1.5,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(baseSize / 1.5),
                        bottomLeft: Radius.circular(baseSize),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Wing(
                      baseSize / 1.5,
                      baseSize,
                      opacity: 0.8,
                      margin: EdgeInsets.only(bottom: baseSize / 2),
                      fillColor: fillColor(),
                      radiusCircle: baseSize / 1.5,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(baseSize / 1.5),
                        bottomRight: Radius.circular(baseSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (position <= 2)
          Positioned(
            // left: baseSize * 5,
            // right: baseSize * 5,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                // clipBehavior: Clip.none,
                // alignment: WrapAlignment.center,
                // spacing: 0,
                // runSpacing: 0,
                verticalDirection: VerticalDirection.up,
                children: [
                  Flexible(
                    child: Wing(
                      baseSize / 2,
                      baseSize / 1.5,
                      opacity: 0.8,
                      margin: EdgeInsets.only(top: baseSize / 2),
                      fillColor: fillColor(),
                      radiusCircle: baseSize / 1.5,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(baseSize / 1.5),
                        bottomRight: Radius.circular(baseSize),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Wing(
                      baseSize / 2,
                      baseSize / 1.5,
                      opacity: 0.8,
                      margin: EdgeInsets.only(top: baseSize / 2),
                      fillColor: fillColor(),
                      radiusCircle: baseSize / 1.5,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(baseSize / 1.5),
                        bottomLeft: Radius.circular(baseSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Positioned(
        //   right: baseSize / 1.2,
        //   child: Wing(
        //     baseSize / 1.5,
        //     baseSize,
        //     opacity: 0.8,
        //     margin: EdgeInsets.only(bottom: baseSize / 2),
        //     fillColor: fillColor(),
        //     radiusCircle: baseSize / 1.5,
        //     borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(baseSize / 1.5),
        //       bottomLeft: Radius.circular(baseSize),
        //     ),
        //   ),
        // ),

        if (position <= 3)
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Wing(
                    baseSize * 1.2,
                    baseSize / 1.5,
                    opacity: 0.8,
                    margin: EdgeInsets.only(bottom: 0),
                    fillColor: fillColor(),
                    radiusCircle: baseSize / 1.5,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(baseSize / 1.5),
                      bottomLeft: Radius.circular(baseSize / 1.5),
                    ),
                  ),
                ),
                Flexible(
                  child: Wing(
                    baseSize * 1.2,
                    baseSize / 1.5,
                    opacity: 0.8,
                    margin: EdgeInsets.only(bottom: 0),
                    fillColor: fillColor(),
                    radiusCircle: baseSize / 1.5,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(baseSize / 1.5),
                      bottomRight: Radius.circular(baseSize / 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: baseSize,
              height: baseSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [fillColor(), darkerFillColor],
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(baseSize * 0.35),
                boxShadow: [
                  BoxShadow(
                    color: darkerFillColor.withValues(alpha: .4),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: baseSize - 10,
              height: baseSize - 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [fillColor(), darkerFillColor],
                ),
                shape: BoxShape.rectangle,
                // border: Border.all(
                //     width: baseSize * 0.08, color: darkerFillColor),
                borderRadius: BorderRadius.circular(baseSize * 0.3),
                boxShadow: [
                  BoxShadow(
                    color: darkerFillColor.withValues(alpha: .2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: childElement ??
                  Text(
                    position.toString(),
                    style: LayoutConfig(context).boldedStyle.copyWith(
                          color: theme.scaffoldBackgroundColor,
                          fontWeight: FontWeight.w900,
                          fontSize: baseSize /
                              1.5, // Adjust font size based on widget size
                        ),
                  ),
            ),
            Container(
              alignment: Alignment.center,
              width: baseSize - 2 - 10,
              height: baseSize - 2 - 10,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  top: BorderSide(width: 2, color: fillColor().getLighter()),
                  right: BorderSide(width: 1, color: fillColor().getLighter()),
                ),
                borderRadius: BorderRadius.circular(baseSize * 0.3),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Container(
                alignment: Alignment.center,
                width: baseSize - 2,
                height: baseSize - 2,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                    bottom:
                        BorderSide(width: 2, color: fillColor().getLighter()),
                    left: BorderSide(width: 3, color: fillColor().getLighter()),
                  ),
                  borderRadius: BorderRadius.circular(baseSize * 0.35),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

enum ButtonSize {
  smallest,
  small,
  medium,
  large,
}

enum RoundedWithShapeAt {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double opacity;
  final String? text;
  final TextStyle? style;
  final IconData? iconData;
  final ButtonSize buttonSize;
  final RoundedWithShapeAt? shapeAt;
  final double? minWidth;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final TextDirection? textDirection;

  const CustomElevatedButton({
    Key? key,
    this.onPressed,
    this.child,
    this.opacity = 1.0,
    this.text,
    this.style,
    this.iconData,
    this.buttonSize = ButtonSize.medium,
    this.shapeAt,
    this.minWidth,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.textDirection,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool isPressed = false;

  double getFontSize(BuildContext context) {
    final baseFontSize = LayoutConfig(context).titleScreenStyle.fontSize ?? 20;
    switch (widget.buttonSize) {
      case ButtonSize.smallest:
        return baseFontSize * 0.4;
      case ButtonSize.small:
        return baseFontSize * 0.5;
      case ButtonSize.medium:
        return baseFontSize;
      case ButtonSize.large:
        return baseFontSize * 1.33;
    }
  }

  double getPaddingSize() {
    double basePadding = 20;
    switch (widget.buttonSize) {
      case ButtonSize.smallest:
        return basePadding * 0.8;
      case ButtonSize.small:
        return basePadding * 0.8;
      case ButtonSize.medium:
        return basePadding;
      case ButtonSize.large:
        return basePadding * 1.2;
    }
  }

  BorderRadius getBorderRadius(RoundedWithShapeAt? shapeAt) {
    BorderRadius baseRadius = BorderRadius.only(
      topLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
      topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
      bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
      bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
    );

    switch (shapeAt) {
      case RoundedWithShapeAt.topLeft:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        );
      case RoundedWithShapeAt.topRight:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        );
      case RoundedWithShapeAt.bottomLeft:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        );
      case RoundedWithShapeAt.bottomRight:
        baseRadius = baseRadius.copyWith(
          bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        );
      default:
        break;
    }

    return baseRadius;
  }

  TextStyle getTextStyle(BuildContext context) {
    return widget.style ??
        LayoutConfig(context).displaySmallStyle().copyWith(
              fontSize: getFontSize(context),
              color: getPressedColor(context),
              fontStyle: FontStyle.italic,
            );
  }

  Color getColor(BuildContext context) {
    if (widget.gradient != null) {
      return Theme.of(context).scaffoldBackgroundColor;
    }

    return widget.color ?? Theme.of(context).secondaryHeaderColor;
  }

  Color getPressedColor(BuildContext context) {
    return isPressed ? getColor(context).getLighter() : getColor(context);
  }

  Color getBackgroundColor(BuildContext context) {
    if (widget.gradient != null) {
      return Colors.transparent;
    }

    return widget.backgroundColor ?? Theme.of(context).primaryColor;
  }

  Color getBackgroundColorAndPressed(BuildContext context) {
    if (widget.gradient != null) {
      return Colors.transparent;
    }

    return isPressed
        ? getBackgroundColor(context).getLighter()
        : getBackgroundColor(context);
  }

  TextDirection getTextDirection() {
    return widget.textDirection ?? TextDirection.ltr;
  }

  Widget children(BuildContext context) {
    Widget? textWidget;
    Widget? iconWidget;
    if (widget.text != null) {
      textWidget = Expanded(
        child: Text(
          widget.text!,
          style: getTextStyle(context).copyWith(
            fontSize: getFontSize(context),
            color: getPressedColor(context),
          ),
        ),
      );
    }

    if (widget.iconData != null) {
      iconWidget = Icon(
        widget.iconData,
        color: getPressedColor(context),
        size: getFontSize(context),
      );
    }

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      textDirection: getTextDirection(),
      children: [
        if (iconWidget != null) iconWidget,
        if (iconWidget != null && textWidget != null) const SizedBox(width: 8),
        if (textWidget != null) textWidget,
      ],
    );

    Widget content = widget.child ?? row;

    return IntrinsicWidth(child: content);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: const Duration(milliseconds: 10),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: isPressed ? const EdgeInsets.all(5) : const EdgeInsets.all(0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: isPressed ? 0.9 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: getBorderRadius(widget.shapeAt),
              boxShadow: isPressed
                  ? null
                  : [
                      BoxShadow(
                        color: Theme.of(context)
                            .primaryColor
                            .getDarker()
                            .withAlpha(50),
                        blurRadius: 5,
                        offset: const Offset(5, 5),
                      ),
                      BoxShadow(
                        color: Theme.of(context)
                            .primaryColor
                            .getLighter()
                            .withAlpha(50),
                        blurRadius: 5,
                        offset: const Offset(-5, -5),
                      ),
                    ],
            ).copyWith(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: widget.minWidth ?? 50,
                minHeight: widget.minHeight ?? 50,
              ),
              child: ElevatedButton(
                style: LayoutConfig.elevatedButtonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    getBackgroundColorAndPressed(context),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: getBorderRadius(widget.shapeAt),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: getPaddingSize(),
                      horizontal: getPaddingSize(),
                    ),
                  ),
                ),
                onPressed: () {
                  if (widget.onPressed == null) return;
                  widget.onPressed?.call();
                  setState(
                    () {
                      isPressed = true;
                    },
                  );
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    () {
                      setState(() {
                        isPressed = false;
                      });
                    },
                  );
                },
                child: children(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final BuildContext context;
  final ButtonSize? buttonSize;
  final IconData? iconData;
  final String? text;
  final TextStyle? style;
  final VoidCallback onPressed;
  final bool? isEnable;
  final RoundedWithShapeAt? shapeAt;
  final double? minWidth;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final TextDirection? textDirection;

  const AnimatedButton(
    this.context, {
    super.key,
    this.iconData,
    this.text,
    this.style,
    this.buttonSize,
    required this.onPressed,
    this.isEnable,
    this.shapeAt = RoundedWithShapeAt.topLeft,
    this.minWidth,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.textDirection,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double originalScale = 1;
  int milisecondDuation = 10;

  // TurnBloc get turnBloc => widget.context.read<TurnBloc>();
  // TurnState get turnState => widget.context.read<TurnBloc>().state;

  VoidCallback get onPressed => widget.onPressed;

  get isIconOnly => widget.iconData != null && widget.text == null;

  double get minWidthAuto {
    double defaultWidth = 80;

    switch (widget.buttonSize) {
      case ButtonSize.smallest:
        return defaultWidth * 0.6;
      case ButtonSize.small:
        return defaultWidth * 0.8;
      case ButtonSize.medium:
        return defaultWidth * 1;
      case ButtonSize.large:
        return defaultWidth * 1.2;
      default:
        return defaultWidth;
    }
  }

  double get minHeightAuto {
    double defaultHeight = 80;

    switch (widget.buttonSize) {
      case ButtonSize.smallest:
        return defaultHeight * 0.6;
      case ButtonSize.small:
        return defaultHeight * 0.8;
      case ButtonSize.medium:
        return defaultHeight * 1;
      case ButtonSize.large:
        return defaultHeight * 1.2;
      default:
        return defaultHeight;
    }
  }

  double? get minWidth => isIconOnly ? minWidthAuto : widget.minWidth;
  double? get minHeight => isIconOnly ? minHeightAuto : widget.minHeight;

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 200);
    bool isEnable = widget.isEnable ?? true;

    return AnimatedScale(
      scale: originalScale,
      duration: Duration(milliseconds: milisecondDuation),
      child: AnimatedOpacity(
        opacity:
            // (turnState.isAbleToReset && turnState.isAbleToTap)
            isEnable ? 1 : 0.5,
        duration: duration,
        child: CustomElevatedButton(
          iconData: widget.iconData,
          text: widget.text,
          style: widget.style,
          buttonSize: widget.buttonSize ?? ButtonSize.medium,
          shapeAt: widget.shapeAt,
          minWidth: minWidth,
          minHeight: minHeight,
          color: widget.color,
          backgroundColor: widget.backgroundColor,
          textDirection: widget.textDirection,
          onPressed: () {
            onPressed();

            setState(() {
              originalScale = 0.8;
              milisecondDuation = 1000;
            });

            Future.delayed(duration, () {
              setState(() {
                originalScale = 1;
                milisecondDuation = 10;
              });
            });
          },
        ),
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

class DeviceWrapper extends StatelessWidget {
  final Widget child;
  final bool isNavBar;

  const DeviceWrapper({
    super.key,
    required this.child,
    this.isNavBar = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Check if the screen width is greater than 800, which is a common breakpoint for an iPad
    final bool isIpad = screenWidth > 800;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isNavBar ? 20 : 40),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (isIpad) {
            // If it's an iPad, return the child inside a Center widget to center it on the screen
            // and limit its width to a maximum of 800 pixels
            return Center(
              child: SizedBox(
                width: 800,
                child: child,
              ),
            );
          } else {
            // If it's not an iPad, return the child as is
            return child;
          }
        },
      ),
    );
  }
}
