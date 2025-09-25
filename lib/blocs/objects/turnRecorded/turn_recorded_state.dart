import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TurnRecordedState {
  final TurnRecordedModel model;
  final bool isLoading;
  final bool isCapturing;

  TurnRecordedState({
    required this.model,
    this.isLoading = true,
    this.isCapturing = false,
  });

  TurnRecordedState copyWith({
    TurnRecordedModel? model,
    bool? isLoading,
    bool? isCapturing,
  }) {
    return TurnRecordedState(
      model: model ?? this.model,
      isLoading: isLoading ?? this.isLoading,
      isCapturing: isCapturing ?? this.isCapturing,
    );
  }

  String get secureLink {
    return Helper.generateSecureLink(
      model.playedUsername ?? "",
      model.point.toString(),
      model.recordedTime,
      model.difficulty,
    );
  }
}
