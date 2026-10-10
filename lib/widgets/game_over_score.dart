import 'package:flutter/material.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// The game-over hero: "Game Over", then the run's score as the largest
/// thing on the screen. The answer that ended the run follows as secondary
/// detail ([GameOverAnswer]).
class GameOverScore extends StatelessWidget {
  final int point;

  const GameOverScore({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final scoreStyle = AppTextStyles.displaySmallBold(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          coreLang(context).gameOver,
          style: AppTextStyles.titleLarge(context).copyWith(color: onPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpaceL),
        Text(
          coreLang(context).score.toUpperCase(),
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: onPrimary.withValues(alpha: 0.75),
            letterSpacing: 2,
          ),
        ),
        Text(
          '$point',
          style: scoreStyle.copyWith(
            color: onPrimary,
            fontSize: (scoreStyle.fontSize ?? 36) * 1.6,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

/// "The answer was …" under [GameOverScore]: what the player missed, kept
/// smaller than the score.
class GameOverAnswer extends StatelessWidget {
  final String answer;

  const GameOverAnswer({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lang(context).theCorrectIs,
          style: AppTextStyles.bodyLargeMedium(context).copyWith(
            color: onPrimary.withValues(alpha: 0.85),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpace2XL),
          child: Text(
            answer,
            style: AppTextStyles.titleLarge(context).copyWith(
              color: onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
