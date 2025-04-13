import 'package:flutter/widgets.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';

abstract class MenuState {}

enum MenuOption {
  start,
  topScore,
  setting,
  about,
  exit,
}

Map<MenuOption, String> menuArray(BuildContext context) => {
      MenuOption.start: lang(context).start,
      MenuOption.topScore: lang(context).topScore,
      MenuOption.setting: lang(context).setting,
      MenuOption.about: lang(context).about,
      MenuOption.exit: lang(context).exit,
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
