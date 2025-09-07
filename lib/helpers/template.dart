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

enum ButtonSize { small, medium, large }

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final double opacity;
  final String? text;
  final IconData? icon;
  final Color? color;
  final ButtonSize buttonSize;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    this.child,
    this.opacity = 1.0,
    this.text,
    this.icon,
    this.color,
    this.buttonSize = ButtonSize.medium,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool isPressed = false;

  double getVerticalPadding() {
    switch (widget.buttonSize) {
      case ButtonSize.small:
        return 10.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 32.0;
    }
  }

  double getHorizontalPadding() {
    switch (widget.buttonSize) {
      case ButtonSize.small:
        return 4.0;
      case ButtonSize.medium:
        return 8.0;
      case ButtonSize.large:
        return 12.0;
    }
  }

  double getFontSize(BuildContext context) {
    final baseFontSize =
        LayoutConfig(context).displaySmallStyle().fontSize ?? 16;
    switch (widget.buttonSize) {
      case ButtonSize.small:
        return baseFontSize * 0.8;
      case ButtonSize.medium:
        return baseFontSize;
      case ButtonSize.large:
        return baseFontSize * 1.2;
    }
  }

  Widget children(context) {
    if (widget.text != null) {
      return Text(
        widget.text!,
        style: LayoutConfig(context).displaySmallStyle().copyWith(
              fontSize: getFontSize(context),
              color: isPressed
                  ? (widget.color ?? Theme.of(context).secondaryHeaderColor)
                      .getLighter()
                  : (widget.color ?? Theme.of(context).secondaryHeaderColor),
            ),
      );
    }

    if (widget.icon != null) {
      return Icon(
        widget.icon,
        color: isPressed
            ? (widget.color ?? Theme.of(context).secondaryHeaderColor)
                .getLighter()
            : (widget.color ?? Theme.of(context).secondaryHeaderColor),
        size: getFontSize(context),
      );
    }
    return widget.child ?? Container();
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
              borderRadius:
                  BorderRadius.circular(LayoutConfig.layoutBorderRadius),
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
            ),
            child: ElevatedButton(
              style: LayoutConfig.elevatedButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  isPressed
                      ? Theme.of(context).primaryColor.getLighter()
                      : Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                widget.onPressed?.call();
                setState(() {
                  isPressed = true;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    isPressed = false;
                  });
                });
              },
              child: children(context),
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
  final VoidCallback onPressed;
  final bool? isEnable;

  const AnimatedButton(
    this.context, {
    super.key,
    this.iconData,
    this.text,
    this.buttonSize,
    required this.onPressed,
    this.isEnable,
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
          icon: widget.iconData,
          text: widget.text,
          buttonSize: widget.buttonSize ?? ButtonSize.medium,
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
