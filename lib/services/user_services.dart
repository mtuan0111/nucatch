import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // SharedPreferences _prefs;

  UserServices();

  // Future<UserState> loadSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  Future<UserState> getUserSession() async {
    // await Future.delayed(const Duration(seconds: 1));

    UserModel attempUser = UserModel(name: "BOM", settings: null);

    return AuthenticatedUser(model: attempUser);
  }
}
