import 'dart:io';

/// Tour steps in order - following app navigation flow
enum TourStep {
  welcome, // Welcome and introduce the tour
  startButton, // Point to Start button on main menu
  soloMode, // Explain solo mode on SelectPlayMode screen
  combatMode, // Explain combat mode on SelectPlayMode screen
  createRoom, // Explain create room on CombatModeSetup screen
  joinRoom, // Explain join room on CombatModeSetup screen
  leaderboard, // Point to leaderboard on main menu
  settings, // Point to settings on main menu
}

class TourState {
  final bool isFirstLaunch;
  final bool isTourActive;
  final int currentStep;
  final bool hasCompletedTour;
  final String? currentScreen; // Track which screen the tour is on
  final bool useSpotlightMode; // Toggle between dialog and spotlight modes

  const TourState({
    this.isFirstLaunch = true,
    this.isTourActive = false,
    this.currentStep = 0,
    this.hasCompletedTour = false,
    this.currentScreen,
    this.useSpotlightMode = true, // Default to spotlight mode
  });

  /// Total number of tour steps
  /// iOS: 5 steps (skips combat mode, create room, join room)
  /// Android: 8 steps (all steps)
  int get totalSteps {
    // if (Platform.isIOS) {
    //   // iOS: welcome, startButton, soloMode, leaderboard, settings = 5 steps
    //   return TourStep.values.length -
    //       3; // Exclude combatMode, createRoom, joinRoom
    // }
    return TourStep.values.length; // Android: all 8 steps
  }

  /// Current tour step enum
  TourStep get currentTourStep => TourStep.values[currentStep];

  /// Check if this is the first step
  bool get isFirstStep => currentStep == 0;

  /// Get the display step number for progress indicator
  /// iOS: Maps actual indices to display numbers (skipping combat steps)
  /// Android: Uses actual step index + 1
  int get displayStepNumber {
    // if (Platform.isIOS) {
    //   // Map actual step indices to display numbers for iOS
    //   switch (currentTourStep) {
    //     case TourStep.welcome:
    //       return 1;
    //     case TourStep.startButton:
    //       return 2;
    //     case TourStep.soloMode:
    //       return 3;
    //     case TourStep.leaderboard:
    //       return 4; // Skip combat steps (3-5 in enum)
    //     case TourStep.settings:
    //       return 5;
    //     default:
    //       return currentStep + 1; // Fallback
    //   }
    // }
    return currentStep + 1; // Android: normal 1-based indexing
  }

  /// Check if this is the last step
  /// iOS: last step is settings (step 7 in enum, but 5th shown step)
  /// Android: last step is settings (step 7 in enum, 8th shown step)
  bool get isLastStep {
    if (Platform.isIOS) {
      // On iOS, settings is the last step (skip combat steps)
      return currentTourStep == TourStep.settings;
    }
    return currentStep == totalSteps - 1;
  }

  /// Check if tour should be shown (first launch and not completed)
  bool get shouldShowTour => isFirstLaunch && !hasCompletedTour;

  TourState copyWith({
    bool? isFirstLaunch,
    bool? isTourActive,
    int? currentStep,
    bool? hasCompletedTour,
    String? currentScreen,
    bool? useSpotlightMode,
  }) {
    return TourState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isTourActive: isTourActive ?? this.isTourActive,
      currentStep: currentStep ?? this.currentStep,
      hasCompletedTour: hasCompletedTour ?? this.hasCompletedTour,
      currentScreen: currentScreen ?? this.currentScreen,
      useSpotlightMode: useSpotlightMode ?? this.useSpotlightMode,
    );
  }

  @override
  String toString() {
    return 'TourState(isFirstLaunch: $isFirstLaunch, isTourActive: $isTourActive, currentStep: $currentStep/$totalSteps, hasCompletedTour: $hasCompletedTour, currentScreen: $currentScreen, useSpotlightMode: $useSpotlightMode)';
  }
}
