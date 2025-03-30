import 'dart:convert';
import 'dart:developer';

import 'package:nucatch_with_bloc/helpers/preferences_key.dart';

class TurnRecordedModel {
  final String playedUsername;
  final int point;
  final DateTime recordedTime;

  TurnRecordedModel({
    required this.playedUsername,
    required this.point,
    required this.recordedTime,
  });

  // DateTime get recordedTime => _recordedTime;

  // TurnRecordedModel.fromJSON(Map<String, dynamic> json)
  //     : this(
  //         playedUsername: json[PreferencesKey.PLAYED_USERNAME],
  //         point: json[PreferencesKey.POINT],
  //         recordedTime: DateTime.fromMicrosecondsSinceEpoch(
  //             int.tryParse(json[PreferencesKey.RECORDED_TIME]) ?? 0),
  //       );

  factory TurnRecordedModel.fromJson(Map<String, dynamic> json) {
    return TurnRecordedModel(
      playedUsername: json[PreferencesKey.PLAYED_USERNAME],
      point: int.tryParse(json[PreferencesKey.POINT].toString()) ?? 0,
      recordedTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[PreferencesKey.RECORDED_TIME].toString()) ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PreferencesKey.PLAYED_USERNAME: playedUsername,
      PreferencesKey.POINT: point,
      PreferencesKey.RECORDED_TIME: recordedTime.millisecondsSinceEpoch,
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
