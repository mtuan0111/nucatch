import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

import 'package:nucatch/helpers/const.dart';

/// Shown on [CombatPlayScreen] while the opponent is paused mid-round
/// (folded or closed their phone, or left the app). Dims and blocks the
/// board — both timers are held — and, once they've been away too long,
/// offers [onClaimWin].
///
/// Should be placed inside a [Stack]. The card sits in one pane of a
/// hinged or half-folded window, never across it.
class OpponentPausedOverlay extends StatelessWidget {
  const OpponentPausedOverlay({
    super.key,
    required this.canClaimWin,
    required this.onClaimWin,
  });

  final bool canClaimWin;
  final VoidCallback onClaimWin;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.55),
        child: DisplayFeatureSubScreen(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(kSpaceL),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(kSpaceL),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kSpaceL),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.pause,
                            color: colors.onSurface,
                            size: 32,
                          ),
                          const SizedBox(height: kSpaceM),
                          Text(
                            lang(context).opponentPausedTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLargeBold(context)
                                .copyWith(color: colors.onSurface),
                          ),
                          const SizedBox(height: kSpaceS),
                          Text(
                            canClaimWin
                                ? lang(context).opponentAwayTooLongBody
                                : lang(context).opponentPausedBody,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge(context)
                                .copyWith(color: colors.onSurfaceVariant),
                          ),
                          if (canClaimWin) ...[
                            const SizedBox(height: kSpaceL),
                            AnimatedButton(
                              context,
                              iconData: FontAwesomeIcons.trophy,
                              text: lang(context).claimWin,
                              onPressed: onClaimWin,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
