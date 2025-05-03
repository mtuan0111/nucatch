import 'package:flutter/material.dart';
import 'package:nucatch/models/setting_model.dart';

class SettingState {
  // final ThemeMode themeMode;

  // final String locale;
  // final int vol;
  // final int fontSize;
  // final int numberOfTopBoard;

  SettingModel? model;
  final bool isLoading;

  SettingState({
    this.model,
    this.isLoading = true,
  }) {
    model ??= SettingModel();
  }

  SettingState copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    int? fontSize,
    int? numberOfTopBoard,
    bool? isLoading,
    SettingModel? model,
  }) {
    return SettingState(
      model: SettingModel(
        themeMode: themeMode ?? model?.themeMode ?? this.model!.themeMode,
        locale: locale ?? model?.locale ?? this.model!.locale,
        vol: vol ?? model?.vol ?? this.model!.vol,
        fontSize: fontSize ?? model?.fontSize ?? this.model!.fontSize,
        numberOfTopBoard: numberOfTopBoard ??
            model?.numberOfTopBoard ??
            this.model!.numberOfTopBoard,
      ),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  String get locale => model!.locale;

  int get fontSize => model!.fontSize;

  int get vol => model!.vol;

  int get numberOfTopBoard => model!.numberOfTopBoard;

  // String get locale => model!.locale;

  ThemeMode get themeMode => model!.themeMode;
}
