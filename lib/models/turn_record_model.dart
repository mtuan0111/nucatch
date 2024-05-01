import 'dart:convert';

import 'package:nucatch_with_bloc/helpers/preferences_key.dart';

class TurnRecordedModel {
  final String playedUsername;
  final int point;
  String? recordedTime;

  TurnRecordedModel({
    required this.playedUsername,
    required this.point,
    this.recordedTime,
  }) {
    recordedTime ??= DateTime.now().toString();
  }

  TurnRecordedModel.fromJSON(Map<String, dynamic> json)
      : this(
          playedUsername: json[PreferencesKey.PLAYED_USERNAME],
          point: json[PreferencesKey.POINT],
          recordedTime: json[PreferencesKey.RECORDED_TIME],
        );

  Map<String, dynamic> toJson() {
    return {
      PreferencesKey.PLAYED_USERNAME: playedUsername,
      PreferencesKey.POINT: point,
      PreferencesKey.RECORDED_TIME: recordedTime,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
