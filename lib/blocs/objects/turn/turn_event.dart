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
  ShowExpect();
}

class HideExpect extends TurnEvent {
  HideExpect();
}

class TakeARest extends TurnEvent {
  TakeARest();
}

class MarkCorrectTap extends TurnEvent {
  final KeyboardOption keyValue;
  MarkCorrectTap({required this.keyValue});
}

class MarkWrongTap extends TurnEvent {}

class ResetNewNumber extends TurnEvent {}
