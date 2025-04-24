import 'dart:math';

import 'package:nucatch_with_bloc/models/turn_record_model.dart';

class TurnRecordedListState {
  final int numberOfTopBoard;
  final List<TurnRecordedModel>? _listModel;
  final bool isLoading;

  TurnRecordedListState({
    required this.numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
    this.isLoading = true,
  }) : _listModel = listModel;

  TurnRecordedListState copyWith({
    int? numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
    bool? isLoading,
  }) {
    return TurnRecordedListState(
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      listModel: listModel ?? _listModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<TurnRecordedModel>? get listModel {
    List<TurnRecordedModel>? listModelResult = _listModel;

    listModelResult?.sort((a, b) => b.point.compareTo(a.point));

    return listModelResult;
  }

  int indexOf(TurnRecordedModel item) {
    if (listModel == null) return -1;

    if (!listModel!.contains(item)) return -1;

    return listModel!.indexOf(item) + 1;
  }

  int? rankOfPoint(int point) {
    List<TurnRecordedModel> tempList = List.from(listModel ?? []);
    TurnRecordedModel tempModel = TurnRecordedModel(
      turnId: Random().nextInt(1000).toString(),
      point: point,
      recordedTime: DateTime.now(),
    );

    tempList.add(tempModel);
    tempList.sort((a, b) => b.point.compareTo(a.point));

    int tempRank = tempList.indexOf(tempModel) + 1;

    if (tempRank > numberOfTopBoard) {
      return null;
    }

    return tempRank;
  }
}
