import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';

// Re-export menu types from skeleton_core
export 'package:skeleton_core/skeleton_core.dart'
    show
        MenuState,
        MenuOption,
        Menu,
        Play,
        InstantStart,
        TopScore,
        Setting,
        About,
        Exit,
        MenuItemConfig,
        buildMenuItems,
        defaultMenuIcons;

/// Game-specific: Builds the localized menu array for nucatch.
Map<MenuOption, Map<String, dynamic>> menuArray(BuildContext context) => {
      MenuOption.instantStart: {
        "text": lang(context).instantStart,
        "icon": FontAwesomeIcons.bolt,
      },
      MenuOption.start: {
        "text": lang(context).start,
        "icon": FontAwesomeIcons.play,
      },
      MenuOption.topScore: {
        "text": lang(context).topScore,
        "icon": FontAwesomeIcons.trophy,
      },
      MenuOption.setting: {
        "text": lang(context).setting,
        "icon": FontAwesomeIcons.gear,
      },
      MenuOption.about: {
        "text": lang(context).about,
        "icon": FontAwesomeIcons.circleInfo,
      },
      MenuOption.exit: {
        "text": lang(context).exit,
        "icon": FontAwesomeIcons.rightFromBracket,
      },
    };

/// Game-specific: Keyboard options for the nuCatch game.
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
