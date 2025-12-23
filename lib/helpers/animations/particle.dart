import 'dart:math';
import 'package:flutter/material.dart';

/// Christmas theme configuration
class ChristmasTheme {
  static bool enabled = true; // Christmas theme enabled by default
}

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
  final bool isSnow; // True for snow particles

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.maxLifetime,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.isSnow = false,
  }) : lifetime = 1.0;

  /// Update particle physics (gravity, velocity, fade)
  void update(double dt) {
    // Apply gravity (slower for snow)
    final gravity = isSnow ? 30.0 : 500.0;
    velocity = Offset(
      velocity.dx,
      velocity.dy + gravity * dt, // Gravity acceleration
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
    List<Color>? colors,
  }) {
    final particles = <Particle>[];
    // Randomize particle count: 60% to 140% of specified count
    final actualCount = (count * (0.6 + _random.nextDouble() * 0.8)).round();
    final defaultColors = colors ??
        (ChristmasTheme.enabled
            ? [
                const Color(0xFFFF0000), // Christmas red
                const Color(0xFF00FF00), // Christmas green
                const Color(0xFFFFD700), // Gold
                const Color(0xFFFFFFFF), // White
                const Color(0xFFFF6B6B), // Light red
                const Color(0xFF90EE90), // Light green
                const Color(0xFFFFE082), // Warm gold
                const Color(0xFFC0C0C0), // Silver
              ]
            : [
                const Color(0xFFFF6B6B), // Warm red
                const Color(0xFFFF8E53), // Warm orange
                const Color(0xFFFFA726), // Light orange
                const Color(0xFFFFD54F), // Warm yellow
                const Color(0xFFFF7043), // Deep orange
                const Color(0xFFFF5252), // Bright red
                const Color(0xFFFFAB91), // Light coral
                const Color(0xFFFFE082), // Warm gold
              ]);

    for (int i = 0; i < actualCount; i++) {
      final angle = (i / actualCount) * 2 * pi + _random.nextDouble() * 0.5;
      final speed = 150.0 + _random.nextDouble() * 100.0;

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed - 100, // Initial upward bias
        ),
        color: defaultColors[_random.nextInt(defaultColors.length)],
        size: 2.0 + _random.nextDouble() * 5.0, // Random sizes from 2.0 to 7.0
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

  /// Create snow particles for Christmas theme
  static List<Particle> createSnow({
    required Size screenSize,
    int count = 30,
  }) {
    final particles = <Particle>[];
    final snowColors = [
      Colors.white,
      Colors.white.withOpacity(0.9),
      Colors.white.withOpacity(0.7),
      const Color(0xFFE0F7FF), // Very light blue
    ];

    for (int i = 0; i < count; i++) {
      // Random position across screen width and above screen
      final startX = _random.nextDouble() * screenSize.width;
      final startY = -_random.nextDouble() * screenSize.height;

      // Slow downward and slight horizontal drift
      final horizontalDrift = (_random.nextDouble() - 0.5) * 20;

      particles.add(Particle(
        position: Offset(startX, startY),
        velocity: Offset(horizontalDrift, 20.0 + _random.nextDouble() * 30.0),
        color: snowColors[_random.nextInt(snowColors.length)],
        size: 2.0 + _random.nextDouble() * 4.0,
        maxLifetime: 10.0 + _random.nextDouble() * 5.0, // Long lifetime
        rotationSpeed: (_random.nextDouble() - 0.5) * 2,
        isSnow: true,
      ));
    }

    return particles;
  }
}
