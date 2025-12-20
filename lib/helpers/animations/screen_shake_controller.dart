import 'dart:math';
import 'package:flutter/material.dart';

/// Controller for screen shake effect using damped harmonic oscillator
class ScreenShakeController {
  AnimationController? _controller;
  double _trauma = 0.0;
  final Random _random = Random();

  /// Initialize with an AnimationController
  void initialize(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    )..addListener(_onTick);
  }

  /// Dispose the controller
  void dispose() {
    _controller?.dispose();
  }

  /// Trigger a screen shake with given intensity (0.0 to 1.0)
  void shake([double intensity = 0.8]) {
    _trauma = (intensity).clamp(0.0, 1.0);
    _controller?.forward(from: 0.0);
  }

  void _onTick() {
    // Decay trauma over time (damped oscillation)
    final progress = _controller?.value ?? 0.0;
    _trauma *= (1.0 - progress);
  }

  /// Get current shake offset using damped harmonic oscillator
  Offset getShakeOffset() {
    if (_trauma <= 0.01) return Offset.zero;

    // Shake amount is trauma squared for more dramatic effect
    final shake = _trauma * _trauma;

    // Use perlin-like noise for more natural shake
    final maxOffset = 20.0 * shake;

    return Offset(
      maxOffset * (_random.nextDouble() * 2 - 1),
      maxOffset * (_random.nextDouble() * 2 - 1) * 0.5, // Less vertical shake
    );
  }

  /// Get current rotation shake (in radians)
  double getShakeRotation() {
    if (_trauma <= 0.01) return 0.0;

    final shake = _trauma * _trauma;
    final maxRotation = 0.05 * shake; // ~3 degrees max

    return maxRotation * (_random.nextDouble() * 2 - 1);
  }

  /// Check if currently shaking
  bool get isShaking => _trauma > 0.01;
}

/// Widget that applies screen shake to its child
class ScreenShakeWidget extends StatefulWidget {
  final Widget child;
  final ScreenShakeController controller;

  const ScreenShakeWidget({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  State<ScreenShakeWidget> createState() => _ScreenShakeWidgetState();
}

class _ScreenShakeWidgetState extends State<ScreenShakeWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize(this);
    widget.controller._controller?.addListener(() {
      setState(() {}); // Rebuild on every shake update
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = widget.controller.getShakeOffset();
    final rotation = widget.controller.getShakeRotation();

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: widget.child,
      ),
    );
  }
}
