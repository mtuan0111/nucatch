// ignore: constant_identifier_names
// ignore_for_file: unused_import

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/localization/app_localizations.dart';

// Re-export common constants from skeleton_core
import 'package:skeleton_core/skeleton_core.dart';
export 'package:skeleton_core/skeleton_core.dart'
    show LayoutConfig, languages, timeDateClient, timeDateServer, coreLang;

// Game-specific constants
const diffShowLevelMilisecond = 250;
const double tapTimerDuration = 60.0; // Seconds for each tap countdown

// BLE Combat Mode constants
const String kBleAppPrefix = 'nucatch';
const String kBlePlayerNamePrefix = 'Nuca';
const String kBleAdvertisingPrefix = 'Nucatch-';
const int kCombatCountDown =
    6; // Countdown seconds for combat intro (5-4-3-2-1-GO)
const int kSoloCountDown = 6; // Countdown seconds for solo intro (4-3-2-1-GO)
const int kCombatInitialLives =
    3; // Starting lives for each player in combat mode
const int kSoloInitialLives = 3; // Starting lives in solo mode
const int kCombatPickRightTimerPerTurn =
    10; // Seconds per turn for combat pick-right mode

const String secretKey = "NUCATCH_NO_NEED_TO_CHEAT_ME";
const int luckyNumber = 11;
String encodedKey = md5.convert(utf8.encode(secretKey)).toString();
String profileUrlShareWithKey(profileUrl) =>
    profileUrl +
    "&u=%username%&p=%point%&t=%timeCreated%&d=%difficulty%&k=%md5Key%";

String defaultUsername(context) => coreLang(context).anonymous;

AppLocalizations lang(context) => AppLocalizations.of(context)!;

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

// ============================================================================
// Game-specific menu configuration (moved from blocs/navs/menu/menu_state.dart)
// ============================================================================

/// Builds the localized menu array for nucatch.
Map<MenuOption, Map<String, dynamic>> menuArray(BuildContext context) => {
      MenuOption.instantStart: {
        "text": lang(context).instantStart,
        "icon": FontAwesomeIcons.bolt,
      },
      MenuOption.start: {
        "text": coreLang(context).start,
        "icon": FontAwesomeIcons.play,
      },
      MenuOption.topScore: {
        "text": coreLang(context).topScore,
        "icon": FontAwesomeIcons.trophy,
      },
      MenuOption.setting: {
        "text": coreLang(context).setting,
        "icon": FontAwesomeIcons.gear,
      },
      MenuOption.about: {
        "text": coreLang(context).about,
        "icon": FontAwesomeIcons.circleInfo,
      },
      MenuOption.exit: {
        "text": coreLang(context).exit,
        "icon": FontAwesomeIcons.rightFromBracket,
      },
    };

/// Keyboard options for the nuCatch game.
enum KeyboardOption {
  one,
  two,
  three,
  four,
  five,
  six,
  eleven,
  eight,
  nine,
  //
  reset,
  zero,
  mainMenu,
}

const Map<KeyboardOption, int> keyboardArray = {
  KeyboardOption.one: 1,
  KeyboardOption.two: 2,
  KeyboardOption.three: 3,
  KeyboardOption.four: 4,
  KeyboardOption.five: 5,
  KeyboardOption.six: 6,
  KeyboardOption.eleven: 7,
  KeyboardOption.eight: 8,
  KeyboardOption.nine: 9,
  KeyboardOption.reset: 10,
  KeyboardOption.zero: 0,
  KeyboardOption.mainMenu: 11,
};
