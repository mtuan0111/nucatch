import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  late final FirebaseAuth? _auth;
  SharedPreferences? _prefs;
  bool _isOfflineMode = false;
  String? _offlineUserId;

  AuthServices() {
    try {
      _auth = FirebaseAuth.instance;
    } catch (e) {
      print('⚠️ Firebase Auth not available (offline mode): $e');
      _auth = null;
      _isOfflineMode = true;
    }
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get current Firebase user (or offline user)
  User? get currentUser {
    if (_isOfflineMode) {
      // Return a mock user for offline mode
      return null; // We'll handle this in the calling code
    }
    return _auth?.currentUser;
  }

  /// Check if we're in offline mode
  bool get isOfflineMode => _isOfflineMode;

  /// Get offline user ID
  String? get offlineUserId => _offlineUserId;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    if (_isOfflineMode) {
      // Return empty stream for offline mode
      return Stream.empty();
    }
    return _auth!.authStateChanges();
  }

  /// Sign in anonymously (works offline)
  Future<UserCredential?> signInAnonymously() async {
    if (_isOfflineMode) {
      // Generate offline user ID
      _offlineUserId = 'offline_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
      await _prefs?.setString(
        PreferencesKey.FIREBASE_USER_ID,
        _offlineUserId!,
      );
      print('✅ Signed in anonymously (offline mode): $_offlineUserId');
      return null; // No UserCredential in offline mode
    }

    try {
      final userCredential = await _auth!.signInAnonymously();

      // Save the anonymous user ID to preferences
      if (userCredential.user != null) {
        await _prefs?.setString(
          PreferencesKey.FIREBASE_USER_ID,
          userCredential.user!.uid,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to sign in anonymously: ${e.code} - ${e.message}');
      // Fallback to offline mode
      _isOfflineMode = true;
      return await signInAnonymously();
    } catch (e) {
      debugPrint('Failed to sign in anonymously: $e');
      // Fallback to offline mode
      _isOfflineMode = true;
      return await signInAnonymously();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_isOfflineMode) {
        _offlineUserId = null;
        print('✅ Signed out (offline mode)');
      } else {
        await _auth?.signOut();
      }
      await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
    } catch (e) {
      debugPrint('Failed to sign out: $e');
    }
  }

  /// Check if user is signed in
  bool isSignedIn() {
    if (_isOfflineMode) {
      return _offlineUserId != null;
    }
    return _auth?.currentUser != null;
  }

  /// Get stored Firebase user ID from preferences
  String? getStoredUserId() {
    return _prefs?.getString(PreferencesKey.FIREBASE_USER_ID);
  }

  /// Link anonymous account with credential (for future upgrade to email/phone auth)
  Future<UserCredential?> linkWithCredential(AuthCredential credential) async {
    if (_isOfflineMode) {
      debugPrint('Cannot link credential in offline mode');
      return null;
    }
    
    try {
      final user = _auth?.currentUser;
      if (user != null && user.isAnonymous) {
        return await user.linkWithCredential(credential);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to link credential: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Failed to link credential: $e');
      return null;
    }
  }

  /// Delete current user account
  Future<bool> deleteAccount() async {
    if (_isOfflineMode) {
      _offlineUserId = null;
      await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
      debugPrint('Deleted offline account');
      return true;
    }
    
    try {
      final user = _auth?.currentUser;
      if (user != null) {
        await user.delete();
        await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to delete account: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Failed to delete account: $e');
      return false;
    }
  }
}
