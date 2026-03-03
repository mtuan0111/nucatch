// ignore_for_file: non_constant_identifier_names, constant_identifier_names

// Re-export common keys from skeleton_core
export 'package:skeleton_core/skeleton_core.dart' show PreferencesKey;

/// Game-specific preference keys for nuCatch.
/// Common keys (USERNAME, FIREBASE_USER_ID, VOL, IS_VIBRATE, etc.)
/// are available via [PreferencesKey] from skeleton_core.
class NucatchPreferencesKey {
  static const TURN_ID = "turn_id";
  static const LIST_TURN_RECORDED = "list_turn_recorded";
  static const PLAYED_USERNAME = "played_username";
  static const POINT = "point";
  static const RECORDED_TIME = "recorded_time";
  static const DIFFICULTY = "difficulty";
  static const LAST_USED_DIFFICULTY = "last_used_difficulty";
  static const FIREBASE_USERID = "firebase_user_id";
}
