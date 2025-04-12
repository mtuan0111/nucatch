import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/models/turn_record_model.dart';

abstract class TurnEvent {}

class CountDownIntro extends TurnEvent {
  int seconds;
  CountDownIntro({
    required this.seconds,
  });
}

class Start extends TurnEvent {
// Marking the status transform from initial status to playing status
  int seconds;
  Start({
    this.seconds = 3,
  });
}

class Tap extends TurnEvent {
  final KeyboardOption keyValue;

  Tap({
    required this.keyValue,
  });
}

class SetLevel extends TurnEvent {
  final int level;
  final int addPoint;

  SetLevel({
    required this.level,
    this.addPoint = 1,
  });
}

class SaveRecorded extends TurnEvent {
  final TurnRecordedModel savingRecord;

  SaveRecorded({required this.savingRecord});
}

class GetTurnRecordedList extends TurnEvent {
  GetTurnRecordedList();
}

class ShowExpect extends TurnEvent {
  final Duration duration;
  ShowExpect(this.duration);
}

class HideExpect extends TurnEvent {
  HideExpect();
}

// class MarkCorrectTap extends TurnEvent {
//   final KeyboardOption keyValue;
//   MarkCorrectTap({required this.keyValue});
// }

// class MarkWrongTap extends TurnEvent {}

class ResetNewNumber extends TurnEvent {}
