// ignore: constant_identifier_names
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:nucatch/localization/app_localizations.dart';

const diffShowLevelMilisecond = 250;
const double tapTimerDuration = 60.0; // Seconds for each tap countdown

const String timeDateClient = "dd/MM/yyyy hh:mm a";
const String timeDateServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

const Map<String, String> languages = {
  'en': "English",
  'vi': "Tiếng Việt",
  'es': "Español",
  'zh': "中文",
  'fr': "Français",
  'de': "Deutsch",
  'ja': "日本語",
  'th': "ไทย",
  'id': "Bahasa Indonesia",
  'hi': "हिन्दी",
};

const String secretKey = "NUCATCH_NO_NEED_TO_CHEAT_ME";
const int luckyNumber = 11;
String encodedKey = md5.convert(utf8.encode(secretKey)).toString();
String profileUrlShareWithKey(profileUrl) =>
    profileUrl +
    "&u=%username%&p=%point%&t=%timeCreated%&d=%difficulty%&k=%md5Key%";

String defaultUsername(context) => lang(context).anonymous;

AppLocalizations lang(context) => AppLocalizations.of(context)!;

class LayoutConfig {
  final BuildContext context;

// Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 30;

  static double opacityDisabled = 0.5;

  LayoutConfig(this.context);

  // TextStyle methods removed - now using AppTextStyles class
  // See lib/helpers/app_text_styles.dart for centralized TextStyle system

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

// AdMob Configuration
class AdMobConfig {
  // AdMob App IDs (used in AndroidManifest.xml and Info.plist)
  static const String androidAppId = 'ca-app-pub-7979935537603411~2676193632';
  static const String iosAppId = 'ca-app-pub-7979935537603411~5942915481';

// Game over
  // Ad Unit IDs - Android
  static const String androidGameOverBannerId =
      'ca-app-pub-7979935537603411/6405949912';

  // Ad Unit IDs - iOS
  static const String iosGameOverBannerId =
      'ca-app-pub-7979935537603411/5196375251';

// Top Score
  // Ad Unit IDs - Android
  static const String androidTopScoreBannerId =
      'ca-app-pub-7979935537603411/3370267625';

  // Ad Unit IDs - iOS
  static const String iosTopScoreBannerId =
      'ca-app-pub-7979935537603411/1322679044';

  // Test mode flag - set to false when AdMob account is approved
  static const bool useTestAds = true;
}
