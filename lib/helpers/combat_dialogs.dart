import 'package:flutter/material.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/ui_constants.dart';
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
              Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary.getDarker(),
                size: kIconSizeXL,
              ),
              const SizedBox(height: kSpaceL),
              Text(
                message,
                style: LayoutConfig(context).boldSubtitleStyle().copyWith(
                      color: Theme.of(context).colorScheme.primary.getDarker(),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kSpaceSM),
              Text(
                lang(dialogContext).pressReadyWhenPrepared,
                style: LayoutConfig(context).contentSectionStyle(
                  color: Theme.of(context).colorScheme.primary.getDarker(),
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
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary.getDarker(),
              size: kIconSizeXL,
            ),
            const SizedBox(height: kSpaceL),
            Text(
              lang(context).gameIsStarting,
              style: LayoutConfig(context).largeBoldStyle().copyWith(
                  color: Theme.of(context).colorScheme.primary.getDarker()),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpaceSM),
            Text(
              lang(context).waitingForHostToSelectDifficulty,
              style: LayoutConfig(context).contentSectionStyle(
                color: Theme.of(context).colorScheme.primary.getDarker(),
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
