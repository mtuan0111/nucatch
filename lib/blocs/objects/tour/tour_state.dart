/// Tour steps in order - following app navigation flow
enum TourStep {
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
  int get totalSteps => TourStep.values.length;

  /// Current tour step enum
  TourStep get currentTourStep => TourStep.values[currentStep];

  /// Check if this is the first step
  bool get isFirstStep => currentStep == 0;

  /// Check if this is the last step
  bool get isLastStep => currentStep == totalSteps - 1;

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
