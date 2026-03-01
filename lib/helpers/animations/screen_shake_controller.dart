import 'dart:math';
import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Controller for screen shake effect using damped harmonic oscillator
class ScreenShakeController {
  AnimationController? _controller;
  double _trauma = 0.0;
  final Random _random = Random();

  /// Callback for red flash overlay
  VoidCallback? onRedFlashStart;
  VoidCallback? onRedFlashEnd;
  bool _isFlashing = false;

  /// Initialize with an AnimationController
  void initialize(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: kShakeDuration,
    )..addListener(_onTick);

    // Add status listener for flash end
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isFlashing) {
        _isFlashing = false;
        onRedFlashEnd?.call();
      }
    });
  }

  /// Dispose the controller
  void dispose() {
    _controller?.dispose();
  }

  /// Trigger a screen shake with given intensity (0.0 to 1.0)
  /// If withRedFlash is true, triggers the red flash overlay
  void shake(
      [double intensity = kShakeDefaultIntensity, bool withRedFlash = false]) {
    _trauma = (intensity).clamp(0.0, 1.0);
    if (withRedFlash) {
      _isFlashing = true;
      onRedFlashStart?.call();
    }
    _controller?.forward(from: 0.0);
  }

  void _onTick() {
    // Decay trauma over time (damped oscillation)
    final progress = _controller?.value ?? 0.0;
    _trauma *= (1.0 - progress);
  }

  /// Get current shake offset using damped harmonic oscillator
  Offset getShakeOffset() {
    if (_trauma <= kShakeMinTrauma) return Offset.zero;

    // Shake amount is trauma squared for more dramatic effect
    final shake = _trauma * _trauma;

    // Use perlin-like noise for more natural shake
    final maxOffset = kShakeMaxOffset * shake;

    return Offset(
      maxOffset * (_random.nextDouble() * 2 - 1),
      maxOffset * (_random.nextDouble() * 2 - 1) * 0.5, // Less vertical shake
    );
  }

  /// Get current rotation shake (in radians)
  double getShakeRotation() {
    if (_trauma <= kShakeMinTrauma) return 0.0;

    final shake = _trauma * _trauma;
    final maxRotation = kShakeMaxRotation * shake; // ~3 degrees max

    return maxRotation * (_random.nextDouble() * 2 - 1);
  }

  /// Check if currently shaking
  bool get isShaking => _trauma > kShakeMinTrauma;

  /// Get current wind force (horizontal acceleration) based on shake intensity
  /// Returns wind force in pixels/s² that pushes particles left/right
  Offset getWindForce() {
    if (_trauma <= kShakeMinTrauma) return Offset.zero;

    final shake = _trauma * _trauma;
    // Wind force correlates with shake intensity
    // Stronger shakes = stronger wind
    final windStrength = kShakeWindStrength * shake; // Base wind acceleration

    // Wind direction changes randomly to match shake direction
    return Offset(
      windStrength * (_random.nextDouble() * 2 - 1),
      0.0, // No vertical wind, only horizontal
    );
  }
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
  bool _showRedFlash = false;

  @override
  void initState() {
    super.initState();
    widget.controller.initialize(this);
    widget.controller._controller?.addListener(() {
      setState(() {}); // Rebuild on every shake update
    });

    // Set up red flash callbacks
    widget.controller.onRedFlashStart = () {
      setState(() => _showRedFlash = true);
    };
    widget.controller.onRedFlashEnd = () {
      setState(() => _showRedFlash = false);
    };
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

    // Calculate flash opacity based on trauma (fade out as shake subsides)
    final flashOpacity =
        _showRedFlash ? (widget.controller._trauma * 0.4).clamp(0.0, 0.4) : 0.0;

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: Stack(
          children: [
            widget.child,
            // Red flash overlay
            if (_showRedFlash)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    color: Colors.red.withOpacity(flashOpacity),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
