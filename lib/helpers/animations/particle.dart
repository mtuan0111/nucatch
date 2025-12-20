import 'dart:math';
import 'package:flutter/material.dart';

/// Represents a single particle in a particle effect
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifetime; // 0.0 to 1.0, where 1.0 is fully alive
  double maxLifetime;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.maxLifetime,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  }) : lifetime = 1.0;

  /// Update particle physics (gravity, velocity, fade)
  void update(double dt) {
    // Apply gravity
    velocity = Offset(
      velocity.dx,
      velocity.dy + 500 * dt, // Gravity acceleration
    );

    // Update position
    position = Offset(
      position.dx + velocity.dx * dt,
      position.dy + velocity.dy * dt,
    );

    // Update rotation
    rotation += rotationSpeed * dt;

    // Decay lifetime
    lifetime -= dt / maxLifetime;
  }

  /// Check if particle should be removed
  bool get isDead => lifetime <= 0.0;

  /// Get current opacity based on lifetime
  double get opacity => lifetime.clamp(0.0, 1.0);
}

/// Custom painter for rendering particles efficiently
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Draw particle as a circle with optional glow effect
      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Main particle
      canvas.drawCircle(Offset.zero, particle.size, paint);

      // Glow effect for more visual impact
      if (particle.opacity > 0.5) {
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset.zero, particle.size * 1.5, glowPaint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// Factory for creating particle configurations
class ParticleFactory {
  static final Random _random = Random();

  /// Create a small burst of particles (for point scoring)
  static List<Particle> createSmallBurst({
    required Offset position,
    int count = 6,
  }) {
    final particles = <Particle>[];
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.amber,
    ];

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi + _random.nextDouble() * 0.5;
      final speed = 150.0 + _random.nextDouble() * 100.0;

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed - 100, // Initial upward bias
        ),
        color: colors[_random.nextInt(colors.length)],
        size: 3.0 + _random.nextDouble() * 2.0,
        maxLifetime: 0.6 + _random.nextDouble() * 0.2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      ));
    }

    return particles;
  }

  /// Create a large explosion of particles (for gaining life)
  static List<Particle> createLargeExplosion({
    required Offset position,
    int count = 18,
  }) {
    final particles = <Particle>[];
    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.yellow,
      Colors.orange,
    ];

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi + _random.nextDouble() * 0.3;
      final speed = 200.0 + _random.nextDouble() * 150.0;

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed - 150, // Strong upward bias
        ),
        color: colors[_random.nextInt(colors.length)],
        size: 4.0 + _random.nextDouble() * 3.0,
        maxLifetime: 1.0 + _random.nextDouble() * 0.5,
        rotationSpeed: (_random.nextDouble() - 0.5) * 15,
      ));
    }

    return particles;
  }

  /// Create confetti-style particles with slower fall
  static List<Particle> createConfetti({
    required Offset position,
    int count = 20,
  }) {
    final particles = <Particle>[];
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
    ];

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi + _random.nextDouble() * 0.4;
      final speed = 250.0 + _random.nextDouble() * 100.0;

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed - 200, // Very strong upward bias
        ),
        color: colors[_random.nextInt(colors.length)],
        size: 5.0 + _random.nextDouble() * 3.0,
        maxLifetime: 1.5 + _random.nextDouble() * 0.5,
        rotationSpeed: (_random.nextDouble() - 0.5) * 20,
      ));
    }

    return particles;
  }
}
