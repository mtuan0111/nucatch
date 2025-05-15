abstract class TurnRecordedEvent {}

class ShareEvent extends TurnRecordedEvent {
  final String message;

  ShareEvent({required this.message});
}
