import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _prefs;

  AuthServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in anonymously
  Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();

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
      return null;
    } catch (e) {
      debugPrint('Failed to sign in anonymously: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
    } catch (e) {
      debugPrint('Failed to sign out: $e');
    }
  }

  /// Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  /// Get stored Firebase user ID from preferences
  String? getStoredUserId() {
    return _prefs?.getString(PreferencesKey.FIREBASE_USER_ID);
  }

  /// Link anonymous account with credential (for future upgrade to email/phone auth)
  Future<UserCredential?> linkWithCredential(AuthCredential credential) async {
    try {
      final user = _auth.currentUser;
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
    try {
      final user = _auth.currentUser;
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
