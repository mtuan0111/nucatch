import 'dart:math';
import 'package:flutter/material.dart';

class LightningWidget extends StatelessWidget {
  final Color baseColor;
  final int seed;
  final BorderRadius? borderRadius;

  const LightningWidget({
    super.key,
    required this.baseColor,
    this.seed = 10033,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final rng = Random(seed);
    // Values between -1.0 and 1.0 for alignment to crop a random part
    final alignmentX = rng.nextDouble() * 2.0 - 1.0;
    final alignmentY = rng.nextDouble() * 2.0 - 1.0;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        'assets/images/lightening-texture-2.png',
        fit: BoxFit.none,
        alignment: Alignment(alignmentX, alignmentY),
        color: baseColor,
        colorBlendMode: BlendMode.hardLight,
        opacity: const AlwaysStoppedAnimation(0.6),
      ),
    );
  }
}
