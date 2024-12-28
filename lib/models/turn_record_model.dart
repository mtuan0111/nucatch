import 'dart:convert';
import 'dart:developer';

import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/helpers/extension.dart';

class TurnRecordedModel {
  final String playedUsername;
  final int point;
  final DateTime _recordedTime;

  TurnRecordedModel({
    required this.playedUsername,
    required this.point,
    required DateTime recordedTime,
  }) : _recordedTime = recordedTime;

  DateTime get recordedTime => _recordedTime;

  TurnRecordedModel.fromJSON(Map<String, dynamic> json)
      : this(
          playedUsername: json[PreferencesKey.PLAYED_USERNAME],
          point: json[PreferencesKey.POINT],
          recordedTime: (json[PreferencesKey.RECORDED_TIME] as String).toDate(),
        );

  Map<String, dynamic> toJson() {
    return {
      PreferencesKey.PLAYED_USERNAME: playedUsername,
      PreferencesKey.POINT: point,
      PreferencesKey.RECORDED_TIME: _recordedTime,
    };
  }

  @override
  String toString() {
    return json.encode(toJson(), toEncodable: (val) {
      if (val is DateTime) {
        log(val.toString());
        return val.toString();
      }
      return null;
    });
  }
}
