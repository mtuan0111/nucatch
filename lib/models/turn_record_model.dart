import 'dart:convert';
import 'dart:developer';

import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/preferences_key.dart';

class TurnRecordedModel {
  final String turnId;
  final String? playedUsername;
  final int point;
  final DateTime recordedTime;
  final Difficulty difficulty;
  final String? firebaseUserId;

  TurnRecordedModel({
    required this.turnId,
    this.playedUsername,
    required this.point,
    required this.recordedTime,
    required this.difficulty,
    this.firebaseUserId,
  });

  // DateTime get recordedTime => _recordedTime;

  // TurnRecordedModel.fromJSON(Map<String, dynamic> json)
  //     : this(
  //         playedUsername: json[NucatchPreferencesKey.PLAYED_USERNAME],
  //         point: json[NucatchPreferencesKey.POINT],
  //         recordedTime: DateTime.fromMicrosecondsSinceEpoch(
  //             int.tryParse(json[NucatchPreferencesKey.RECORDED_TIME]) ?? 0),
  // Removed duplicate field declaration
  //       );

  factory TurnRecordedModel.fromJson(Map<String, dynamic> json) {
    T getValue<T>(String key, T defaultValue, T Function(dynamic) converter) {
      final value = json[key] ?? json[key.snakeCaseToCamel()];
      return value != null ? converter(value) : defaultValue;
    }

    return TurnRecordedModel(
      turnId: getValue<String>(NucatchPreferencesKey.TURN_ID, '', (v) => v.toString()),
      playedUsername: getValue<String?>(
          NucatchPreferencesKey.PLAYED_USERNAME, null, (v) => v?.toString()),
      point: getValue<int>(
          NucatchPreferencesKey.POINT, 0, (v) => int.tryParse(v.toString()) ?? 0),
      recordedTime:
          getValue<DateTime>(NucatchPreferencesKey.RECORDED_TIME, DateTime.now(), (v) {
        final str = v.toString();
        return str.contains('T')
            ? DateTime.tryParse(str) ?? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(int.tryParse(str) ?? 0);
      }),
      difficulty: getValue<Difficulty>(
          NucatchPreferencesKey.DIFFICULTY, Difficulty.values.first, (v) {
        return v is int
            ? Difficulty.values.elementAtOrNull(v) ?? Difficulty.values.first
            : Difficulty.values.cast<Difficulty?>().firstWhere(
                      (d) =>
                          d?.name.toLowerCase() == v.toString().toLowerCase(),
                      orElse: () => null,
                    ) ??
                Difficulty.values.first;
      }),
      firebaseUserId: getValue<String?>(
          NucatchPreferencesKey.FIREBASE_USERID, null, (v) => v?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      NucatchPreferencesKey.TURN_ID: turnId,
      NucatchPreferencesKey.PLAYED_USERNAME: playedUsername,
      NucatchPreferencesKey.POINT: point,
      NucatchPreferencesKey.RECORDED_TIME: recordedTime.millisecondsSinceEpoch,
      NucatchPreferencesKey.DIFFICULTY: difficulty.index,
      NucatchPreferencesKey.FIREBASE_USERID: firebaseUserId,
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
