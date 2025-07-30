import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';

class SettingModel {
  final ThemeMode themeMode;
  final String locale;
  final int vol;
  final bool isVibrate;
  final int fontSize;
  final int numberOfTopBoard;
  final Difficulty difficulty;

  SettingModel({
    this.themeMode = ThemeMode.system,
    this.locale = 'en',
    this.vol = 8,
    this.isVibrate = true,
    this.fontSize = 8,
    this.numberOfTopBoard = 20,
    this.difficulty = Difficulty.easy,
  });

  SettingModel copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    bool? isVibrate,
    int? fontSize,
    int? numberOfTopBoard,
    Difficulty? difficulty,
  }) {
    return SettingModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      vol: vol ?? this.vol,
      isVibrate: isVibrate ?? this.isVibrate,
      fontSize: fontSize ?? this.fontSize,
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
