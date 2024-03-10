import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';

abstract class TurnEvent {}

class Tap extends TurnEvent {
  final KeyboardOption keyValue;

  Tap({
    required this.keyValue,
  });
}

class SetLevel extends TurnEvent {
  final int level;

  SetLevel({
    required this.level,
  });
}

class ShowExpect extends TurnEvent {
  final bool isShow;

  ShowExpect({
    required this.isShow,
  });
}
