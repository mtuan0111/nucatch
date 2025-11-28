import 'package:cloud_firestore/cloud_firestore.dart';

class AppVersionModel {
  final String platform;
  final String versionName;
  final String buildNumber;
  final String? releaseMessage;
  final bool isForceUpdate;
  final DateTime updatedAt;
  final DateTime createdAt;

  AppVersionModel({
    required this.platform,
    required this.versionName,
    required this.buildNumber,
    this.releaseMessage,
    required this.isForceUpdate,
    required this.updatedAt,
    required this.createdAt,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      platform: json['platform'] as String,
      versionName: json['version_name'] as String,
      buildNumber: json['build_number'] as String,
      releaseMessage: json['release_message'] as String?,
      isForceUpdate: json['is_force_update'] as bool? ?? false,
      updatedAt: (json['updated_at'] as Timestamp).toDate(),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'version_name': versionName,
      'build_number': buildNumber,
      'release_message': releaseMessage,
      'is_force_update': isForceUpdate,
      'updated_at': Timestamp.fromDate(updatedAt),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  int get buildNumberInt {
    return int.tryParse(buildNumber) ?? 0;
  }

  /// Extracts the localized release message based on the country code.
  /// Expected format: "<en>Message</en><vi>Tin nhắn</vi>"
  /// Returns null if the format is invalid or the locale is not found.
  String? getLocalizedReleaseMessage(String locale) {
    if (releaseMessage == null || releaseMessage!.isEmpty) {
      return null;
    }

    // Extract the language code (e.g., "en" from "en" or "en_US")
    final languageCode = locale.split('_').first;

    // Pattern to match: <code>content</code>
    final pattern = RegExp(
      '<$languageCode>\\s*([\\s\\S]*?)\\s*</$languageCode>',
      multiLine: true,
    );

    final match = pattern.firstMatch(releaseMessage!);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)?.trim();
    }

    // If format doesn't match or locale not found, return null
    return null;
  }

  AppVersionModel copyWith({
    String? platform,
    String? versionName,
    String? buildNumber,
    String? releaseMessage,
    bool? isForceUpdate,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return AppVersionModel(
      platform: platform ?? this.platform,
      versionName: versionName ?? this.versionName,
      buildNumber: buildNumber ?? this.buildNumber,
      releaseMessage: releaseMessage ?? this.releaseMessage,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
