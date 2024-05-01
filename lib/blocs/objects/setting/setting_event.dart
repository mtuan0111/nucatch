import 'package:flutter/material.dart';

abstract class SettingEvent {}

class LoadData extends SettingEvent {}

class ChangedThemeMode extends SettingEvent {
  final ThemeMode themeMode;

  ChangedThemeMode({required this.themeMode});
}

class ChangedVol extends SettingEvent {
  final int vol;

  ChangedVol({required this.vol});
}

class ChangedFontSize extends SettingEvent {
  final int fontSize;

  ChangedFontSize({required this.fontSize});
}

class ChangedNumberOfTopBoard extends SettingEvent {
  final int numberOfTopBoard;

  ChangedNumberOfTopBoard({required this.numberOfTopBoard});
}

class ChangedLocale extends SettingEvent {
  final String locale;

  ChangedLocale({required this.locale});
}
