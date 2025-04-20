import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_state.dart';
import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/services/audio_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SharedPreferences? _prefs;
  late AudioServices _audioServices;

  SettingBloc() : super(SettingState()) {
    on<LoadData>(_onLoadData);

    on<ChangedThemeMode>(_onChangedThemeMode);
    on<ChangedLocale>(_onChangedLocale);
    on<ChangedVol>(_onChangedVol);
    on<ChangedFontSize>(_onChangedFontSize);
    on<ChangedNumberOfTopBoard>(_onChangedNumberOfTopBoard);

    _audioServices = AudioServices();

    add(LoadData());
  }

  Future<void> _onLoadData(
    LoadData event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();

    emitter(
      state.copyWith(
        themeMode: ThemeMode.values.where((element) => true).first,
        locale: _prefs!.getString(PreferencesKey.LOCALE),
        vol: _prefs!.getInt(PreferencesKey.VOL),
        fontSize: _prefs!.getInt(PreferencesKey.FONT_SIZE),
        numberOfTopBoard: _prefs!.getInt(PreferencesKey.NUMBER_OF_TOP_BOARD),
        isLoading: false,
      ),
    );
  }

  Future<void> _onChangedThemeMode(
    ChangedThemeMode event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setString(PreferencesKey.THEME_MODE, event.themeMode.name);

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
    _prefs ??= await SharedPreferences.getInstance();

    _prefs!.setString(PreferencesKey.LOCALE, event.locale);

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
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.VOL, event.vol);

    emitter(
      state.copyWith(
        vol: event.vol,
      ),
    );

    _audioServices.setVolume = event.vol / 10;
    _audioServices.playCorrect();
  }

  Future<void> _onChangedFontSize(
    ChangedFontSize event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.FONT_SIZE, event.fontSize);

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
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.NUMBER_OF_TOP_BOARD, event.numberOfTopBoard);

    emitter(
      state.copyWith(
        numberOfTopBoard: event.numberOfTopBoard,
      ),
    );
  }
}
