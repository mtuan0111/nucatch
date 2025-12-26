import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/models/app_version_model.dart';
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
            ? lang(context).updateRequired
            : lang(context).updateAvailable,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                lang(context).currentVersion,
                currentVersion,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                lang(context).newVersion,
                versionInfo.versionName,
              ),
              if (localizedMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  lang(context).whatsNew,
                  style: LayoutConfig(context).contentSectionStyle().copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizedMessage,
                  style: LayoutConfig(context).contentSectionStyle().copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
              if (isForceUpdate) ...[
                const SizedBox(height: 16),
                CustomElevatedButton(
                  backgroundColor: Colors.orangeAccent,
                  // padding: const EdgeInsets.all(12),
                  // decoration: BoxDecoration(
                  //   color: Colors.orange.withValues(alpha: 0.1),
                  //   borderRadius: BorderRadius.circular(8),
                  //   border: Border.all(
                  //     color: Colors.orange.withValues(alpha: 0.3),
                  //   ),
                  // ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                        // size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lang(context).forceUpdateMessage,
                          style: LayoutConfig(context)
                              .contentSectionStyle()
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                // fontSize: 12,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        possitiveButtonLabel:
            isForceUpdate ? lang(context).updateNow : lang(context).update,
        onPossitiveButtonPressed: () {
          _launchStore();
        },
        negativeButtonLabel: !isForceUpdate ? lang(context).later : null,
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
          style: LayoutConfig(context).contentSectionStyle().copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          value,
          style: LayoutConfig(context).contentSectionStyle().copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ],
    );
  }
}
