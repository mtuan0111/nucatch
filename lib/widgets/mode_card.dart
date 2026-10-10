import 'package:flutter/material.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// Widest the row of [ModeCard]s gets, so on a tablet they stay a centred
/// pair rather than stretching edge to edge.
const double kModeCardsMaxWidth = 900;

/// A play-mode choice (Solo / Combat, Create / Join room): one glossy card
/// that is a single tap target, with the icon, title and description inside
/// it. Replaces skeleton_core's [OptionCard] on these screens, whose dark
/// speech bubble and separate icon tile didn't match the rest of the app
/// and left it unclear what to tap.
class ModeCard extends StatelessWidget {
  final String title;
  final String description;
  final FaIconData icon;
  final Color color;
  final VoidCallback onTap;

  const ModeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onColor = color.getSmartColor(context);
    final iconSize = AppTextStyles.titleLarge(context).fontSize! * 1.4;
    return Semantics(
      button: true,
      label: title,
      child: CustomElevatedButton(
        onPressed: onTap,
        backgroundColor: color,
        shapeAt: RoundedWithShapeAt.topLeft,
        minWidth: double.infinity,
        backgroundBuilder: (context, borderRadius) => LightningWidget(
          baseColor: color,
          seed: title.hashCode,
          borderRadius: borderRadius,
        ),
        // A Padding, not a bare Row: CustomElevatedButton pins a Row child
        // to its intrinsic width, which would stop the description wrapping.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kSpaceS),
          child: Row(
            children: [
              Container(
                width: iconSize * 1.9,
                height: iconSize * 1.9,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(icon, color: onColor, size: iconSize),
              ),
              const SizedBox(width: kSpaceL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleLarge(context).copyWith(
                        color: onColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: kSpaceXS),
                    Text(
                      description,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: onColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kSpaceS),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                color: onColor.withValues(alpha: 0.8),
                size: iconSize * 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
