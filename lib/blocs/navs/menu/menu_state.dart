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

class Menu extends MenuState {}

class Home extends MenuState {}

class TopScore extends MenuState {}

class Setting extends MenuState {}

class About extends MenuState {}

class Exit extends MenuState {}
