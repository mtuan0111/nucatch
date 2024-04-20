import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SharedPreferences? _prefs;

  SettingBloc() : super(SettingState()) {
    on<LoadSetting>(_onLoadSetting);

    on<ChangedThemeMode>(_onChangedThemeMode);
    on<ChangedLocale>(_onChangedLocale);
    on<ChangedVol>(_onChangedVol);
    on<ChangedFontSize>(_onChangedFontSize);
    on<ChangedNumberOfTopBoard>(_onChangedNumberOfTopBoard);

    add(LoadSetting());
  }

  Future<void> _onLoadSetting(
    LoadSetting event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs = await SharedPreferences.getInstance();

    emitter(
      state.copyWith(
        themeMode: ThemeMode.values.where((element) => true).first,
        locale: _prefs?.getString("locale"),
        vol: _prefs?.getInt("vol"),
        fontSize: _prefs?.getInt("fontSize"),
        numberOfTopBoard: _prefs?.getInt("numberOfTopBoard"),
        isLoading: false,
      ),
    );
  }

  Future<void> _onChangedThemeMode(
    ChangedThemeMode event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs?.setString("themeMode", event.themeMode.name);

    emitter(
      state.copyWith(
        themeMode: event.themeMode,
      ),
    );
  }

  Future<void> _onChangedLocale(
    ChangedLocale event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs?.setString("locale", event.locale);

    emitter(
      state.copyWith(
        locale: event.locale,
      ),
    );
  }

  Future<void> _onChangedVol(
    ChangedVol event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs?.setInt("vol", event.vol);

    emitter(
      state.copyWith(
        vol: event.vol,
      ),
    );
  }

  Future<void> _onChangedFontSize(
    ChangedFontSize event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs?.setInt("fontSize", event.fontSize);

    emitter(
      state.copyWith(
        fontSize: event.fontSize,
      ),
    );
  }

  Future<void> _onChangedNumberOfTopBoard(
    ChangedNumberOfTopBoard event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs?.setInt("numberOfTopBoard", event.numberOfTopBoard);

    emitter(
      state.copyWith(
        numberOfTopBoard: event.numberOfTopBoard,
      ),
    );
  }
}
