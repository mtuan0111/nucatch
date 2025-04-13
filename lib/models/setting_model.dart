import 'package:flutter/material.dart';

class SettingModel {
  final ThemeMode themeMode;
  final String locale;
  final int vol;
  final int fontSize;
  final int numberOfTopBoard;

  SettingModel({
    this.themeMode = ThemeMode.system,
    this.locale = 'en',
    this.vol = 8,
    this.fontSize = 8,
    this.numberOfTopBoard = 20,
  });

  SettingModel copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    int? fontSize,
    int? numberOfTopBoard,
  }) {
    return SettingModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      vol: vol ?? this.vol,
      fontSize: fontSize ?? this.fontSize,
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
    );
  }
}
