import 'package:flutter/material.dart';

abstract class TurnRecordedEvent {}

class ShareEvent extends TurnRecordedEvent {
  final String message;
  final String subject;
  final GlobalKey objectKey;

  ShareEvent({
    required this.message,

    // required this.localization,
    required this.subject,
    required this.objectKey,
  });
}
