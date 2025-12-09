import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nucatch/models/app_version_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionServices {
  late final FirebaseFirestore? _firestore;
  static const String collectionName = 'app_versions';
  bool _isOfflineMode = false;

  AppVersionServices() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      print('⚠️ Firestore not available (offline mode): $e');
      _firestore = null;
      _isOfflineMode = true;
    }
  }

  /// Get current platform name
  String getCurrentPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'iOS';
    }
    return 'unknown';
  }

  /// Get current app version info
  Future<PackageInfo> getCurrentAppVersion() async {
    return await PackageInfo.fromPlatform();
  }

  /// Get current build number as integer
  Future<int> getCurrentBuildNumber() async {
    final packageInfo = await getCurrentAppVersion();
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }

  /// Fetch all versions for current platform from Firestore (offline safe)
  Future<List<AppVersionModel>> fetchVersionsForPlatform() async {
    if (_isOfflineMode || _firestore == null) {
      print('📱 App version check skipped (offline mode)');
      return []; // Return empty list in offline mode
    }

    try {
      final platform = getCurrentPlatform();
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('platform', isEqualTo: platform)
          .orderBy('build_number', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AppVersionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('⚠️ Failed to fetch app versions (falling back to offline): $e');
      _isOfflineMode = true;
      return []; // Return empty list on error
    }
  }

  /// Check if update is available (offline safe)
  /// Returns the version to update to, or null if no update available
  Future<AppVersionModel?> checkForUpdate() async {
    if (_isOfflineMode) {
      print('📱 Update check skipped (offline mode)');
      return null; // No updates in offline mode
    }

    try {
      final currentBuildNumber = await getCurrentBuildNumber();
      final versions = await fetchVersionsForPlatform();

      if (versions.isEmpty) {
        return null;
      }

      // First, check for force updates that are newer than current version
      final forceUpdate = versions.firstWhere(
        (version) =>
            version.isForceUpdate &&
            version.buildNumberInt > currentBuildNumber,
        orElse: () => versions.first,
      );

      // If force update exists and is newer, return it
      if (forceUpdate.isForceUpdate &&
          forceUpdate.buildNumberInt > currentBuildNumber) {
        return forceUpdate;
      }

      // Otherwise, return the latest version if it's newer
      final latestVersion = versions.first;
      if (latestVersion.buildNumberInt > currentBuildNumber) {
        return latestVersion;
      }

      return null;
    } catch (e) {
      print('⚠️ Failed to check for updates (falling back to offline): $e');
      _isOfflineMode = true;
      return null;
    }
  }

  /// Compare two build numbers
  bool isNewerVersion(String remoteBuildNumber, String currentBuildNumber) {
    final remoteInt = int.tryParse(remoteBuildNumber) ?? 0;
    final currentInt = int.tryParse(currentBuildNumber) ?? 0;
    return remoteInt > currentInt;
  }

  /// Get the latest version info (offline safe)
  Future<AppVersionModel?> getLatestVersion() async {
    if (_isOfflineMode) {
      print('📱 Latest version check skipped (offline mode)');
      return null;
    }

    try {
      final versions = await fetchVersionsForPlatform();
      return versions.isNotEmpty ? versions.first : null;
    } catch (e) {
      print('⚠️ Failed to get latest version (falling back to offline): $e');
      _isOfflineMode = true;
      return null;
    }
  }
}
