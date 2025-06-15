import 'package:flutter/material.dart';
import 'package:nucatch/models/setting_model.dart';

class SettingState {
  final SettingModel model;
  final bool isLoading;

  SettingState({
    SettingModel? model,
    this.isLoading = true,
  }) : model = model ?? SettingModel();

  SettingState copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    bool? isVibrate,
    int? fontSize,
    int? numberOfTopBoard,
    bool? isLoading,
    SettingModel? model,
  }) {
    final currentModel = model ?? this.model;
    return SettingState(
      model: SettingModel(
        themeMode: themeMode ?? currentModel.themeMode,
        locale: locale ?? currentModel.locale,
        vol: vol ?? currentModel.vol,
        isVibrate: isVibrate ?? currentModel.isVibrate,
        fontSize: fontSize ?? currentModel.fontSize,
        numberOfTopBoard: numberOfTopBoard ?? currentModel.numberOfTopBoard,
      ),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  String get locale => model.locale;
  int get fontSize => model.fontSize;
  int get vol => model.vol;
  bool get isVibrate => model.isVibrate;
  int get numberOfTopBoard => model.numberOfTopBoard;
  ThemeMode get themeMode => model.themeMode;
}
