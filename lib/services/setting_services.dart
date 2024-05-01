import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingServices {
  SharedPreferences? _prefs;

  SettingServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserState> getUserSession() async {
    UserModel attempUser =
        UserModel(username: _prefs!.getString(PreferencesKey.USERNAME));

    return AuthenticatedUser(model: attempUser);
  }

  Future<bool> saveUsername(String newUsername) async {
    return _prefs!.setString(PreferencesKey.USERNAME, newUsername);
  }
}
