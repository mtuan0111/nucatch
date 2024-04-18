import 'package:flutter/material.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  Locale localLang;
  int vol;
  int fontSize;
  int numberOfTurn;

  SettingsService({
    this.localLang = const Locale("en"),
    this.vol = 8,
    this.fontSize = 8,
    this.numberOfTurn = 20,
  });

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
    localLang = locale;
  }

  Future<void> updateVol(int vol) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    vol = vol;
  }

  Future<void> updateFontSize(int fontSize) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    fontSize = fontSize;
  }

  Future<void> updateNumberOfTurn(int numberOfTurn) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    numberOfTurn = numberOfTurn;
  }
}
