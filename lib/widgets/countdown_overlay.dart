import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/helper.dart';

/// Shared countdown overlay widget used before game starts.
///
/// Displays an animated circle with countdown number, color-coded gradient,
/// circular progress indicator, and "Ready!!" / "Go" text.
///
/// Used consistently across Solo mode and Combat mode.
class CountdownOverlay extends StatelessWidget {
  /// Number of seconds for the countdown.
  final int seconds;

  /// Called when the countdown finishes.
  final VoidCallback? onFinished;

  const CountdownOverlay({
    super.key,
    required this.seconds,
    this.onFinished,
  });

  /// Determines the gradient color based on remaining time.
  /// Automatically scales thresholds based on total countdown seconds.
  Gradient _getCountdownGradient(double time, int totalSeconds) {
    // Calculate proportional thresholds
    final greenThreshold = totalSeconds * 0.75;
    final blueThreshold = totalSeconds * 0.50;

    if (time >= greenThreshold) {
      return LinearGradient(
        colors: [Colors.green.shade300, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (time >= blueThreshold) {
      return LinearGradient(
        colors: [Colors.blue.shade300, Colors.blue.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (time >= 1) {
      return LinearGradient(
        colors: [Colors.orange.shade300, Colors.orange.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [Colors.red.shade300, Colors.red.shade700],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final readyText = "${lang(context).ready}!!";
    final goText = lang(context).go;

    return Countdown(
      seconds: seconds,
      interval: const Duration(milliseconds: 10),
      build: (BuildContext context, double time) {
        final secondProgress = time - time.floor();
        final gradient = _getCountdownGradient(time, seconds);

        return AnimatedScale(
          duration: const Duration(milliseconds: kAnimationDurationSlow),
          scale: time > 0.5 ? 1.0 : 5,
          curve: Curves.easeOutQuart,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: kAnimationDurationSlow),
            opacity: time > 0.5 ? 1.0 : 0.0,
            curve: Curves.easeOutQuart,
            child: Container(
              width: kCountdownCircleSize,
              height: kCountdownCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background button shape
                  Positioned.fill(
                    child: CustomElevatedButton(
                      buttonRadius: kBorderRadiusCircular,
                      shapeAt: RoundedWithShapeAt.all,
                      gradient: LinearGradient(colors: gradient.colors),
                    ),
                  ),
                  // Circular progress indicator
                  SizedBox(
                    width: kCountdownCircleInnerSize,
                    height: kCountdownCircleInnerSize,
                    child: CircularProgressIndicator(
                      value: secondProgress,
                      strokeWidth: kProgressStrokeWidth,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // Text content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (time >= 1)
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTextStyles.forCountdown(context),
                          child: Text(
                            time.truncate().toString(),
                            style: AppTextStyles.forCountdown(context),
                          ),
                        ),
                      if (time >= 1)
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTextStyles.forCountdownReady(context),
                          child: Text(
                            readyText,
                            style: AppTextStyles.forCountdownReady(context),
                          ),
                        )
                      else
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTextStyles.forCountdownGo(context),
                          child: Text(
                            goText,
                            style: AppTextStyles.forCountdownGo(context),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onFinished: onFinished ?? () {},
    );
  }
}
