import 'package:flutter/material.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';

/// Shared dialog utilities for combat room screens
class CombatDialogs {
  /// Show opponent ready dialog
  /// For host: shows when guest is ready
  /// For guest: shows when host is ready
  static void showOpponentReadyDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => AlertTemplate(
          title: title,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.blue, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                style: LayoutConfig(context).boldSubtitleStyle(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                lang(dialogContext).pressReadyWhenPrepared,
                style: LayoutConfig(context).contentSectionStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          possitiveButtonLabel: lang(dialogContext).ok,
          onPossitiveButtonPressed: () => Navigator.of(dialogContext).pop(),
        ),
      );
    });
  }

  /// Show both players ready dialog with auto-dismiss after 2 seconds
  static Future<void> showBothReadyDialog(BuildContext context) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertTemplate(
        title: lang(context).bothPlayersReady,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(
              lang(context).gameIsStarting,
              style: LayoutConfig(context).largeBoldStyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              lang(context).waitingForHostToSelectDifficulty,
              style: LayoutConfig(context).contentSectionStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
