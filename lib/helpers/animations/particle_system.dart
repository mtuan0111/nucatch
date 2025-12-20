import 'package:flutter/material.dart';
import 'particle.dart';

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

  /// Update all particles based on elapsed time
  void update() {
    if (particles.isEmpty) return;

    // Update each particle (assuming ~60fps)
    for (final particle in particles) {
      particle.update(0.016);
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

  const ParticleOverlay({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ParticleSystem _particleSystem = ParticleSystem();

  @override
  void initState() {
    super.initState();

    // Create animation controller for continuous updates
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_onAnimationTick);

    // Listen to controller events
    widget.controller._addParticlesCallback = _addParticles;
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller._addParticlesCallback = null;
    super.dispose();
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
      _particleSystem.update();

      // Stop animation when no particles remain
      if (_particleSystem.isEmpty) {
        _animationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
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
  void triggerSmallBurst(Offset position) {
    trigger(ParticleFactory.createSmallBurst(position: position));
  }

  /// Trigger a large explosion at position
  void triggerLargeExplosion(Offset position) {
    trigger(ParticleFactory.createLargeExplosion(position: position));
  }

  /// Trigger confetti at position
  void triggerConfetti(Offset position) {
    trigger(ParticleFactory.createConfetti(position: position));
  }
}
