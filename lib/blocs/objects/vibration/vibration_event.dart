abstract class VibrationEvent {}

class VibrateShort extends VibrationEvent {
  final int duration;

  VibrateShort({this.duration = 100});
}

class VibrateLong extends VibrationEvent {
  final int duration;

  VibrateLong({this.duration = 500});
}

class VibrateMultiple extends VibrationEvent {}

class SetVibrationEnabled extends VibrationEvent {
  final bool enabled;

  SetVibrationEnabled({required this.enabled});
}
