import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/user_model.dart';
import 'package:nucatch/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  SharedPreferences? _prefs;
  final AuthServices _authServices = AuthServices();

  UserServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserState> getUserSession() async {
    // Get username from preferences
    final username = _prefs?.getString(PreferencesKey.USERNAME);

    // Get Firebase user info
    final firebaseUser = _authServices.currentUser;

    UserModel userModel = UserModel(
      username: username,
      firebaseUserId: firebaseUser?.uid,
      isAnonymous: firebaseUser?.isAnonymous ?? true,
    );

    return AuthenticatedUser(model: userModel);
  }

  Future<bool> saveUsername(String newUsername) async {
    return _prefs!.setString(PreferencesKey.USERNAME, newUsername);
  }

  /// Initialize anonymous authentication
  Future<UserState> initializeAuth() async {
    // Check if user is already signed in
    if (!_authServices.isSignedIn()) {
      // Sign in anonymously
      final userCredential = await _authServices.signInAnonymously();
      if (userCredential == null) {
        return UnAuthenticatedUser();
      }
    }

    return await getUserSession();
  }
}
