import 'dart:math';

import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TurnRecordedListState {
  final int numberOfTopBoard;
  final List<TurnRecordedModel>? _listModel;
  final bool isLoading;
  final RankingPeriod currentPeriod; // Now using enum

  TurnRecordedListState({
    required this.numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
    this.isLoading = true,
    this.currentPeriod = RankingPeriod.all, // Default to all time
  }) : _listModel = listModel;

  TurnRecordedListState copyWith({
    int? numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
    bool? isLoading,
    RankingPeriod? currentPeriod,
  }) {
    return TurnRecordedListState(
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      listModel: listModel ?? _listModel,
      isLoading: isLoading ?? this.isLoading,
      currentPeriod: currentPeriod ?? this.currentPeriod,
    );
  }

  List<TurnRecordedModel>? get listModel {
    List<TurnRecordedModel>? listModelResult = _listModel;

    listModelResult?.sort((a, b) => b.point.compareTo(a.point));

    return listModelResult;
  }

  int? indexOf(TurnRecordedModel item) {
    if (listModel == null) return null;

    if (!listModel!.contains(item)) return null;

    return listModel!.indexOf(item) + 1;
  }

  int? rankOfPoint(int point) {
    if (point == 0) return null;
    List<TurnRecordedModel> tempList = List.from(listModel ?? []);
    TurnRecordedModel tempModel = TurnRecordedModel(
        turnId: Random().nextInt(1000).toString(),
        point: point,
        recordedTime: DateTime.now(),
        difficulty: Difficulty.easy);

    tempList.add(tempModel);
    tempList.sort((a, b) => b.point.compareTo(a.point));

    int tempRank = tempList.indexOf(tempModel) + 1;

    if (tempRank > numberOfTopBoard) {
      return null;
    }

    return tempRank;
  }
}
