import 'dart:convert';
import 'dart:developer';

import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/preferences_key.dart';

class TurnRecordedModel {
  final String turnId;
  final String? playedUsername;
  final int point;
  final DateTime recordedTime;
  final Difficulty difficulty;

  TurnRecordedModel({
    required this.turnId,
    this.playedUsername,
    required this.point,
    required this.recordedTime,
    required this.difficulty,
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
      turnId: json[PreferencesKey.TURN_ID],
      playedUsername: json[PreferencesKey.PLAYED_USERNAME],
      point: int.tryParse(json[PreferencesKey.POINT].toString()) ?? 0,
      recordedTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[PreferencesKey.RECORDED_TIME].toString()) ?? 0),
      difficulty: Difficulty.values[
          int.tryParse(json[PreferencesKey.DIFFICULTY].toString()) ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PreferencesKey.TURN_ID: turnId,
      PreferencesKey.PLAYED_USERNAME: playedUsername,
      PreferencesKey.POINT: point,
      PreferencesKey.RECORDED_TIME: recordedTime.millisecondsSinceEpoch,
      PreferencesKey.DIFFICULTY: difficulty.index,
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

// class TurnRecordedModel {
//   final String turnId;
//   final String playedUsername;
//   final int point;
//   final DateTime recordedTime;

//   TurnRecordedModel({
//     required this.turnId,
//     required this.playedUsername,
//     required this.point,
//     required this.recordedTime,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'turnId': turnId,
//       'playedUsername': playedUsername,
//       'point': point,
//       'recordedTime': recordedTime.toIso8601String(),
//     };
//   }

//   factory TurnRecordedModel.fromJson(Map<String, dynamic> json) {
//     return TurnRecordedModel(
//       turnId: json['turnId'],
//       playedUsername: json['playedUsername'],
//       point: json['point'],
//       recordedTime: DateTime.parse(json['recordedTime']),
//     );
//   }

//   @override
//   String toString() {
//     return 'TurnRecordedModel(turnId: $turnId, playedUsername: $playedUsername, point: $point, recordedTime: $recordedTime)';
//   }
// }
