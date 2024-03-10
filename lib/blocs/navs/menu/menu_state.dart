abstract class MenuState {}

enum MenuOption {
  home,
  topScore,
  setting,
  about,
  exit,
}

const Map<MenuOption, String> menuArray = {
  MenuOption.home: "Home",
  MenuOption.topScore: "Top Score",
  MenuOption.setting: "Setting",
  MenuOption.about: "About",
  MenuOption.exit: "Exit",
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

class Home extends MenuState {}

class TopScore extends MenuState {}

class Setting extends MenuState {}

class About extends MenuState {}

class Exit extends MenuState {}
