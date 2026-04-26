import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateNoticeDialog extends StatelessWidget {
  final AppVersionModel versionInfo;
  final String currentVersion;
  final bool isForceUpdate;
  final VoidCallback? onUpdateLater;
  final VoidCallback? onDismiss;

  const UpdateNoticeDialog({
    Key? key,
    required this.versionInfo,
    required this.currentVersion,
    required this.isForceUpdate,
    this.onUpdateLater,
    this.onDismiss,
  }) : super(key: key);

  String get _storeUrl {
    if (Platform.isAndroid) {
      final packageName =
          dotenv.env['ANDROID_PACKAGE_NAME'] ?? 'com.example.nucatch';
      return 'https://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      final appId = dotenv.env['IOS_APP_ID'] ?? '1234567890';
      return 'https://apps.apple.com/app/id$appId';
    }
    return '';
  }

  Future<void> _launchStore() async {
    final uri = Uri.parse(_storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current locale
    final locale = Localizations.localeOf(context).toString();
    final localizedMessage = versionInfo.getLocalizedReleaseMessage(locale);

    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: AlertTemplate(
        title: isForceUpdate
            ? coreLang(context).updateRequired
            : coreLang(context).updateAvailable,
        headerContent: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                coreLang(context).currentVersion,
                currentVersion,
              ),
              const SizedBox(height: kSpaceSM),
              _buildInfoRow(
                context,
                coreLang(context).newVersion,
                versionInfo.versionName,
              ),
              if (localizedMessage != null) ...[
                const SizedBox(height: kSpaceL),
                Text(
                  coreLang(context).whatsNew,
                  style: AppTextStyles.bodyLargeBoldOnDialogBackground(context),
                ),
                const SizedBox(height: kSpaceSM),
                Text(
                  localizedMessage,
                  style: AppTextStyles.bodyLargeOnDialogBackground(context),
                ),
              ],
              if (isForceUpdate) ...[
                const SizedBox(height: kSpaceL),
                CustomElevatedButton(
                  backgroundColor: Colors.orangeAccent,
                  // padding: const EdgeInsets.all(kPaddingML),
                  // decoration: BoxDecoration(
                  //   color: Colors.orange.withValues(alpha: 0.1),
                  //   borderRadius: BorderRadius.circular(kBorderRadiusM),
                  //   border: Border.all(
                  //     color: Colors.orange.withValues(alpha: 0.3),
                  //   ),
                  // ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onSurface,
                        // size: kIconSizeM,
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: Text(
                          coreLang(context).forceUpdateMessage,
                          style: AppTextStyles.withColor(
                              AppTextStyles.bodyLarge(context),
                              Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        possitiveButtonLabel: isForceUpdate
            ? coreLang(context).updateNow
            : coreLang(context).update,
        onPossitiveButtonPressed: () {
          _launchStore();
        },
        negativeButtonLabel: !isForceUpdate ? coreLang(context).later : null,
        onNegativeButtonPressed: !isForceUpdate
            ? () {
                Navigator.of(context).pop();
                onUpdateLater?.call();
              }
            : null,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLargeBoldOnDialogBackground(context),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLargeOnDialogBackground(context),
        ),
      ],
    );
  }
}
