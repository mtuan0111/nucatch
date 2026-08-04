import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Dims the screen and punches a rounded hole around [targetRect].
///
/// Shared by the main-menu tour ([GlobalTourWrapper]) and the in-game rule
/// tutorial ([TutorialOverlay]) so both spotlights look identical.
class TourSpotlightPainter extends CustomPainter {
  final Rect targetRect;
  final double dimOpacity;

  TourSpotlightPainter({required this.targetRect, this.dimOpacity = 0.6});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final bgPaint = Paint()..color = Colors.black.withValues(alpha: dimOpacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final clearPaint = Paint()..blendMode = BlendMode.clear;

    if (targetRect != Rect.zero) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            targetRect.inflate(12), const Radius.circular(16)),
        clearPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool? hitTest(Offset position) => false;

  @override
  bool shouldRepaint(covariant TourSpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.dimOpacity != dimOpacity;
  }
}

/// Swallows every pointer event except those landing inside [holeRect], which
/// fall through to the highlighted widget underneath.
///
/// This is what enforces the tour's "you cannot tap outside the spotlight"
/// rule without resorting to a modal barrier.
class TourHoleBlocker extends SingleChildRenderObjectWidget {
  final Rect holeRect;

  /// When false even the hole is blocked — used while an animation plays.
  final bool holeIsInteractive;

  const TourHoleBlocker({
    super.key,
    required this.holeRect,
    this.holeIsInteractive = true,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      TourHoleBlockerRender(holeRect, holeIsInteractive);

  @override
  void updateRenderObject(
      BuildContext context, covariant TourHoleBlockerRender renderObject) {
    renderObject.holeRect = holeRect;
    renderObject.holeIsInteractive = holeIsInteractive;
  }
}

class TourHoleBlockerRender extends RenderProxyBox {
  Rect holeRect;
  bool holeIsInteractive;

  TourHoleBlockerRender(this.holeRect, this.holeIsInteractive);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (holeIsInteractive && holeRect.inflate(12).contains(position)) {
      return hitTestChildren(result, position: position);
    }
    result.add(BoxHitTestEntry(this, position));
    return true;
  }
}

/// A non-nullable `Rect` tween, so the spotlight can glide between targets.
class TourRectTween extends Tween<Rect> {
  TourRectTween({required Rect begin, required Rect end})
      : super(begin: begin, end: end);

  @override
  Rect lerp(double t) => Rect.lerp(begin, end, t) ?? end!;
}
