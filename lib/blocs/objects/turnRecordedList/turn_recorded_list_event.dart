abstract class TurnRecordedListEvent {}

class LoadData extends TurnRecordedListEvent {}

// class AddItem extends TurnRecordedListEvent {
//   final TurnRecordedModel item;
//   int? index;

//   AddItem({required this.item});
// }

class RemoveItem extends TurnRecordedListEvent {}

class ChangeNumberOfTopBoard extends TurnRecordedListEvent {
  final int numberOfTopBoard;

  ChangeNumberOfTopBoard({required this.numberOfTopBoard});
}
