// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tour_event.dart';
import 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  static const String _tourCompletedKey = 'has_completed_tour';
  static const String _currentStepKey = 'tour_current_step';

  TourBloc() : super(const TourState()) {
    on<TourStarted>(_onTourStarted);
    on<TourStepCompleted>(_onTourStepCompleted);
    on<TourStepBack>(_onTourStepBack);
    on<TourSkipped>(_onTourSkipped);
    on<TourCompleted>(_onTourCompleted);
    on<TourReset>(_onTourReset);
    on<TourJumpToStep>(_onTourJumpToStep);
    on<_TourStateLoaded>(_onTourStateLoaded);

    // Load tour state on initialization
    _loadTourState();
  }

  Future<void> _loadTourState() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool(_tourCompletedKey) ?? false;
    final currentStep = prefs.getInt(_currentStepKey) ?? 0;

    // Update state based on saved preferences
    // For first-time users (hasCompleted = false), set isFirstLaunch = true
    add(_TourStateLoaded(
      isFirstLaunch: !hasCompleted,
      hasCompletedTour: hasCompleted,
      currentStep: currentStep,
    ));
  }

  Future<void> _saveTourState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tourCompletedKey, state.hasCompletedTour);
    await prefs.setInt(_currentStepKey, state.currentStep);
  }

  Future<void> _onTourStarted(
    TourStarted event,
    Emitter<TourState> emit,
  ) async {
    emit(state.copyWith(
      isTourActive: true,
      currentStep: 0,
    ));
    await _saveTourState();
  }

  Future<void> _onTourStepCompleted(
    TourStepCompleted event,
    Emitter<TourState> emit,
  ) async {
    if (state.isLastStep) {
      // Last step completed, finish tour
      add(TourCompleted());
    } else {
      // Move to next step
      int nextStep = state.currentStep + 1;

      // // Skip combat-related steps for iOS users
      // if (Platform.isIOS) {
      //   nextStep = _getNextNonCombatStep(nextStep);
      // }

      emit(state.copyWith(
        currentStep: nextStep,
      ));
      await _saveTourState();
    }
  }

  Future<void> _onTourStepBack(
    TourStepBack event,
    Emitter<TourState> emit,
  ) async {
    if (!state.isFirstStep) {
      int previousStep = state.currentStep - 1;

      // // Skip combat-related steps for iOS users when going back
      // if (Platform.isIOS) {
      //   previousStep = _getPreviousNonCombatStep(previousStep);
      // }

      emit(state.copyWith(
        currentStep: previousStep,
      ));
      await _saveTourState();
    }
  }

  Future<void> _onTourSkipped(
    TourSkipped event,
    Emitter<TourState> emit,
  ) async {
    emit(state.copyWith(
      isTourActive: false,
      hasCompletedTour: true,
      isFirstLaunch: false, // Mark as no longer first launch
    ));
    await _saveTourState();
  }

  Future<void> _onTourCompleted(
    TourCompleted event,
    Emitter<TourState> emit,
  ) async {
    emit(state.copyWith(
      isTourActive: false,
      hasCompletedTour: true,
      isFirstLaunch: false,
    ));
    await _saveTourState();
  }

  Future<void> _onTourReset(
    TourReset event,
    Emitter<TourState> emit,
  ) async {
    emit(state.copyWith(
      isFirstLaunch: true,
      isTourActive: false,
      currentStep: 0,
      hasCompletedTour: false,
    ));
    await _saveTourState();
  }

  Future<void> _onTourJumpToStep(
    TourJumpToStep event,
    Emitter<TourState> emit,
  ) async {
    if (event.stepIndex >= 0 && event.stepIndex < state.totalSteps) {
      emit(state.copyWith(
        currentStep: event.stepIndex,
      ));
      await _saveTourState();
    }
  }

  Future<void> _onTourStateLoaded(
    _TourStateLoaded event,
    Emitter<TourState> emit,
  ) async {
    emit(state.copyWith(
      isFirstLaunch: event.isFirstLaunch,
      hasCompletedTour: event.hasCompletedTour,
      currentStep: event.currentStep,
    ));

    // Auto-start tour for first-time users
    if (event.isFirstLaunch && !event.hasCompletedTour) {
      // Small delay to ensure UI is ready
      await Future.delayed(
          const Duration(milliseconds: kAnimationDurationSlow));
      add(TourStarted());
    }
  }
}

// Internal event for loading saved state
class _TourStateLoaded extends TourEvent {
  final bool isFirstLaunch;
  final bool hasCompletedTour;
  final int currentStep;

  _TourStateLoaded({
    required this.isFirstLaunch,
    required this.hasCompletedTour,
    required this.currentStep,
  });
}
