import 'package:flutter/material.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/widgets/tour_spotlight_overlay.dart';

/// Wrapper that shows either dialog-based or spotlight-based tour
/// based on TourState.useSpotlightMode flag
class TourModeWrapper {
  /// Shows spotlight overlay if useSpotlightMode is true
  /// Returns null if dialog mode should be used instead
  static Widget? buildSpotlightIfEnabled({
    required TourState tourState,
    required GlobalKey targetKey,
    required String title,
    required String description,
    required bool allowTargetTap,
    required String skipText,
    required String previousText,
    required String nextText,
    required String finishText,
    VoidCallback? onTargetTap,
  }) {
    if (!tourState.useSpotlightMode) {
      return null; // Use dialog mode instead
    }

    return TourSpotlightOverlay(
      targetKey: targetKey,
      title: title,
      description: description,
      allowTargetTap: allowTargetTap,
      onTargetTap: onTargetTap,
      tourState: tourState,
      skipText: skipText,
      previousText: previousText,
      nextText: nextText,
      finishText: finishText,
    );
  }
}
