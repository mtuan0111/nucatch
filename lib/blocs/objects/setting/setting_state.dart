import 'package:flutter/material.dart';

class SettingState {
  final ThemeMode themeMode;

  final String locale;
  final int vol;
  final int fontSize;
  final int numberOfTopBoard;
  final bool isLoading;

  // final SharedPreferences prefs;

  SettingState({
    this.themeMode = ThemeMode.system,
    this.locale = "en",
    this.vol = 8,
    this.fontSize = 8,
    this.numberOfTopBoard = 20,
    this.isLoading = true,
    // required this.prefs,
  });

  // ThemeMode get themeMode => ThemeMode.values
  //     .where((element) => element.name == prefs.getString("themeMode"))
  //     .first;

  // Locale get locale => Locale(prefs.getString("locale") ?? "en");

  // int get vol => prefs.getInt("vol") ?? 8;

  // int get fontSize => prefs.getInt("fontSize") ?? 8;

  // int get numberOfTopBoard => prefs.getInt("numberOfTopBoard") ?? 8;

  SettingState copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    int? fontSize,
    int? numberOfTopBoard,
    bool? isLoading,
  }) {
    // prefs.setString(
    //     "themeMode", themeMode?.toString() ?? this.themeMode.toString());

    // prefs.setString("locale", locale ?? this.locale.countryCode!);

    // prefs.setInt("vol", vol ?? this.vol);

    // prefs.setInt("fontSize", fontSize ?? this.fontSize);
    // prefs.setInt("numberOfTopBoard", numberOfTopBoard ?? this.numberOfTopBoard);

    return SettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      vol: vol ?? this.vol,
      fontSize: fontSize ?? this.fontSize,
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
