import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// Spotlight overlay that highlights a target widget during the tour
/// and allows users to tap the actual element to proceed
class TourSpotlightOverlay extends StatelessWidget {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final bool
      allowTargetTap; // true = user must tap target, false = show Next button
  final VoidCallback? onTargetTap; // Called when user taps the target element
  final TourState tourState;
  final String skipText;
  final String previousText;
  final String nextText;
  final String finishText;

  const TourSpotlightOverlay({
    super.key,
    required this.targetKey,
    required this.title,
    required this.description,
    required this.allowTargetTap,
    required this.tourState,
    required this.skipText,
    required this.previousText,
    required this.nextText,
    required this.finishText,
    this.onTargetTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get target widget's position and size
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final targetRect = Rect.fromLTWH(
      position.dx,
      position.dy,
      size.width,
      size.height,
    );

    return Stack(
      children: [
        // Overlay with spotlight cutout
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              // Block taps outside spotlight
            },
            child: CustomPaint(
              painter: SpotlightPainter(
                spotlightRect: targetRect,
                padding: 8.0,
              ),
            ),
          ),
        ),

        // Tooltip positioned near the target
        Positioned(
          top: targetRect.bottom + 20,
          left: 20,
          right: 20,
          child: _buildTooltip(context),
        ),

        // Invisible tap detector over the target area (if tappable)
        if (allowTargetTap && onTargetTap != null)
          Positioned(
            left: targetRect.left,
            top: targetRect.top,
            width: targetRect.width,
            height: targetRect.height,
            child: GestureDetector(
              onTap: onTargetTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadiusM),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTooltip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kPaddingL),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(kBorderRadiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: kSpaceSM),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: kSpaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  context.read<TourBloc>().add(TourSkipped());
                },
                child: Text(
                  skipText,
                  style: AppTextStyles.bodyMediumLight(context),
                ),
              ),
              if (!allowTargetTap)
                Row(
                  children: [
                    if (!tourState.isFirstStep)
                      TextButton(
                        onPressed: () {
                          context.read<TourBloc>().add(TourStepBack());
                        },
                        child: Text(
                          previousText,
                          style: AppTextStyles.bodyMediumLight(context),
                        ),
                      ),
                    const SizedBox(width: kSpaceSM),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TourBloc>().add(TourStepCompleted());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        tourState.isLastStep ? finishText : nextText,
                      ),
                    ),
                  ],
                ),
              if (allowTargetTap)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: kIconSizeS,
                      ),
                      const SizedBox(width: kSpaceS),
                      Text(
                        'Tap to continue',
                        style: AppTextStyles.labelSmallLight(context),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpaceSM),
          Center(
            child: Text(
              '${tourState.currentStep + 1} / ${tourState.totalSteps}',
              style: AppTextStyles.bodySmall(context).copyWith(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws a dark overlay with a spotlight cutout
class SpotlightPainter extends CustomPainter {
  final Rect spotlightRect;
  final double padding;

  SpotlightPainter({
    required this.spotlightRect,
    this.padding = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw dark overlay
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    // Create path for the entire screen
    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create path for the spotlight (with padding)
    final spotlightPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          spotlightRect.inflate(padding),
          const Radius.circular(kBorderRadiusM),
        ),
      );

    // Subtract spotlight from overlay
    final path = Path.combine(
      PathOperation.difference,
      outerPath,
      spotlightPath,
    );

    canvas.drawPath(path, paint);

    // Draw spotlight border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        spotlightRect.inflate(padding),
        const Radius.circular(kBorderRadiusM),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) {
    return oldDelegate.spotlightRect != spotlightRect ||
        oldDelegate.padding != padding;
  }
}
