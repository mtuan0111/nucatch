import 'dart:math';
import 'package:flutter/material.dart';

class LightningPainter extends CustomPainter {
  final Color baseColor;
  final int seed;

  LightningPainter({
    required this.baseColor,
    this.seed = 10033,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Implement an algorithmic lightning texture
    final paint = Paint()
      ..color = baseColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rng = Random(seed); // Seeded for consistent lightning

    // Generate several lightning bolts across the button
    int numBolts = 3 + rng.nextInt(3);

    for (int b = 0; b < numBolts; b++) {
      final path = Path();

      // Start randomly along the top or left edge
      double startX = rng.nextDouble() * size.width;
      double startY = 0;

      if (rng.nextBool()) {
        startX = 0;
        startY = rng.nextDouble() * size.height;
      }

      path.moveTo(startX, startY);

      double currentX = startX;
      double currentY = startY;

      // Target the opposite general direction
      double targetX = (startX < size.width / 2) ? size.width : 0;
      double targetY = (startY < size.height / 2) ? size.height : 0;

      // Draw jagged lines until we reach roughly the other side
      while (currentX >= 0 &&
          currentX <= size.width &&
          currentY >= 0 &&
          currentY <= size.height) {
        // Step size
        double step = 5 + rng.nextDouble() * 15;

        // Direction vector towards target with lots of noise
        double dirX = targetX - currentX;
        double dirY = targetY - currentY;

        // Normalize roughly
        double length = sqrt(dirX * dirX + dirY * dirY);
        if (length == 0) length = 1;

        // Add random jaggedness (-1 to 1) perpendicular to main direction
        double jaggedX = (rng.nextDouble() - 0.5) * 2.0;
        double jaggedY = (rng.nextDouble() - 0.5) * 2.0;

        currentX += (dirX / length) * step + jaggedX * step;
        currentY += (dirY / length) * step + jaggedY * step;

        path.lineTo(currentX, currentY);

        // Occasional branching
        if (rng.nextDouble() < 0.15) {
          final branchPath = Path();
          branchPath.moveTo(currentX, currentY);
          double bX = currentX + (rng.nextDouble() - 0.5) * 30;
          double bY = currentY + (rng.nextDouble() - 0.5) * 30;
          branchPath.lineTo(bX, bY);

          final branchPaint = Paint()
            ..color = baseColor.withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5 + rng.nextDouble();
          canvas.drawPath(branchPath, branchPaint);
        }
      }

      paint.strokeWidth = 1.0 + rng.nextDouble() * 2.0;

      // Add a random blur effect to the lightning bolts as requested
      double blurRadius = rng.nextDouble() * 4.0;
      if (blurRadius > 0.5) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
      } else {
        paint.maskFilter = null;
      }

      canvas.drawPath(path, paint);

      // Core highlight for the thickest bolts
      if (paint.strokeWidth > 2.0) {
        // Create a lighter and slightly desaturated version of the base color
        final hsl = HSLColor.fromColor(baseColor);
        final lighterHsl = hsl
            .withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0))
            .withSaturation((hsl.saturation - 0.2).clamp(0.0, 1.0));
        final highlightColor = lighterHsl.toColor();

        // Randomize the glow blur as well
        double glowBlur = 2.0 + rng.nextDouble() * 4.0;
        final glowPaint = Paint()
          ..color = highlightColor.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = paint.strokeWidth * 0.4
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlur);
        canvas.drawPath(path, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant LightningPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor || seed != oldDelegate.seed;
}
