class TurnModel {
  final int level;
  final int point;

  final String? challangeNumber;
  final String? inputingNumber;

  TurnModel({
    required this.level,
    required this.point,
    this.challangeNumber,
    this.inputingNumber,
  });
}
