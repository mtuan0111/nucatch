import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// Tour step data structure
class TourStepData {
  final TourStep step;
  final String titleKey;
  final String descriptionKey;
  final MenuOption? targetMenuOption;
  final IconData? icon;

  const TourStepData({
    required this.step,
    required this.titleKey,
    required this.descriptionKey,
    this.targetMenuOption,
    this.icon,
  });
}

/// Tour content configuration
class TourContent {
  static const List<TourStepData> steps = [
    // Step 1: Start Button on Main Menu
    TourStepData(
      step: TourStep.startButton,
      titleKey: 'tourStartTitle',
      descriptionKey: 'tourStartDesc',
      targetMenuOption: MenuOption.start,
    ),
    // Step 2: Solo Mode (on SelectPlayMode screen)
    TourStepData(
      step: TourStep.soloMode,
      titleKey: 'tourSoloTitle',
      descriptionKey: 'tourSoloDesc',
      targetMenuOption: null, // No menu option, shown on different screen
    ),
    // Step 3: Combat Mode (on SelectPlayMode screen)
    TourStepData(
      step: TourStep.combatMode,
      titleKey: 'tourCombatTitle',
      descriptionKey: 'tourCombatDesc',
      targetMenuOption: null,
    ),
    // Step 4: Create Room (on CombatModeSetup screen)
    TourStepData(
      step: TourStep.createRoom,
      titleKey: 'tourCreateRoomTitle',
      descriptionKey: 'tourCreateRoomDesc',
      targetMenuOption: null,
    ),
    // Step 5: Join Room (on CombatModeSetup screen)
    TourStepData(
      step: TourStep.joinRoom,
      titleKey: 'tourJoinRoomTitle',
      descriptionKey: 'tourJoinRoomDesc',
      targetMenuOption: null,
    ),
    // Step 6: Leaderboard (back on main menu)
    TourStepData(
      step: TourStep.leaderboard,
      titleKey: 'tourLeaderboardTitle',
      descriptionKey: 'tourLeaderboardDesc',
      targetMenuOption: MenuOption.topScore,
    ),
    // Step 7: Settings (on main menu)
    TourStepData(
      step: TourStep.settings,
      titleKey: 'tourSettingsTitle',
      descriptionKey: 'tourSettingsDesc',
      targetMenuOption: MenuOption.setting,
    ),
  ];

  /// Get tour step data by index
  static TourStepData getStep(int index) {
    if (index >= 0 && index < steps.length) {
      return steps[index];
    }
    return steps[0]; // Default to first step
  }

  /// Get tour step data by TourStep enum
  static TourStepData getStepByEnum(TourStep step) {
    return steps.firstWhere(
      (data) => data.step == step,
      orElse: () => steps[0],
    );
  }
}
