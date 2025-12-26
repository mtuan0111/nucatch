import 'package:flutter/material.dart';
import 'package:nucatch/helpers/animations/screen_shake_controller.dart';
import 'particle.dart';
import 'package:nucatch/helpers/theme_config.dart';
import 'animation_constants.dart';

/// Manages the lifecycle of particles for a single effect
class ParticleSystem {
  final List<Particle> particles = [];
  DateTime? _startTime;

  ParticleSystem();

  /// Add particles to the system
  void addParticles(List<Particle> newParticles) {
    particles.addAll(newParticles);
    _startTime ??= DateTime.now();
  }

  /// Update all particles based on elapsed time with optional wind force
  void update({Offset windForce = Offset.zero}) {
    if (particles.isEmpty) return;

    // Update each particle (assuming ~60fps)
    for (final particle in particles) {
      particle.update(kParticleUpdateDelta, windForce: windForce);
    }

    // Remove dead particles
    particles.removeWhere((p) => p.isDead);
  }

  /// Check if system is empty
  bool get isEmpty => particles.isEmpty;

  /// Clear all particles
  void clear() {
    particles.clear();
    _startTime = null;
  }
}

/// Widget that overlays and manages particle effects
class ParticleOverlay extends StatefulWidget {
  final Widget child;
  final ParticleOverlayController controller;
  final ScreenShakeController? shakeController;

  const ParticleOverlay({
    Key? key,
    required this.child,
    required this.controller,
    this.shakeController,
  }) : super(key: key);

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ParticleSystem _particleSystem = ParticleSystem();
  final ParticleSystem _snowSystem = ParticleSystem();

  @override
  void initState() {
    super.initState();

    // Create animation controller for continuous updates
    _animationController = AnimationController(
      vsync: this,
      duration: kParticleAnimationDuration,
    )..addListener(_onAnimationTick);

    // Listen to controller events
    widget.controller._addParticlesCallback = _addParticles;

    // Start snow if seasonal theme has snow enabled
    if (SeasonalTheme.config.enableSnow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startSnow();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller._addParticlesCallback = null;
    super.dispose();
  }

  void _startSnow() {
    // Add initial snow particles
    final screenSize = MediaQuery.of(context).size;
    _snowSystem.addParticles(ParticleFactory.createSnow(
        screenSize: screenSize, count: kSnowInitialCount));

    if (!_animationController.isAnimating) {
      _animationController.repeat();
    }
  }

  void _addParticles(List<Particle> particles) {
    _particleSystem.addParticles(particles);

    // Start animation if not already running
    if (!_animationController.isAnimating) {
      _animationController.forward(from: 0.0);
    }
  }

  void _onAnimationTick() {
    setState(() {
      // Get wind force from shake controller if available
      final windForce = widget.shakeController?.getWindForce() ?? Offset.zero;

      _particleSystem.update(windForce: windForce);

      // Update snow system for seasonal themes
      if (SeasonalTheme.config.enableSnow) {
        _snowSystem.update(windForce: windForce);

        // Replenish snow particles when they fall off screen
        final screenSize = MediaQuery.of(context).size;
        _snowSystem.particles.removeWhere(
            (p) => p.position.dy > screenSize.height + kSnowRemovalOffset);

        // Add new snow particles periodically to maintain count
        if (_snowSystem.particles.length < kSnowMinimumCount) {
          _snowSystem.addParticles(ParticleFactory.createSnow(
              screenSize: screenSize, count: kSnowReplenishCount));
        }
      }

      // Stop animation when no particles remain (only if snow is disabled)
      if (!SeasonalTheme.config.enableSnow &&
          _particleSystem.isEmpty &&
          _snowSystem.isEmpty) {
        _animationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Fog overlay for seasonal themes
        if (SeasonalTheme.config.enableFog)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: SeasonalTheme.config.getFogColors(),
                  ),
                ),
              ),
            ),
          ),
        // Snow particles (rendered behind regular particles)
        if (SeasonalTheme.config.enableSnow && _snowSystem.particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ParticlePainter(_snowSystem.particles),
              ),
            ),
          ),
        // Regular particles (fireworks, etc.)
        if (_particleSystem.particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ParticlePainter(_particleSystem.particles),
              ),
            ),
          ),
      ],
    );
  }
}

/// Controller for triggering particle effects
class ParticleOverlayController {
  void Function(List<Particle>)? _addParticlesCallback;

  /// Trigger a particle effect
  void trigger(List<Particle> particles) {
    _addParticlesCallback?.call(particles);
  }

  /// Trigger a small burst at position
  void triggerSmallBurst(Offset position, {List<Color>? colors}) {
    trigger(
        ParticleFactory.createSmallBurst(position: position, colors: colors));
  }

  /// Trigger a large explosion at position
  void triggerLargeExplosion(Offset position, {List<Color>? colors}) {
    trigger(ParticleFactory.createLargeExplosion(
        position: position, colors: colors));
  }

  /// Trigger confetti at position
  void triggerConfetti(Offset position, {List<Color>? colors}) {
    trigger(ParticleFactory.createConfetti(position: position, colors: colors));
  }

  /// Trigger gold coin rain from position or across screen
  void triggerGoldCoinRain(Size screenSize,
      {Offset? position, int count = 15}) {
    trigger(ParticleFactory.createGoldCoinRain(
      screenSize: screenSize,
      position: position,
      count: count,
    ));
  }
}
