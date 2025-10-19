import 'dart:convert';
import 'dart:developer';

import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/extension.dart';
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
    T getValue<T>(String key, T defaultValue, T Function(dynamic) converter) {
      final value = json[key] ?? json[key.snakeCaseToCamel()];
      return value != null ? converter(value) : defaultValue;
    }

    return TurnRecordedModel(
      turnId: getValue(PreferencesKey.TURN_ID, '', (v) => v.toString()),
      playedUsername:
          getValue(PreferencesKey.PLAYED_USERNAME, null, (v) => v.toString()),
      point: getValue(
          PreferencesKey.POINT, 0, (v) => int.tryParse(v.toString()) ?? 0),
      recordedTime: getValue(
          PreferencesKey.RECORDED_TIME,
          DateTime.now(),
          (v) => DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(v.toString()) ?? 0)),
      difficulty: getValue<Difficulty>(
          PreferencesKey.DIFFICULTY, Difficulty.values.first, (v) {
        if (v is int) {
          return Difficulty.values.elementAtOrNull(v) ??
              Difficulty.values.first;
        }
        return Difficulty.values.firstWhere(
          (d) => d.name.toLowerCase() == v.toString().toLowerCase(),
          orElse: () => Difficulty.values.first,
        );
      }),
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
