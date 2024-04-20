import 'package:flutter/material.dart';
import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // late int _vol;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  Locale get countryLang => _settingsService.localLang;
  double get vol => _settingsService.vol.toDouble();
  double get fontSize => _settingsService.fontSize.toDouble();
  double get numberOfTurn => _settingsService.numberOfTurn.toDouble();

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    await _settingsService.loadSharedPreferences();
    _themeMode = await _settingsService.themeMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocale(Locale locale) async {
    await _settingsService.updateLocale(locale);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> updateVol(int value) async {
    await _settingsService.updateVol(value);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> updateFontSize(int value) async {
    await _settingsService.updateFontSize(value);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> updateNumberOfTurn(int value) async {
    await _settingsService.updateNumberOfTurn(value);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
