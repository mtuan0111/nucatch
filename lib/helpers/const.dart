// ignore: constant_identifier_names
import 'package:flutter/material.dart';

const DIFF_SHOW_LEVEL_MILISECOND = 250;

class LayoutConfig {
// Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 30;

  static TextStyle titleStyle(BuildContext context,
          {bool isActiveShadow = false, bool isItalic = false}) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
        color: Colors.white,
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

  static BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(
      LayoutConfig.layoutBorderRadius,
    ),
    border: Border.all(
      color: Colors.white,
    ),
  );
}
