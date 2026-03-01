import 'package:flutter/material.dart';
import 'particle_system.dart';
import 'screen_shake_controller.dart';
import 'animation_constants.dart';

/// Main controller for game animation triggers
/// Provides three main animation events:
/// - onAddPoint: Small firework burst
/// - onGainLife: Large celebratory explosion
/// - onLostLife: Screen shake effect
class GameAnimationTriggers {
  final ParticleOverlayController particleController;
  final ScreenShakeController shakeController;

  GameAnimationTriggers({
    required this.particleController,
    required this.shakeController,
  });

  /// Trigger small firework effect when points are scored
  /// Position should be in screen coordinates (e.g., score counter position)
  void onAddPoint(Offset position, {List<Color>? colors}) {
    particleController.triggerSmallBurst(position, colors: colors);
    // Add light screen shake for impact (no red flash for positive feedback)
    shakeController.shake(kShakeLightIntensity, false);
  }

  /// Trigger large explosion when life is gained
  /// Position should be in screen coordinates (e.g., heart icon or screen center)
  void onGainLife(Offset position, {List<Color>? colors}) {
    particleController.triggerConfetti(position, colors: colors);
  }

  /// Trigger screen shake with red flash when life is lost
  /// Intensity: 0.0 (no shake) to 1.0 (maximum shake)
  void onLostLife([double intensity = kShakeDefaultIntensity]) {
    shakeController.shake(intensity, true); // Enable red flash
  }
}
