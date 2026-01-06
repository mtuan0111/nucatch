import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/ui_constants.dart';
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
            RankingSortingWidget(
              position: ranking!,
            ),
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
                ),
                RankingInfoRow(
                  icon: Icons.calendar_today,
                  text: createdAt.formatClient(),
                ),
                RankingInfoRow(
                  icon: Icons.star,
                  text: "${lang(context).score}: $turnedPoint",
                ),
                RankingInfoRow(
                  icon: Helper.getIconFromDifficulty(context, difficulty),
                  text:
                      "${lang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, difficulty)}",
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
    this.style,
    this.color,
    // required this.context,
  });

  final IconData icon;
  final String text;
  final TextStyle? style;
  final Color? color;
  // final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Theme.of(context).textTheme.titleLarge?.fontSize,
          color: color ?? Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(width: kSpaceXS),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: (style ?? AppTextStyles.bodyLarge(context)),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
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
          Positioned(
            child: Container(
              margin: margin,
              width: width / 3,
              height: height * 1.2,
              decoration: BoxDecoration(
                color: fillColor.getLighter().withValues(alpha: 0.7),
                borderRadius: borderRadius ??
                    BorderRadius.vertical(
                        bottom: Radius.circular(radiusCircle * 2)),
                boxShadow: [
                  BoxShadow(
                    color: fillColor.getLighter().withValues(alpha: 0.8),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          )
        ],
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
              style: AppTextStyles.displaySmall(context),
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
  final double? size;

  // Component sizing constants
  static const double _defaultSize = 60.0;
  static const double _innerContainerPadding = 10.0;
  static const double _highlightBorderPadding = 12.0;
  static const double _shadowBorderPadding = 2.0;
  static const double _wingOpacity = 0.8;
  static const double _shadowOpacity = 0.5;

  const RankingSortingWidget({
    super.key,
    required this.position,
    this.childElement,
    this.size,
  });

  Color _getPositionColor(ThemeData theme) {
    return switch (position) {
      1 => Colors.pink,
      2 => Colors.blueAccent,
      3 => Colors.green,
      _ => theme.primaryColor,
    };
  }

  Widget _buildWingPair({
    required double baseSize,
    required Color fillColor,
    required double width,
    required double height,
    required EdgeInsets margin,
    required BorderRadius leftRadius,
    required BorderRadius rightRadius,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      verticalDirection: VerticalDirection.up,
      children: [
        Flexible(
          child: Wing(
            width,
            height,
            opacity: _wingOpacity,
            margin: margin,
            fillColor: fillColor,
            radiusCircle: baseSize / 1.5,
            borderRadius: leftRadius,
          ),
        ),
        Flexible(
          child: Wing(
            width,
            height,
            opacity: _wingOpacity,
            margin: margin,
            fillColor: fillColor,
            radiusCircle: baseSize / 1.5,
            borderRadius: rightRadius,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = _getPositionColor(theme);
    final darkerFillColor = fillColor.getDarker();
    final baseSize = size ?? _defaultSize;
    final wingRadius = baseSize / 1.5;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Top wings for position 1
        if (position == 1)
          Positioned(
            child: _buildWingPair(
              baseSize: baseSize,
              fillColor: fillColor,
              width: wingRadius,
              height: baseSize,
              margin: EdgeInsets.only(bottom: baseSize / 2),
              leftRadius: BorderRadius.only(
                topRight: Radius.circular(wingRadius),
                bottomLeft: Radius.circular(baseSize),
              ),
              rightRadius: BorderRadius.only(
                topLeft: Radius.circular(wingRadius),
                bottomRight: Radius.circular(baseSize),
              ),
            ),
          ),
        // Middle wings for positions 1-2
        if (position <= 2)
          Positioned(
            child: _buildWingPair(
              baseSize: baseSize,
              fillColor: fillColor,
              width: baseSize / 2,
              height: wingRadius,
              margin: EdgeInsets.only(top: baseSize / 2),
              leftRadius: BorderRadius.only(
                topLeft: Radius.circular(wingRadius),
                bottomRight: Radius.circular(baseSize),
              ),
              rightRadius: BorderRadius.only(
                topRight: Radius.circular(wingRadius),
                bottomLeft: Radius.circular(baseSize),
              ),
            ),
          ),
        // Bottom wings for positions 1-3
        if (position <= 3)
          Positioned(
            child: _buildWingPair(
              baseSize: baseSize,
              fillColor: fillColor,
              width: baseSize * 1.2,
              height: wingRadius,
              margin: EdgeInsets.zero,
              leftRadius: BorderRadius.only(
                topRight: Radius.circular(wingRadius),
                bottomLeft: Radius.circular(wingRadius),
              ),
              rightRadius: BorderRadius.only(
                topLeft: Radius.circular(wingRadius),
                bottomRight: Radius.circular(wingRadius),
              ),
            ),
          ),
        // Center badge
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Outer container with shadow
            Container(
              width: baseSize,
              height: baseSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [fillColor, darkerFillColor],
                ),
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
            // Inner container with content
            Container(
              width: baseSize - _innerContainerPadding,
              height: baseSize - _innerContainerPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [fillColor, darkerFillColor],
                ),
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
                    style: AppTextStyles.displayLarge(context).copyWith(
                      color: theme.scaffoldBackgroundColor,
                      fontWeight: FontWeight.w900,
                      fontSize: baseSize / 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ),
            // Top-right highlight border
            Container(
              width: baseSize - _highlightBorderPadding,
              height: baseSize - _highlightBorderPadding,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2, color: fillColor.getLighter()),
                  right: BorderSide(width: 1, color: fillColor.getLighter()),
                ),
                borderRadius: BorderRadius.circular(baseSize * 0.3),
              ),
            ),
            // Bottom-left shadow border
            Opacity(
              opacity: _shadowOpacity,
              child: Container(
                width: baseSize - _shadowBorderPadding,
                height: baseSize - _shadowBorderPadding,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2, color: fillColor.getLighter()),
                    left: BorderSide(width: 3, color: fillColor.getLighter()),
                  ),
                  borderRadius: BorderRadius.circular(baseSize * 0.35),
                ),
              ),
            ),
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
  all,
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
  final double? buttonRadius;
  final double? minWidth;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final bool? isActive;
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
    this.buttonRadius,
    this.minWidth,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.isActive,
    this.gradient,
    this.textDirection,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool isPressed = false;

  bool get isClickale => widget.onPressed != null;

  bool get isShouldShowEffect => isPressed || widget.isActive == true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Border effect constants similar to RankingSortingWidget
  double get _highlightBorderPadding => isPressed ? 0 : 4.0;
  static const double _shadowBorderPadding = 2.0;
  static const double _shadowOpacity = 0.5;

  double getFontSize(BuildContext context) {
    final baseFontSize =
        AppTextStyles.displaySmallTitleScreen(context).fontSize ?? 20;
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

  double get lightingSize {
    switch (widget.buttonSize) {
      case ButtonSize.smallest:
        return 10;
      case ButtonSize.small:
        return 20;
      case ButtonSize.medium:
        return 30;
      case ButtonSize.large:
        return 40;
    }
  }

  BorderRadius getBorderRadius(RoundedWithShapeAt? shapeAt,
      {double adjustment = 0}) {
    double adjustedRadius =
        (widget.buttonRadius ?? LayoutConfig.layoutBorderRadius) + adjustment;
    BorderRadius baseRadius = BorderRadius.only(
      topLeft: Radius.circular(adjustedRadius),
      topRight: Radius.circular(adjustedRadius),
      bottomLeft: Radius.circular(adjustedRadius),
      bottomRight: Radius.circular(adjustedRadius),
    );

    switch (shapeAt) {
      case RoundedWithShapeAt.topLeft:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.topRight:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomLeft:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomRight:
        baseRadius = baseRadius.copyWith(
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.all:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius),
          topRight: Radius.circular(adjustedRadius),
          bottomLeft: Radius.circular(adjustedRadius),
          bottomRight: Radius.circular(adjustedRadius),
        );
      default:
        break;
    }

    return baseRadius;
  }

  TextStyle getTextStyle(BuildContext context) {
    return widget.style ??
        Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: getFontSize(context),
              color: getPressedColor(context),
              fontStyle: FontStyle.italic,
            );
  }

  Color getColor(BuildContext context) {
    if (widget.color != null) {
      return widget.color!;
    }
    if (widget.gradient != null) {
      return Theme.of(context).scaffoldBackgroundColor;
    }

    // Generate smart color based on background color contrast
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).primaryColor;
    return backgroundColor.getSmartColor(context);
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
              fontWeight: FontWeight.bold),
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
        if (iconWidget != null && textWidget != null) const SizedBox(width: kSpaceSM),
        if (textWidget != null) textWidget,
      ],
    );

    Widget content = widget.child ?? row;

    if (content is Row) {
      return IntrinsicWidth(child: content);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = (isShouldShowEffect)
        ? getBackgroundColor(context).getLighter()
        : getBackgroundColor(context);
    final darkerBackgroundColor = backgroundColor.getDarker();
    final borderRadiusValue = getBorderRadius(widget.shapeAt);

    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: const Duration(milliseconds: 10),
      child: AnimatedScale(
        duration: const Duration(milliseconds: kAnimationDurationFast),
        scale: isPressed ? 1.0 : 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minWidth ?? 50,
            minHeight: widget.minHeight ?? 50,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  // margin: const EdgeInsets.all(),
                  decoration: BoxDecoration(
                    // color: Colors.redAccent,
                    gradient: widget.gradient?.getDarker() ??
                        LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            backgroundColor.getDarker(),
                            darkerBackgroundColor.getDarker().getDarker(),
                          ],
                        ),

                    borderRadius: getBorderRadius(widget.shapeAt,
                        adjustment: _highlightBorderPadding),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(
                    // top: _highlightBorderPadding / 2,
                    // right: _highlightBorderPadding / 2,
                    bottom: _highlightBorderPadding,
                    left: _highlightBorderPadding,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.redAccent,
                    gradient: widget.gradient ??
                        LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            backgroundColor,
                            darkerBackgroundColor,
                          ],
                        ),

                    borderRadius: borderRadiusValue,
                  ),
                ),
              ),

              // Outer container with shadow (base layer)
              Container(
                margin: EdgeInsets.only(
                  // top: _highlightBorderPadding / 2,
                  // right: _highlightBorderPadding / 2,
                  bottom: _highlightBorderPadding,
                  left: _highlightBorderPadding,
                ),
                child: ElevatedButton(
                  style: LayoutConfig.elevatedButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: borderRadiusValue,
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
                    if (mounted) {
                      setState(
                        () {
                          isPressed = true;
                        },
                      );
                    }
                    Future.delayed(
                      const Duration(milliseconds: kAnimationDurationFast),
                      () {
                        if (mounted) {
                          setState(() {
                            isPressed = false;
                          });
                        }
                      },
                    );
                  },
                  child: children(context),
                ),
              ),
              // Top-right highlight border

              if (isClickale)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _shadowOpacity / 1.5,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: kAnimationDurationFast),
                        // margin: EdgeInsets.only(
                        //   // top: _highlightBorderPadding / 2,
                        //   // right: _highlightBorderPadding / 2,
                        //   bottom: _highlightBorderPadding,
                        //   left: _highlightBorderPadding,
                        // ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: isPressed
                                  ? lightingSize / 10
                                  : lightingSize / 10,
                              color: backgroundColor.getLighter(),
                            ),
                            right: BorderSide(
                              width: widget.buttonSize == ButtonSize.smallest
                                  ? lightingSize / 10
                                  : lightingSize / 10,
                              color: backgroundColor.getLighter(),
                            ),
                          ),
                          borderRadius:
                              isPressed ? borderRadiusValue : borderRadiusValue,
                        ),
                      ),
                    ),
                  ),
                ),
              // Bottom-left shadow border

              if (isClickale)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _shadowOpacity / 2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: kAnimationDurationFast),
                        margin: EdgeInsets.only(
                          // top: _highlightBorderPadding / 2,
                          // right: _highlightBorderPadding / 2,
                          bottom: _highlightBorderPadding,
                          left: _highlightBorderPadding,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width:
                                  isPressed ? lightingSize / 3 : lightingSize,
                              color: backgroundColor.getLighter(),
                            ),
                            right: BorderSide(
                              width: widget.buttonSize == ButtonSize.smallest
                                  ? lightingSize / 3
                                  : lightingSize / 3,
                              color: backgroundColor.getLighter(),
                            ),
                          ),
                          borderRadius:
                              isPressed ? borderRadiusValue : borderRadiusValue,
                        ),
                      ),
                    ),
                  ),
                ),
              // Bottom-left shadow border

              if (isClickale)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _shadowOpacity,
                      child: Container(
                        margin: const EdgeInsets.only(
                            // top: _highlightBorderPadding / 2,
                            // right: _highlightBorderPadding / 2,
                            // bottom: _highlightBorderPadding / 4,
                            // left: _highlightBorderPadding / 4,
                            ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: widget.buttonSize == ButtonSize.smallest
                                  ? lightingSize / 1
                                  : lightingSize / 3,
                              color: backgroundColor.getDarker().getDarker(),
                            ),
                            left: BorderSide(
                              width: widget.buttonSize == ButtonSize.smallest
                                  ? lightingSize / 2
                                  : lightingSize / 5,
                              color: backgroundColor.getDarker().getDarker(),
                            ),
                          ),
                          borderRadius: borderRadiusValue +
                              const BorderRadius.all(
                                  Radius.circular(_shadowBorderPadding)),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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
  final bool? isActive;
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
    this.isActive,
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
          isActive: widget.isActive,
          textDirection: widget.textDirection,
          onPressed: () {
            onPressed();

            if (mounted) {
              setState(() {
                originalScale = 0.8;
                milisecondDuation = 1000;
              });
            }

            Future.delayed(duration, () {
              if (mounted) {
                setState(() {
                  originalScale = 1;
                  milisecondDuation = 10;
                });
              }
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
    final colorScheme = Theme.of(context).colorScheme;
    return Hero(
      tag: "logo",
      // transitionOnUserGestures: true,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
        child: const Image(
          height: 160,
          image: AssetImage("assets/images/main-logo.png"),
          fit: BoxFit.contain,
        ),
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
          style: AppTextStyles.displaySmallTitleScreen(context),
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

/// Shared option card widget used across multiple selection screens
/// (SelectPlayModeScreen, CombatModeSetupScreen, SetDifficultScreen)
class OptionCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.context,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomElevatedButton(
                    text: description,
                    style: AppTextStyles.bodyLarge(context),
                    buttonSize: ButtonSize.smallest,
                    shapeAt: RoundedWithShapeAt.topRight,
                    backgroundColor: Colors.black54,
                  ),
                  Positioned(
                    top: -45,
                    right: 10,
                    child: CustomElevatedButton(
                      text: title,
                      buttonSize: ButtonSize.small,
                      shapeAt: RoundedWithShapeAt.bottomRight,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: kSpaceL),
          AnimatedButton(
            context,
            onPressed: onTap,
            iconData: icon,
            shapeAt: RoundedWithShapeAt.topLeft,
            backgroundColor: color,
          ),
        ],
      ),
    );
  }
}
