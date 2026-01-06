import 'package:nucatch/blocs/navs/menu/menu_state.dart';

abstract class MenuEvent {}

class SelectOption extends MenuEvent {
  final MenuOption option;

  SelectOption({
    required this.option,
  });
}

class ShowMenu extends MenuEvent {
  ShowMenu();
}
