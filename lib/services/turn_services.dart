import 'dart:convert';
import 'dart:developer';

import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/models/turn_record_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TurnRecordedServices {
  SharedPreferences? _prefs;

  List<TurnRecordedModel>? turnedRecordedList;

  TurnRecordedServices() {}

  Future<SharedPreferences> get pref async {
    await loadSharedPreferences();
    return _prefs!;
  }

  Future<SharedPreferences> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<TurnRecordedModel>?> getTurnedList() async {
    turnedRecordedList =
        (await pref).getStringList(PreferencesKey.LIST_TURN_RECORDED)?.map((e) {
      return TurnRecordedModel.fromJSON(json.decode(e));
    }).toList();

    return turnedRecordedList;
  }

  Future<bool> addItem(TurnRecordedModel item) async {
    List<TurnRecordedModel> addedList = (await getTurnedList() ?? []);
    addedList.add(item);

    return _prefs!.setStringList(
        PreferencesKey.LIST_TURN_RECORDED,
        addedList.map(
          (e) {
            log(e.toString());
            return e.toString();
          },
        ).toList());
  }
}
