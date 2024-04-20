import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  SharedPreferences? _prefs;

  UserServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserState> getUserSession() async {
    _prefs ??= await SharedPreferences.getInstance();

    UserModel attempUser = UserModel(username: _prefs!.getString("username"));

    return AuthenticatedUser(model: attempUser);
  }

  Future<void> saveUsername(String newUsername) async {
    _prefs ??= await SharedPreferences.getInstance();

    _prefs!.setString("username", newUsername);
  }
}
