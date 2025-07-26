import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/models/setting_model.dart';

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

class End extends TurnEvent {
  // final TurnRecordedModel turnRecordedModel;
  final bool isCauseGameOver;

  End({
    // required this.turnRecordedModel,
    this.isCauseGameOver = true,
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

class LostLife extends TurnEvent {
  final int lifeRemaining;

  LostLife({
    this.lifeRemaining = 1,
  });
}

class GainLife extends TurnEvent {
  final int lifeGained;

  GainLife({
    this.lifeGained = 1,
  });
}

class SaveRecorded extends TurnEvent {
  // final TurnRecordedModel savingRecord;
  // final String? messageSuccess;
  // final String? messageFailure;
  final BuildContext context;

  SaveRecorded({
    // required this.savingRecord,
    // this.messageSuccess,
    // this.messageFailure,
    required this.context,
  });
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

class ResetNewNumber extends TurnEvent {
  Duration duration;
  ResetNewNumber({
    required this.duration,
  });
}

class ApplySetting extends TurnEvent {
  final SettingModel settingModel;
  ApplySetting({
    required this.settingModel,
  });
}
