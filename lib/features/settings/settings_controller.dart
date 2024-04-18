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
  late Locale _countryLang;
  late int _vol;
  late int _fontSize;
  late int _numberOfTurn;

  // late int _vol;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  Locale get countryLang => _countryLang;
  double get vol => _vol.toDouble();
  double get fontSize => _fontSize.toDouble();
  double get numberOfTurn => _numberOfTurn.toDouble();

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _countryLang = _settingsService.localLang;
    _vol = _settingsService.vol;
    _fontSize = _settingsService.fontSize;
    _numberOfTurn = _settingsService.numberOfTurn;

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
    _countryLang = locale;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    await _settingsService.updateLocale(locale);
  }

  Future<void> updateVol(int value) async {
    _vol = value;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    await _settingsService.updateVol(value);
  }

  Future<void> updateFontSize(int value) async {
    _fontSize = value;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    await _settingsService.updateFontSize(value);
  }

  Future<void> updateNumberOfTurn(int value) async {
    _numberOfTurn = value;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    await _settingsService.updateNumberOfTurn(value);
  }
}
