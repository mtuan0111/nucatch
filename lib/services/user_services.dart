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

    String? userId;
    bool isAnonymous = true;

    if (_authServices.isOfflineMode) {
      // Offline mode - use offline user ID
      userId = _authServices.offlineUserId;
      print('📱 User session (offline mode): $userId');
    } else {
      // Online mode - use Firebase user
      final firebaseUser = _authServices.currentUser;
      userId = firebaseUser?.uid;
      isAnonymous = firebaseUser?.isAnonymous ?? true;
      print('☁️ User session (online mode): $userId');
    }

    UserModel userModel = UserModel(
      username: username,
      firebaseUserId: userId,
      isAnonymous: isAnonymous,
    );

    return AuthenticatedUser(model: userModel);
  }

  Future<bool> saveUsername(String newUsername) async {
    return _prefs!.setString(PreferencesKey.USERNAME, newUsername);
  }

  /// Initialize anonymous authentication (works offline)
  Future<UserState> initializeAuth() async {
    // Check if user is already signed in
    if (!_authServices.isSignedIn()) {
      // Sign in anonymously (works in offline mode)
      final userCredential = await _authServices.signInAnonymously();

      if (_authServices.isOfflineMode) {
        print('✅ Authenticated in offline mode');
      } else if (userCredential == null) {
        print('⚠️ Authentication failed, falling back to offline mode');
        // This should trigger offline mode in AuthServices
      }
    }

    return await getUserSession();
  }
}
