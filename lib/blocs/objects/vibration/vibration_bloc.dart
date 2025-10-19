import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_event.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_state.dart';
import 'package:nucatch/services/audio_services.dart';

class VibrationBloc extends Bloc<VibrationEvent, VibrationState> {
  final VibrationServices _vibrationServices;

  VibrationBloc()
      : _vibrationServices = VibrationServices(),
        super(const VibrationState()) {
    on<VibrateShort>(_onVibrateShort);
    on<VibrateLong>(_onVibrateLong);
    on<VibrateMultiple>(_onVibrateMultiple);
    on<SetVibrationEnabled>(_onSetVibrationEnabled);
  }

  Future<void> _onVibrateShort(
    VibrateShort event,
    Emitter<VibrationState> emitter,
  ) async {
    if (!state.isEnabled) return;

    emitter(state.copyWith(
        isVibrating: true, lastVibrationDuration: event.duration));
    _vibrationServices.vibrate(duration: event.duration);

    // Simulate vibration completion
    await Future.delayed(Duration(milliseconds: event.duration));
    emitter(state.copyWith(isVibrating: false));
  }

  Future<void> _onVibrateLong(
    VibrateLong event,
    Emitter<VibrationState> emitter,
  ) async {
    if (!state.isEnabled) return;

    emitter(state.copyWith(
        isVibrating: true, lastVibrationDuration: event.duration));
    _vibrationServices.vibrate(duration: event.duration);

    // Simulate vibration completion
    await Future.delayed(Duration(milliseconds: event.duration));
    emitter(state.copyWith(isVibrating: false));
  }

  Future<void> _onVibrateMultiple(
    VibrateMultiple event,
    Emitter<VibrationState> emitter,
  ) async {
    if (!state.isEnabled) return;

    emitter(state.copyWith(isVibrating: true));
    _vibrationServices.multipleVibrate();

    // Simulate multiple vibration completion
    await Future.delayed(const Duration(milliseconds: 1000));
    emitter(state.copyWith(isVibrating: false));
  }

  void _onSetVibrationEnabled(
    SetVibrationEnabled event,
    Emitter<VibrationState> emitter,
  ) {
    _vibrationServices.setIsVibrate = event.enabled;
    emitter(state.copyWith(isEnabled: event.enabled));
  }
}
