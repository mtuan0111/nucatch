// ignore: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:nucatch/localization/app_localizations.dart';

const diffShowLevelMilisecond = 250;

const String timeDateClient = "dd/MM/yyyy hh:mm a";
const String timeDateServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

const Map<String, String> languages = {
  'en': "English",
  'vi': "Tiếng Việt",
};

String defaultUsername(context) => lang(context).anonymous;

AppLocalizations lang(context) => AppLocalizations.of(context)!;

class LayoutConfig {
  final BuildContext context;

// Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 20;

  static double opacityDisabled = 0.5;

  LayoutConfig(this.context);

  TextStyle displaySmallStyle({
    bool isActiveShadow = false,
    bool isItalic = false,
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
        color: Theme.of(context).scaffoldBackgroundColor,
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

  TextStyle titleSectionStyle({
    bool isActiveShadow = false,
    bool isItalic = false,
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).scaffoldBackgroundColor,
        fontFamily: fontFamily,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: FontWeight.w600,
        shadows: [
          if (isActiveShadow)
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 0,
              offset: Offset(-2, 4),
            )
        ],
      );

  TextStyle contentSectionStyle({
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontFamily: fontFamily,
          );

  TextStyle handWritingSectionStyle({
    String? fontFamily,
  }) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontFamily: "Dancing Script",
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

    shadowColor: Colors.grey, // Added background grey
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

  BoxDecoration get gradientDecorationReverted => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ].reversed.toList(),
        ),
      );

  BoxDecoration get boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(
          LayoutConfig.layoutBorderRadius,
        ),
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
}
