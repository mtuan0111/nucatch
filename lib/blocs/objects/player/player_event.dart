abstract class PlayerEvent {}

class Intro extends PlayerEvent {}

class Start extends PlayerEvent {}

// class MarkCorrectTurn extends PlayerEvent {
//   final int point;
//   final int level;

//   MarkCorrectTurn({
//     required this.point,
//     required this.level,
//   });
// }

class End extends PlayerEvent {}
