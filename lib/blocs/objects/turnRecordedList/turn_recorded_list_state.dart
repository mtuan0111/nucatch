import 'package:nucatch_with_bloc/models/turn_record_model.dart';

class TurnRecordedListState {
  final int numberOfTopBoard;
  final List<TurnRecordedModel>? _listModel;

  TurnRecordedListState({
    required this.numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
  }) : _listModel = listModel;

  TurnRecordedListState copyWith({
    int? numberOfTopBoard,
    List<TurnRecordedModel>? listModel,
  }) {
    return TurnRecordedListState(
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      listModel: listModel ?? _listModel,
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
}
