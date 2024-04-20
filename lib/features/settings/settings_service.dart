import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  SharedPreferences? prefs;

  SettingsService();

  Future<void> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  int get vol => prefs?.getInt("vol") ?? 8;
  int get fontSize => prefs?.getInt("fontSize") ?? 8;
  int get numberOfTurn => prefs?.getInt("numberOfTurn") ?? 20;
  Locale get localLang => Locale(prefs?.getString("localLang") ?? "en");

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> updateLocale(Locale locale) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    prefs?.setString("localLang", locale.languageCode);
  }

  Future<void> updateVol(int vol) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    prefs?.setInt("vol", vol);
  }

  Future<void> updateFontSize(int fontSize) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network
    prefs?.setInt("fontSize", fontSize);
  }

  Future<void> updateNumberOfTurn(int numberOfTurn) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    prefs?.setInt("numberOfTurn", numberOfTurn);
  }
}
