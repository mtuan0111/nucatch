import 'package:nucatch_with_bloc/models/turn_record_model.dart';

abstract class TurnRecordedListEvent {}

class LoadData extends TurnRecordedListEvent {}

class AddItem extends TurnRecordedListEvent {
  final TurnRecordedModel item;
  int? index;

  AddItem({required this.item});
}

class RemoveItem extends TurnRecordedListEvent {}
