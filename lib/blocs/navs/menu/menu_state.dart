import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/const.dart';

abstract class MenuState {}

enum MenuOption {
  start,
  topScore,
  setting,
  about,
  exit,
}

Map<MenuOption, Map<String, dynamic>> menuArray(BuildContext context) => {
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

class Menu extends MenuState {}

class Play extends MenuState {}

class TopScore extends MenuState {}

class Setting extends MenuState {}

class About extends MenuState {}

class Exit extends MenuState {}
