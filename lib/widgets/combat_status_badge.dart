import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A reusable badge widget for combat status indicators.
///
/// Displays a colored container with an optional icon and text,
/// using green for positive/active states and orange for waiting states.
class CombatStatusBadge extends StatelessWidget {
  final String text;
  final bool isPositive;
  final FaIconData? icon;
  final bool filled;

  const CombatStatusBadge({
    super.key,
    required this.text,
    required this.isPositive,
    this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpaceL,
        vertical: kSpaceS,
      ),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(kBorderRadiusL),
        border: filled
            ? null
            : Border.all(
                color: color,
                width: 2,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            FaIcon(
              icon,
              color: filled ? Colors.white : color,
              size: kFontSizeL,
            ),
            const SizedBox(width: kSpaceS),
          ],
          Flexible(
            child: Text(
              text,
              style: filled
                  ? AppTextStyles.bodySmall(context)
                  : AppTextStyles.bodyMediumBold(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
