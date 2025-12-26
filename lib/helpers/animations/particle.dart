import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nucatch/helpers/theme_config.dart';
import 'animation_constants.dart';

/// Shape types for particles
enum ParticleShape {
  // Basic
  circle,
  heart,
  leaf,

  // Christmas
  ornament,
  icicle,
  snowflake,

  // New Year
  ribbon,
  confetti,
  champagneBubble,

  // Valentine
  rosePetal,
  cupidArrow,

  // St. Patrick's Day
  goldCoin,
  horseshoe,

  // Easter
  paintedEgg,
  pastelRibbon,

  // Earth Day / Nature
  vine,
  raindrop,
  seed,
  mapleLeaf,
  acorn,

  // Halloween
  spider,
  cobweb,
  bat,
  ghost,

  // Lunar New Year
  redEnvelope,
  paperLantern,
  chineseKnot,

  // Diwali
  marigold,
  fairyLight,
  mangoLeaf,

  // Pride
  glitter,
  bunting,

  // Peace Day
  paperCrane,
  feather,
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
  final ParticleShape shape; // Shape of the particle

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.maxLifetime,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.isSnow = false,
    this.shape = ParticleShape.circle,
  }) : lifetime = 1.0;

  /// Update particle physics (gravity, velocity, fade)
  void update(double dt, {Offset windForce = Offset.zero}) {
    // Get physics properties based on particle shape
    final physics = _getPhysicsForShape(shape);

    // Apply gravity with material-specific weight
    velocity = Offset(
      velocity.dx,
      velocity.dy + physics.gravity * dt,
    );

    // Apply wind force (lighter particles are more affected by wind)
    if (windForce != Offset.zero) {
      // Wind sensitivity: lighter particles (lower gravity) are pushed more
      // Heavy particles resist wind better
      final windSensitivity = 1.0 -
          (physics.gravity / kWindSensitivityDivisor)
              .clamp(0.0, kWindSensitivityMax);
      velocity = Offset(
        velocity.dx + (windForce.dx * windSensitivity * dt),
        velocity.dy,
      );
    }

    // Apply air resistance (drag)
    velocity = Offset(
      velocity.dx * physics.drag,
      velocity.dy * physics.drag,
    );

    // Apply horizontal drift/sway for light materials
    if (physics.sway > 0) {
      final swayForce =
          sin(position.dy * kSwayFrequency + rotation) * physics.sway;
      velocity = Offset(
        velocity.dx + swayForce * dt,
        velocity.dy,
      );
    }

    // Update position
    position = Offset(
      position.dx + velocity.dx * dt,
      position.dy + velocity.dy * dt,
    );

    // Update rotation with material-specific spin
    rotation += rotationSpeed * physics.rotationMultiplier * dt;

    // Decay lifetime
    lifetime -= dt / maxLifetime;
  }

  /// Get physics properties based on particle shape
  static ParticlePhysics _getPhysicsForShape(ParticleShape shape) {
    switch (shape) {
      // Very light - float and drift heavily
      case ParticleShape.feather:
        return const ParticlePhysics(
            gravity: kGravityVeryLight,
            drag: kDragMediumHigh,
            sway: kSwayVeryHigh,
            rotationMultiplier: kRotationMultiplierVeryLow);
      case ParticleShape.rosePetal:
        return const ParticlePhysics(
            gravity: 20.0,
            drag: kDragMedium,
            sway: kSwayHigh,
            rotationMultiplier: kRotationMultiplierMedium);
      case ParticleShape.paperCrane:
        return const ParticlePhysics(
            gravity: 25.0,
            drag: kDragMediumLow,
            sway: kSwayMediumHigh,
            rotationMultiplier: kRotationMultiplierLow);

      // Light - gentle fall with drift
      case ParticleShape.snowflake:
      case ParticleShape.ribbon:
      case ParticleShape.pastelRibbon:
        return const ParticlePhysics(
            gravity: kGravityLight,
            drag: kDragLow,
            sway: kSwayMedium,
            rotationMultiplier: kRotationMultiplierMediumLow);
      case ParticleShape.confetti:
        return const ParticlePhysics(
            gravity: 40.0,
            drag: kDragVeryLow,
            sway: kSwayMediumLow,
            rotationMultiplier: kRotationMultiplierHigh);
      case ParticleShape.glitter:
      case ParticleShape.champagneBubble:
        return const ParticlePhysics(
            gravity: 35.0,
            drag: kDragLow,
            sway: kSwayLow,
            rotationMultiplier: kRotationMultiplierVeryHigh);

      // Medium-light - moderate fall with some drift
      case ParticleShape.leaf:
      case ParticleShape.mangoLeaf:
      case ParticleShape.mapleLeaf:
        return const ParticlePhysics(
            gravity: kGravityMediumLight,
            drag: kDragMedium,
            sway: kSwayMediumHigh,
            rotationMultiplier: kRotationMultiplierMediumHigh);
      case ParticleShape.vine:
        return const ParticlePhysics(
            gravity: 45.0,
            drag: kDragVeryLow,
            sway: kSwayMedium,
            rotationMultiplier: 0.4);
      case ParticleShape.bunting:
        return const ParticlePhysics(
            gravity: 55.0,
            drag: 0.92,
            sway: kSwayLow,
            rotationMultiplier: kRotationMultiplierMedium);

      // Medium - steady fall
      case ParticleShape.heart:
      case ParticleShape.paintedEgg:
      case ParticleShape.paperLantern:
      case ParticleShape.marigold:
        return const ParticlePhysics(
            gravity: kGravityMedium,
            drag: kDragMediumHigh,
            sway: kSwayVeryLow,
            rotationMultiplier: kRotationMultiplierVeryLow);
      case ParticleShape.redEnvelope:
        return const ParticlePhysics(
            gravity: 90.0,
            drag: kDragMediumLow,
            sway: 15.0,
            rotationMultiplier: kRotationMultiplierLow);
      case ParticleShape.chineseKnot:
        return const ParticlePhysics(
            gravity: 85.0,
            drag: kDragMedium,
            sway: 12.0,
            rotationMultiplier: kRotationMultiplierDefault);

      // Medium-heavy - deliberate fall
      case ParticleShape.ghost:
        return const ParticlePhysics(
            gravity: 40.0,
            drag: kDragMediumLow,
            sway: kSwayLow,
            rotationMultiplier: kRotationMultiplierMinimal);
      case ParticleShape.cobweb:
        return const ParticlePhysics(
            gravity: 25.0,
            drag: kDragLow,
            sway: kSwayMediumLow,
            rotationMultiplier: 0.2);
      case ParticleShape.raindrop:
        return const ParticlePhysics(
            gravity: 200.0,
            drag: kDragHigh,
            sway: kSwayMinimal,
            rotationMultiplier: kRotationMultiplierNone);
      case ParticleShape.icicle:
        return const ParticlePhysics(
            gravity: 180.0,
            drag: kDragHigh,
            sway: 2.0,
            rotationMultiplier: kRotationMultiplierMinimal);

      // Heavy - fast fall
      case ParticleShape.spider:
        return const ParticlePhysics(
            gravity: kGravityMediumHeavy,
            drag: kDragMedium,
            sway: 8.0,
            rotationMultiplier: kRotationMultiplierMedium);
      case ParticleShape.bat:
        return const ParticlePhysics(
            gravity: 100.0,
            drag: kDragMediumLow,
            sway: 15.0,
            rotationMultiplier: 0.4);
      case ParticleShape.seed:
      case ParticleShape.acorn:
        return const ParticlePhysics(
            gravity: kGravityHeavy,
            drag: kDragMediumHigh,
            sway: kSwayMinimal,
            rotationMultiplier: kRotationMultiplierDefault);
      case ParticleShape.cupidArrow:
        return const ParticlePhysics(
            gravity: 160.0,
            drag: kDragHigh,
            sway: 3.0,
            rotationMultiplier: 0.2);

      // Very heavy - rapid fall
      case ParticleShape.ornament:
      case ParticleShape.goldCoin:
        return const ParticlePhysics(
            gravity: kGravityVeryHeavy,
            drag: kDragHigh,
            sway: 2.0,
            rotationMultiplier: kRotationMultiplierVeryLow);
      case ParticleShape.horseshoe:
        return const ParticlePhysics(
            gravity: 300.0,
            drag: kDragHigh,
            sway: 1.0,
            rotationMultiplier: kRotationMultiplierMinimal);

      // Glowing/floating - special behavior
      case ParticleShape.fairyLight:
        return const ParticlePhysics(
            gravity: 20.0,
            drag: kDragVeryLow,
            sway: kSwayHigh,
            rotationMultiplier: 0.1);

      // Default/Circle - standard firework physics
      case ParticleShape.circle:
        return const ParticlePhysics(
            gravity: kGravityDefault,
            drag: kDragMediumHigh,
            sway: kSwayNone,
            rotationMultiplier: kRotationMultiplierDefault);
    }
  }

  /// Check if particle should be removed
  bool get isDead => lifetime <= 0.0;

  /// Get current opacity based on lifetime
  double get opacity => lifetime.clamp(0.0, 1.0);
}

/// Physics properties for particle materials
class ParticlePhysics {
  final double gravity; // Downward acceleration (pixels/s²)
  final double drag; // Air resistance (0.9-0.99, closer to 1 = less resistance)
  final double sway; // Horizontal drift force for light materials
  final double rotationMultiplier; // Rotation speed multiplier

  const ParticlePhysics({
    required this.gravity,
    required this.drag,
    required this.sway,
    required this.rotationMultiplier,
  });
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

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw particle based on shape
      switch (particle.shape) {
        case ParticleShape.circle:
        case ParticleShape.champagneBubble:
        case ParticleShape.glitter:
          _drawCircle(canvas, particle.size, paint);
          break;
        case ParticleShape.heart:
          _drawHeart(canvas, particle.size, paint);
          break;
        case ParticleShape.leaf:
        case ParticleShape.mangoLeaf:
          _drawLeaf(canvas, particle.size, paint);
          break;
        case ParticleShape.ornament:
          _drawOrnament(canvas, particle.size, paint);
          break;
        case ParticleShape.icicle:
          _drawIcicle(canvas, particle.size, paint);
          break;
        case ParticleShape.snowflake:
          _drawSnowflake(canvas, particle.size, paint);
          break;
        case ParticleShape.ribbon:
        case ParticleShape.pastelRibbon:
          _drawRibbon(canvas, particle.size, paint);
          break;
        case ParticleShape.confetti:
          _drawConfetti(canvas, particle.size, paint);
          break;
        case ParticleShape.rosePetal:
          _drawRosePetal(canvas, particle.size, paint);
          break;
        case ParticleShape.cupidArrow:
          _drawCupidArrow(canvas, particle.size, paint);
          break;
        case ParticleShape.goldCoin:
          _drawGoldCoin(canvas, particle.size, paint);
          break;
        case ParticleShape.horseshoe:
          _drawHorseshoe(canvas, particle.size, paint);
          break;
        case ParticleShape.paintedEgg:
          _drawPaintedEgg(canvas, particle.size, paint);
          break;
        case ParticleShape.vine:
          _drawVine(canvas, particle.size, paint);
          break;
        case ParticleShape.raindrop:
          _drawRaindrop(canvas, particle.size, paint);
          break;
        case ParticleShape.seed:
        case ParticleShape.acorn:
          _drawSeed(canvas, particle.size, paint);
          break;
        case ParticleShape.mapleLeaf:
          _drawMapleLeaf(canvas, particle.size, paint);
          break;
        case ParticleShape.spider:
          _drawSpider(canvas, particle.size, paint);
          break;
        case ParticleShape.cobweb:
          _drawCobweb(canvas, particle.size, paint);
          break;
        case ParticleShape.bat:
          _drawBat(canvas, particle.size, paint);
          break;
        case ParticleShape.ghost:
          _drawGhost(canvas, particle.size, paint);
          break;
        case ParticleShape.redEnvelope:
          _drawRedEnvelope(canvas, particle.size, paint);
          break;
        case ParticleShape.paperLantern:
          _drawPaperLantern(canvas, particle.size, paint);
          break;
        case ParticleShape.chineseKnot:
          _drawChineseKnot(canvas, particle.size, paint);
          break;
        case ParticleShape.marigold:
          _drawMarigold(canvas, particle.size, paint);
          break;
        case ParticleShape.fairyLight:
          _drawFairyLight(canvas, particle.size, paint);
          break;
        case ParticleShape.bunting:
          _drawBunting(canvas, particle.size, paint);
          break;
        case ParticleShape.paperCrane:
          _drawPaperCrane(canvas, particle.size, paint);
          break;
        case ParticleShape.feather:
          _drawFeather(canvas, particle.size, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawCircle(Canvas canvas, double size, Paint paint) {
    // Main particle
    canvas.drawCircle(Offset.zero, size, paint);

    // Glow effect for more visual impact
    if (paint.color.a > 0.5) {
      final glowPaint = Paint()
        ..color = paint.color
            .withValues(alpha: paint.color.a * kGlowOpacityMultiplier)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, kGlowBlurRadius);
      canvas.drawCircle(Offset.zero, size * kGlowSizeMultiplier, glowPaint);
    }
  }

  void _drawHeart(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / kParticleShapeScaleDivisor;

    // Heart shape using bezier curves
    path.moveTo(0, 3 * scale);
    path.cubicTo(-5 * scale, -3 * scale, -10 * scale, 1 * scale, 0, 10 * scale);
    path.cubicTo(10 * scale, 1 * scale, 5 * scale, -3 * scale, 0, 3 * scale);

    canvas.drawPath(path, paint);
  }

  void _drawLeaf(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Leaf shape
    path.moveTo(0, -10 * scale);
    path.quadraticBezierTo(5 * scale, -5 * scale, 8 * scale, 0);
    path.quadraticBezierTo(5 * scale, 5 * scale, 0, 10 * scale);
    path.quadraticBezierTo(-5 * scale, 5 * scale, -8 * scale, 0);
    path.quadraticBezierTo(-5 * scale, -5 * scale, 0, -10 * scale);

    // Add center vein
    canvas.drawPath(path, paint);

    final veinPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.6)
      ..strokeWidth = scale * 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, -10 * scale), Offset(0, 10 * scale), veinPaint);
  }

  void _drawOrnament(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Main ball
    canvas.drawCircle(Offset(0, 2 * scale), 8 * scale, paint);

    // Cap/hook at top
    final capPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(-2 * scale, -2 * scale, 4 * scale, 4 * scale), capPaint);
  }

  void _drawIcicle(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Icicle shape - sharp and crystalline
    path.moveTo(0, -10 * scale);
    path.lineTo(2 * scale, -6 * scale);
    path.lineTo(1 * scale, 0);
    path.lineTo(3 * scale, 5 * scale);
    path.lineTo(0, 10 * scale);
    path.lineTo(-3 * scale, 5 * scale);
    path.lineTo(-1 * scale, 0);
    path.lineTo(-2 * scale, -6 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawSnowflake(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;
    final linePaint = Paint()
      ..color = paint.color
      ..strokeWidth = scale * 0.8
      ..style = PaintingStyle.stroke;

    // 6-pointed snowflake
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60.0) * (3.14159 / 180.0);
      final dx = cos(angle) * 8 * scale;
      final dy = sin(angle) * 8 * scale;
      canvas.drawLine(Offset.zero, Offset(dx, dy), linePaint);

      // Small branches
      final branchLen = 3 * scale;
      final branchAngle1 = angle + 0.5;
      final branchAngle2 = angle - 0.5;
      canvas.drawLine(
        Offset(dx * 0.6, dy * 0.6),
        Offset(dx * 0.6 + cos(branchAngle1) * branchLen,
            dy * 0.6 + sin(branchAngle1) * branchLen),
        linePaint,
      );
      canvas.drawLine(
        Offset(dx * 0.6, dy * 0.6),
        Offset(dx * 0.6 + cos(branchAngle2) * branchLen,
            dy * 0.6 + sin(branchAngle2) * branchLen),
        linePaint,
      );
    }
  }

  void _drawRibbon(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Wavy ribbon shape
    path.moveTo(-2 * scale, -10 * scale);
    path.quadraticBezierTo(2 * scale, -5 * scale, -2 * scale, 0);
    path.quadraticBezierTo(2 * scale, 5 * scale, -2 * scale, 10 * scale);
    path.lineTo(2 * scale, 10 * scale);
    path.quadraticBezierTo(-2 * scale, 5 * scale, 2 * scale, 0);
    path.quadraticBezierTo(-2 * scale, -5 * scale, 2 * scale, -10 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawConfetti(Canvas canvas, double size, Paint paint) {
    final scale = size / kParticleShapeScaleDivisor;

    // Small rectangle (confetti piece)
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset.zero,
          width: kConfettiWidth * scale,
          height: kConfettiHeight * scale),
      paint,
    );
  }

  void _drawRosePetal(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Organic petal shape
    path.moveTo(0, -8 * scale);
    path.quadraticBezierTo(6 * scale, -4 * scale, 4 * scale, 4 * scale);
    path.quadraticBezierTo(0, 8 * scale, 0, 6 * scale);
    path.quadraticBezierTo(0, 8 * scale, -4 * scale, 4 * scale);
    path.quadraticBezierTo(-6 * scale, -4 * scale, 0, -8 * scale);

    canvas.drawPath(path, paint);
  }

  void _drawCupidArrow(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;
    final linePaint = Paint()
      ..color = paint.color
      ..strokeWidth = scale * 0.8
      ..style = PaintingStyle.stroke;

    // Arrow shaft
    canvas.drawLine(Offset(0, -8 * scale), Offset(0, 8 * scale), linePaint);

    // Arrowhead
    final path = Path();
    path.moveTo(0, -8 * scale);
    path.lineTo(-3 * scale, -4 * scale);
    path.lineTo(3 * scale, -4 * scale);
    path.close();
    canvas.drawPath(path, paint);

    // Feathers at back
    canvas.drawLine(
        Offset(-2 * scale, 8 * scale), Offset(0, 6 * scale), linePaint);
    canvas.drawLine(
        Offset(2 * scale, 8 * scale), Offset(0, 6 * scale), linePaint);
  }

  void _drawGoldCoin(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Outer glow effect (lightening)
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset.zero, 10 * scale, glowPaint);

    // Coin body with gradient shine
    final rect = Rect.fromCircle(center: Offset.zero, radius: 8 * scale);
    const gradient = RadialGradient(
      colors: [
        Color(0xFFFFD700), // Bright gold center
        Color(0xFFFFA500), // Orange-gold mid
        Color(0xFFDAA520), // Dark gold edge
      ],
      stops: [0.3, 0.7, 1.0],
    );
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 8 * scale, gradientPaint);

    // Darker gold border around coin
    final borderPaint = Paint()
      ..color = const Color(0xFFB8860B)
          .withValues(alpha: paint.color.a) // Dark goldenrod
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 1.0;
    canvas.drawCircle(Offset.zero, 8 * scale, borderPaint);

    // Highlight shine (top-left)
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(-2 * scale, -2 * scale), 2 * scale, shinePaint);

    // Inner circle (embossing effect)
    final innerPaint = Paint()
      ..color = const Color(0xFFDAA520).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.5;
    canvas.drawCircle(Offset.zero, 5 * scale, innerPaint);
  }

  void _drawHorseshoe(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // U-shape horseshoe
    path.moveTo(-6 * scale, -4 * scale);
    path.quadraticBezierTo(-8 * scale, 4 * scale, 0, 8 * scale);
    path.quadraticBezierTo(8 * scale, 4 * scale, 6 * scale, -4 * scale);

    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 2.5;
    canvas.drawPath(path, strokePaint);

    // Nail holes
    canvas.drawCircle(Offset(-4 * scale, 0), scale, paint);
    canvas.drawCircle(Offset(4 * scale, 0), scale, paint);
  }

  void _drawPaintedEgg(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Egg shape (oval)
    final rect = Rect.fromCenter(
        center: Offset.zero, width: 12 * scale, height: 16 * scale);
    canvas.drawOval(rect, paint);

    // Decorative stripes
    final stripePaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.8;
    canvas.drawLine(Offset(-6 * scale, 0), Offset(6 * scale, 0), stripePaint);
    canvas.drawLine(Offset(-5 * scale, 4 * scale), Offset(5 * scale, 4 * scale),
        stripePaint);
    canvas.drawLine(Offset(-5 * scale, -4 * scale),
        Offset(5 * scale, -4 * scale), stripePaint);
  }

  void _drawVine(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Curvy vine
    path.moveTo(0, -10 * scale);
    path.quadraticBezierTo(4 * scale, -5 * scale, 0, 0);
    path.quadraticBezierTo(-4 * scale, 5 * scale, 0, 10 * scale);

    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 1.2;
    canvas.drawPath(path, strokePaint);

    // Small leaves
    canvas.drawCircle(Offset(3 * scale, -3 * scale), 2 * scale, paint);
    canvas.drawCircle(Offset(-3 * scale, 3 * scale), 2 * scale, paint);
  }

  void _drawRaindrop(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Teardrop shape
    path.moveTo(0, -8 * scale);
    path.quadraticBezierTo(6 * scale, 0, 0, 8 * scale);
    path.quadraticBezierTo(-6 * scale, 0, 0, -8 * scale);

    canvas.drawPath(path, paint);
  }

  void _drawSeed(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Small oval seed
    final rect = Rect.fromCenter(
        center: Offset.zero, width: 5 * scale, height: 8 * scale);
    canvas.drawOval(rect, paint);
  }

  void _drawMapleLeaf(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Maple leaf with 5 points
    path.moveTo(0, -10 * scale);
    path.lineTo(3 * scale, -4 * scale);
    path.lineTo(8 * scale, -6 * scale);
    path.lineTo(5 * scale, 0);
    path.lineTo(8 * scale, 6 * scale);
    path.lineTo(2 * scale, 4 * scale);
    path.lineTo(0, 10 * scale);
    path.lineTo(-2 * scale, 4 * scale);
    path.lineTo(-8 * scale, 6 * scale);
    path.lineTo(-5 * scale, 0);
    path.lineTo(-8 * scale, -6 * scale);
    path.lineTo(-3 * scale, -4 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawSpider(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Spider body
    canvas.drawCircle(Offset.zero, 4 * scale, paint);

    // 8 legs
    final legPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.6;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0) * (3.14159 / 180.0);
      final legEnd = Offset(cos(angle) * 8 * scale, sin(angle) * 8 * scale);
      canvas.drawLine(Offset.zero, legEnd, legPaint);
    }
  }

  void _drawCobweb(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;
    final webPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.4;

    // Radial web lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0) * (3.14159 / 180.0);
      canvas.drawLine(
        Offset.zero,
        Offset(cos(angle) * 10 * scale, sin(angle) * 10 * scale),
        webPaint,
      );
    }

    // Circular web rings
    canvas.drawCircle(Offset.zero, 3 * scale, webPaint);
    canvas.drawCircle(Offset.zero, 6 * scale, webPaint);
  }

  void _drawBat(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Bat with wings
    path.moveTo(0, 0); // Body center
    path.lineTo(-8 * scale, -4 * scale); // Left wing tip
    path.quadraticBezierTo(
        -6 * scale, 2 * scale, -2 * scale, 2 * scale); // Left wing curve
    path.lineTo(-1 * scale, 4 * scale); // Neck
    path.lineTo(1 * scale, 4 * scale); // Head
    path.lineTo(2 * scale, 2 * scale); // Right wing start
    path.quadraticBezierTo(
        6 * scale, 2 * scale, 8 * scale, -4 * scale); // Right wing tip
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawGhost(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Ghost body (wavy bottom)
    path.moveTo(0, -8 * scale);
    path.quadraticBezierTo(-6 * scale, -8 * scale, -6 * scale, -2 * scale);
    path.lineTo(-6 * scale, 6 * scale);
    path.quadraticBezierTo(-4 * scale, 8 * scale, -2 * scale, 6 * scale);
    path.quadraticBezierTo(0, 4 * scale, 2 * scale, 6 * scale);
    path.quadraticBezierTo(4 * scale, 8 * scale, 6 * scale, 6 * scale);
    path.lineTo(6 * scale, -2 * scale);
    path.quadraticBezierTo(6 * scale, -8 * scale, 0, -8 * scale);

    canvas.drawPath(path, paint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black.withValues(alpha: paint.color.a)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(-2 * scale, -2 * scale), scale, eyePaint);
    canvas.drawCircle(Offset(2 * scale, -2 * scale), scale, eyePaint);
  }

  void _drawRedEnvelope(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Rectangle envelope body
    final rect = Rect.fromCenter(
        center: Offset.zero, width: 10 * scale, height: 14 * scale);
    canvas.drawRect(rect, paint);

    // Gold border
    final borderPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: paint.color.a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.8;
    canvas.drawRect(rect, borderPaint);

    // Gold motif - decorative pattern in center
    final motifPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: paint.color.a * 0.9)
      ..style = PaintingStyle.fill;

    // Central gold circle (simplified Chinese coin)
    canvas.drawCircle(Offset.zero, 2.5 * scale, motifPaint);

    // Inner square hole (traditional coin style)
    final holePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset.zero, width: 1.2 * scale, height: 1.2 * scale),
      holePaint,
    );

    // Decorative lines above and below
    final linePaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: paint.color.a * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.6;
    canvas.drawLine(Offset(-3 * scale, -5 * scale),
        Offset(3 * scale, -5 * scale), linePaint);
    canvas.drawLine(
        Offset(-3 * scale, 5 * scale), Offset(3 * scale, 5 * scale), linePaint);

    // Corner decorations (small gold dots)
    final cornerSize = scale * 0.8;
    canvas.drawCircle(Offset(-4 * scale, -6 * scale), cornerSize, motifPaint);
    canvas.drawCircle(Offset(4 * scale, -6 * scale), cornerSize, motifPaint);
    canvas.drawCircle(Offset(-4 * scale, 6 * scale), cornerSize, motifPaint);
    canvas.drawCircle(Offset(4 * scale, 6 * scale), cornerSize, motifPaint);
  }

  void _drawPaperLantern(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Lantern body (rounded rectangle)
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset.zero, width: 10 * scale, height: 12 * scale),
      Radius.circular(2 * scale),
    );
    canvas.drawRRect(rect, paint);

    // Horizontal lines
    final linePaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.5;
    canvas.drawLine(Offset(-5 * scale, -3 * scale),
        Offset(5 * scale, -3 * scale), linePaint);
    canvas.drawLine(
        Offset(-5 * scale, 3 * scale), Offset(5 * scale, 3 * scale), linePaint);

    // Top hook
    canvas.drawLine(Offset(0, -6 * scale), Offset(0, -8 * scale), linePaint);
  }

  void _drawChineseKnot(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Diamond knot shape
    final path = Path();
    path.moveTo(0, -6 * scale);
    path.lineTo(4 * scale, 0);
    path.lineTo(0, 6 * scale);
    path.lineTo(-4 * scale, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Inner diamond
    final innerPath = Path();
    innerPath.moveTo(0, -3 * scale);
    innerPath.lineTo(2 * scale, 0);
    innerPath.lineTo(0, 3 * scale);
    innerPath.lineTo(-2 * scale, 0);
    innerPath.close();

    final innerPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.6;
    canvas.drawPath(innerPath, innerPaint);

    // Tassel
    canvas.drawLine(Offset(0, 6 * scale), Offset(0, 10 * scale), innerPaint);
  }

  void _drawMarigold(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Flower center
    canvas.drawCircle(Offset.zero, 2 * scale, paint);

    // Petals (8 petals around center)
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0) * (3.14159 / 180.0);
      final petalPath = Path();
      final petalDx = cos(angle) * 5 * scale;
      final petalDy = sin(angle) * 5 * scale;

      petalPath.moveTo(cos(angle) * 2 * scale, sin(angle) * 2 * scale);
      petalPath.quadraticBezierTo(
        petalDx * 1.5,
        petalDy * 1.5,
        petalDx,
        petalDy,
      );

      final petalPaint = Paint()
        ..color = paint.color.withValues(alpha: paint.color.a * 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(petalDx, petalDy), 2 * scale, petalPaint);
    }
  }

  void _drawFairyLight(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Glowing bulb
    canvas.drawCircle(Offset.zero, 4 * scale, paint);

    // Intense glow effect
    final glowPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 8 * scale, glowPaint);
  }

  void _drawBunting(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Triangular flag
    path.moveTo(0, -6 * scale);
    path.lineTo(-6 * scale, 6 * scale);
    path.lineTo(6 * scale, 6 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawPaperCrane(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final scale = size / 10.0;

    // Simplified origami crane shape
    // Body
    path.moveTo(0, -2 * scale);
    path.lineTo(-6 * scale, -6 * scale); // Left wing
    path.lineTo(-2 * scale, -2 * scale);
    path.lineTo(0, 6 * scale); // Tail
    path.lineTo(2 * scale, -2 * scale);
    path.lineTo(6 * scale, -6 * scale); // Right wing
    path.close();

    canvas.drawPath(path, paint);

    // Head/neck
    final neckPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.8;
    canvas.drawLine(
        Offset(0, -2 * scale), Offset(4 * scale, -8 * scale), neckPaint);
  }

  void _drawFeather(Canvas canvas, double size, Paint paint) {
    final scale = size / 10.0;

    // Feather shaft
    final shaftPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.6;
    canvas.drawLine(Offset(0, -10 * scale), Offset(0, 10 * scale), shaftPaint);

    // Feather barbs (soft curves on both sides)
    final barbPath = Path();
    barbPath.moveTo(0, -8 * scale);
    barbPath.quadraticBezierTo(4 * scale, -4 * scale, 3 * scale, 0);
    barbPath.quadraticBezierTo(2 * scale, 4 * scale, 1 * scale, 8 * scale);
    barbPath.lineTo(0, 8 * scale);
    barbPath.lineTo(-1 * scale, 8 * scale);
    barbPath.quadraticBezierTo(-2 * scale, 4 * scale, -3 * scale, 0);
    barbPath.quadraticBezierTo(-4 * scale, -4 * scale, 0, -8 * scale);

    final barbPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(barbPath, barbPaint);
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
    int count = kSmallBurstDefaultCount,
    List<Color>? colors,
  }) {
    final particles = <Particle>[];
    // Randomize particle count: 60% to 140% of specified count
    final actualCount = (count *
            (kSmallBurstCountMin +
                _random.nextDouble() *
                    (kSmallBurstCountMax - kSmallBurstCountMin)))
        .round();
    final defaultColors = colors ?? SeasonalTheme.config.fireworkColors;

    for (int i = 0; i < actualCount; i++) {
      final angle = (i / actualCount) * 2 * pi +
          _random.nextDouble() * kSmallBurstAngleVariation;
      final speed = kSmallBurstMinSpeed +
          _random.nextDouble() * (kSmallBurstMaxSpeed - kSmallBurstMinSpeed);

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed + kSmallBurstUpwardBias, // Initial upward bias
        ),
        color: defaultColors[_random.nextInt(defaultColors.length)],
        size: kSmallBurstMinSize +
            _random.nextDouble() *
                (kSmallBurstMaxSize -
                    kSmallBurstMinSize), // Larger particles: 3-9 pixels
        maxLifetime: kSmallBurstMinLifetime +
            _random.nextDouble() *
                (kSmallBurstMaxLifetime - kSmallBurstMinLifetime),
        rotationSpeed: (_random.nextDouble() - 0.5) * kSmallBurstRotationSpeed,
      ));
    }

    return particles;
  }

  /// Create a large explosion of particles (for gaining life)
  static List<Particle> createLargeExplosion({
    required Offset position,
    int count = kLargeExplosionDefaultCount,
    List<Color>? colors,
  }) {
    final particles = <Particle>[];
    final defaultColors = colors ?? SeasonalTheme.config.fireworkColors;

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi +
          _random.nextDouble() * kLargeExplosionAngleVariation;
      final speed = kLargeExplosionMinSpeed +
          _random.nextDouble() *
              (kLargeExplosionMaxSpeed - kLargeExplosionMinSpeed);

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed + kLargeExplosionUpwardBias, // Strong upward bias
        ),
        color: defaultColors[_random.nextInt(defaultColors.length)],
        size: kLargeExplosionMinSize +
            _random.nextDouble() *
                (kLargeExplosionMaxSize - kLargeExplosionMinSize),
        maxLifetime: kLargeExplosionMinLifetime +
            _random.nextDouble() *
                (kLargeExplosionMaxLifetime - kLargeExplosionMinLifetime),
        rotationSpeed:
            (_random.nextDouble() - 0.5) * kLargeExplosionRotationSpeed,
      ));
    }

    return particles;
  }

  /// Create confetti-style particles with slower fall
  static List<Particle> createConfetti({
    required Offset position,
    int count = kConfettiDefaultCount,
    List<Color>? colors,
  }) {
    final particles = <Particle>[];
    final defaultColors = colors ?? SeasonalTheme.config.fireworkColors;

    for (int i = 0; i < count; i++) {
      final angle =
          (i / count) * 2 * pi + _random.nextDouble() * kConfettiAngleVariation;
      final speed = kConfettiMinSpeed +
          _random.nextDouble() * (kConfettiMaxSpeed - kConfettiMinSpeed);

      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed + kConfettiUpwardBias, // Very strong upward bias
        ),
        color: defaultColors[_random.nextInt(defaultColors.length)],
        size: kConfettiMinSize +
            _random.nextDouble() * (kConfettiMaxSize - kConfettiMinSize),
        maxLifetime: kConfettiMinLifetime +
            _random.nextDouble() *
                (kConfettiMaxLifetime - kConfettiMinLifetime),
        rotationSpeed: (_random.nextDouble() - 0.5) * kConfettiRotationSpeed,
      ));
    }

    return particles;
  }

  /// Create snow particles for seasonal themes
  static List<Particle> createSnow({
    required Size screenSize,
    int count = kSnowInitialCount,
  }) {
    final particles = <Particle>[];
    final snowColors = SeasonalTheme.config.getSnowColors();
    final particleShape = SeasonalTheme.config.particleShape;

    for (int i = 0; i < count; i++) {
      // Random position across screen width and above screen
      final startX = _random.nextDouble() * screenSize.width;
      final startY = -_random.nextDouble() * screenSize.height;

      // Slow downward and slight horizontal drift
      final horizontalDrift =
          (_random.nextDouble() - 0.5) * kSnowHorizontalDriftRange;

      particles.add(Particle(
        position: Offset(startX, startY),
        velocity: Offset(
            horizontalDrift,
            kSnowMinVerticalSpeed +
                _random.nextDouble() *
                    (kSnowMaxVerticalSpeed - kSnowMinVerticalSpeed)),
        color: snowColors[_random.nextInt(snowColors.length)],
        size: kSnowMinSize +
            _random.nextDouble() *
                (kSnowMaxSize - kSnowMinSize), // Larger particles: 4-10 pixels
        maxLifetime: kSnowMinLifetime +
            _random.nextDouble() *
                (kSnowMaxLifetime - kSnowMinLifetime), // Long lifetime
        rotationSpeed: (_random.nextDouble() - 0.5) * kSnowRotationSpeed,
        isSnow: true,
        shape: particleShape,
      ));
    }

    return particles;
  }

  /// Create gold coin particles that drop down with glowing effect
  static List<Particle> createGoldCoinRain({
    required Size screenSize,
    int count = kGoldCoinDefaultCount,
    Offset? position,
  }) {
    final particles = <Particle>[];
    final goldColors = [
      const Color(0xFFFFD700), // Bright gold
      const Color(0xFFFFA500), // Orange-gold
      const Color(0xFFFFE55C), // Light gold
    ];

    for (int i = 0; i < count; i++) {
      // If position provided, spawn around it; otherwise random across screen
      final startX = position != null
          ? position.dx + (_random.nextDouble() - 0.5) * kGoldCoinSpawnSpread
          : _random.nextDouble() * screenSize.width;
      final startY = position != null
          ? position.dy -
              kGoldCoinSpawnHeight -
              _random.nextDouble() * kGoldCoinSpawnSpread
          : -_random.nextDouble() * kGoldCoinSpawnSpread;

      // Downward velocity with slight spread
      final horizontalVelocity =
          (_random.nextDouble() - 0.5) * kGoldCoinHorizontalRange;
      final verticalVelocity = kGoldCoinMinVerticalSpeed +
          _random.nextDouble() *
              (kGoldCoinMaxVerticalSpeed - kGoldCoinMinVerticalSpeed);

      particles.add(Particle(
        position: Offset(startX, startY),
        velocity: Offset(horizontalVelocity, verticalVelocity),
        color: goldColors[_random.nextInt(goldColors.length)],
        size: kGoldCoinMinSize +
            _random.nextDouble() *
                (kGoldCoinMaxSize -
                    kGoldCoinMinSize), // Larger coins: 6-14 pixels
        maxLifetime: kGoldCoinMinLifetime +
            _random.nextDouble() *
                (kGoldCoinMaxLifetime - kGoldCoinMinLifetime),
        rotationSpeed: (_random.nextDouble() - 0.5) *
            kGoldCoinRotationSpeed, // Spinning coins
        isSnow: false,
        shape: ParticleShape.goldCoin,
      ));
    }

    return particles;
  }
}
