// ignore: constant_identifier_names
import 'package:flutter/material.dart';

const DIFF_SHOW_LEVEL_MILISECOND = 250;

class LayoutConfig {
// Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 30;

  static TextStyle displaySmallStyle(
    BuildContext context, {
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

  static TextStyle titleMediumStyle(
    BuildContext context, {
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

  static BoxDecoration gradientDecoration(BuildContext context) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ],
        ),
      );

  static BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(
      LayoutConfig.layoutBorderRadius,
    ),
    border: Border.all(
      color: Colors.white,
    ),
  );
}
