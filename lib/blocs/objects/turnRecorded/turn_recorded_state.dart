import 'package:nucatch_with_bloc/models/turn_record_model.dart';

class TurnRecordedState {
  final TurnRecordedModel model;
  final bool isLoading;

  TurnRecordedState({
    required this.model,
    this.isLoading = true,
  });
}
