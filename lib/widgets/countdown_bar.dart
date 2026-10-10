import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:nucatch/helpers/const.dart';

/// Shared tap-timer countdown bar widget.
///
/// Displays a horizontal progress bar that shrinks as time runs out,
/// changing color from primary → orange → red based on remaining time.
///
/// Used consistently across Solo mode and Combat mode.
class CountDownBar extends StatelessWidget {
  /// The total timer duration in seconds (used to calculate percentages).
  final double timerDuration;

  /// The remaining seconds on the tap timer.
  final int tapTimerRemaining;

  /// Whether the game is actively playing (timer should be counting down).
  final bool isPlaying;

  /// Whether the turn timer is held (the in-game menu, the app in the
  /// background, a fold change…). The bar then stands still at
  /// [tapTimerRemaining]: the [Countdown] below runs its own clock and
  /// would otherwise keep draining while the game's timer is stopped, then
  /// jump back when it resumes.
  final bool isPaused;

  const CountDownBar({
    super.key,
    required this.timerDuration,
    required this.tapTimerRemaining,
    required this.isPlaying,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalSeconds = timerDuration.toInt();
    final halfSeconds = (timerDuration / 2).toInt();
    final quarterSeconds = (timerDuration / 4).toInt();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: lang(context).tapTimerTooltip(
            totalSeconds,
            halfSeconds,
            quarterSeconds,
          ),
          child: SizedBox(
            height: kTimerBarHeight,
            child: isPlaying && isPaused
                ? _buildBar(context, tapTimerRemaining.toDouble())
                : isPlaying
                    ? Countdown(
                        // Force fresh widget state when timer resets.
                        // The timer_count_down package does NOT restart its
                        // internal Timer in didUpdateWidget — it only resets
                        // _currentMicroSeconds. So after timeout, the Timer
                        // is dead and the Countdown only rebuilds at BLoC
                        // rebuild frequency (~0.7s) instead of 10ms.
                        key: ValueKey('countdown_$tapTimerRemaining'),
                        seconds: tapTimerRemaining,
                        interval: const Duration(milliseconds: 10),
                        build: (BuildContext context, double time) =>
                            _buildBar(context, time),
                        onFinished: () {},
                      )
                    : Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned.fill(
                            child: CustomElevatedButton(
                              shapeAt: RoundedWithShapeAt.all,
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
        const SizedBox(height: kSpaceM),
      ],
    );
  }

  /// The track, plus a fill for [time] seconds left that turns from the
  /// primary colour to orange at half time and red at a quarter.
  Widget _buildBar(BuildContext context, double time) {
    final percent = (time / timerDuration * 100).toInt().clamp(0, 100);

    final Color backgroundColor = time > timerDuration / 2
        ? Theme.of(context).primaryColor
        : time > timerDuration / 4
            ? Colors.orange
            : Colors.red;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned.fill(
          child: CustomElevatedButton(
            shapeAt: RoundedWithShapeAt.all,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Row(
          children: [
            if (percent > 0)
              Expanded(
                flex: percent,
                child: CustomElevatedButton(
                  onPressed: () {},
                  shapeAt: RoundedWithShapeAt.all,
                  backgroundColor: backgroundColor,
                ),
              ),
            Expanded(
              flex: 100 - percent,
              child: Opacity(
                opacity: 0,
                child: Container(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
