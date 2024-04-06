// ignore: constant_identifier_names
import 'package:flutter/material.dart';

const diffShowLevelMilisecond = 250;

class LayoutConfig {
  final BuildContext context;

// Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 20;

  LayoutConfig(this.context);

  TextStyle displaySmallStyle({
    bool isActiveShadow = false,
    bool isItalic = false,
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
        color: Colors.white,
        fontFamily: fontFamily,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: FontWeight.bold,
        shadows: [
          if (isActiveShadow)
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 0,
              offset: Offset(-2, 4),
            )
        ],
      );

  TextStyle titleMediumStyle({
    bool isActiveShadow = false,
    bool isItalic = false,
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.white,
        fontFamily: fontFamily,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: FontWeight.bold,
        shadows: [
          if (isActiveShadow)
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 0,
              offset: Offset(-2, 4),
            )
        ],
      );

  TextStyle get titleScreenStyle => displaySmallStyle(
        isActiveShadow: true,
        isItalic: true,
      );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        LayoutConfig.layoutBorderRadius,
      ),
    ),
    foregroundColor: const Color.fromARGB(
      221,
      126,
      109,
      109,
    ),
  );

  BoxDecoration get gradientDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ],
        ),
      );

  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(
          LayoutConfig.layoutBorderRadius,
        ),
        border: Border.all(
          color: Colors.white,
        ),
      );
}
