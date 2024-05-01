import 'dart:convert';

import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/models/turn_record_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TurnRecordedServices {
  SharedPreferences? _prefs;

  List<TurnRecordedModel>? turnedRecordedList;

  TurnRecordedServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<TurnRecordedModel>?> getTurnedList() async {
    turnedRecordedList =
        _prefs!.getStringList(PreferencesKey.LIST_TURN_RECORDED)?.map((e) {
      return TurnRecordedModel.fromJSON(json.decode(e));
    }).toList();

    return turnedRecordedList;
  }

  Future<bool> addItem(TurnRecordedModel item) async {
    turnedRecordedList ?? [].add(item);

    return _prefs!.setStringList(
        PreferencesKey.LIST_TURN_RECORDED,
        turnedRecordedList!
            .map(
              (e) => e.toString(),
            )
            .toList());
  }
}
