import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Small semi-transparent toggle button used in quick settings overlays
/// on game screens (solo and combat play screens).
class QuickSettingButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback onTap;
  final bool isActive;

  const QuickSettingButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: isActive ? 0.6 : 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: icon is FaIconData
              ? FaIcon(
                  icon as FaIconData,
                  size: 14,
                  color: color.withValues(alpha: isActive ? 1.0 : 0.35),
                )
              : Icon(
                  icon as IconData?,
                  size: 14,
                  color: color.withValues(alpha: isActive ? 1.0 : 0.35),
                ),
        ),
      ),
    );
  }
}
