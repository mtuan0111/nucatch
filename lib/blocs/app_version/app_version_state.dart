import 'package:nucatch/models/app_version_model.dart';

enum AppVersionStatus {
  initial,
  checking,
  updateAvailable,
  noUpdate,
  error,
  dismissed,
}

class AppVersionState {
  final AppVersionStatus status;
  final AppVersionModel? availableVersion;
  final String? currentVersion;
  final String? currentBuildNumber;
  final String? errorMessage;
  final bool isForceUpdate;

  const AppVersionState({
    this.status = AppVersionStatus.initial,
    this.availableVersion,
    this.currentVersion,
    this.currentBuildNumber,
    this.errorMessage,
    this.isForceUpdate = false,
  });

  AppVersionState copyWith({
    AppVersionStatus? status,
    AppVersionModel? availableVersion,
    String? currentVersion,
    String? currentBuildNumber,
    String? errorMessage,
    bool? isForceUpdate,
  }) {
    return AppVersionState(
      status: status ?? this.status,
      availableVersion: availableVersion ?? this.availableVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      currentBuildNumber: currentBuildNumber ?? this.currentBuildNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
    );
  }

  bool get shouldShowUpdateDialog =>
      status == AppVersionStatus.updateAvailable && !isDismissed;

  bool get isDismissed => status == AppVersionStatus.dismissed;

  bool get canDismiss => !isForceUpdate;
}
