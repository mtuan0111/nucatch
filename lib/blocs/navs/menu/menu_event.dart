import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';

abstract class MenuEvent {}

class SelectOption extends MenuEvent {
  final MenuOption? option;

  SelectOption({
    this.option,
  });
}
