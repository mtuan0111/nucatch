import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/app_version/app_version_event.dart';
import 'package:nucatch/blocs/app_version/app_version_state.dart';
import 'package:nucatch/services/app_version_services.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionServices _appVersionServices;

  AppVersionBloc({AppVersionServices? appVersionServices})
      : _appVersionServices = appVersionServices ?? AppVersionServices(),
        super(const AppVersionState()) {
    on<CheckForUpdateEvent>(_onCheckForUpdate);
    on<DismissUpdateEvent>(_onDismissUpdate);
    on<UpdateLaterEvent>(_onUpdateLater);
  }

  Future<void> _onCheckForUpdate(
    CheckForUpdateEvent event,
    Emitter<AppVersionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AppVersionStatus.checking));

      // Get current app version
      final packageInfo = await _appVersionServices.getCurrentAppVersion();
      final currentVersion = packageInfo.version;
      final currentBuildNumber = packageInfo.buildNumber;

      // Check for available updates
      final availableUpdate = await _appVersionServices.checkForUpdate();

      if (availableUpdate != null) {
        emit(state.copyWith(
          status: AppVersionStatus.updateAvailable,
          availableVersion: availableUpdate,
          currentVersion: currentVersion,
          currentBuildNumber: currentBuildNumber,
          isForceUpdate: availableUpdate.isForceUpdate,
        ));
      } else {
        emit(state.copyWith(
          status: AppVersionStatus.noUpdate,
          currentVersion: currentVersion,
          currentBuildNumber: currentBuildNumber,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AppVersionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDismissUpdate(
    DismissUpdateEvent event,
    Emitter<AppVersionState> emit,
  ) {
    // Only allow dismiss if it's not a force update
    if (!state.isForceUpdate) {
      emit(state.copyWith(status: AppVersionStatus.dismissed));
    }
  }

  void _onUpdateLater(
    UpdateLaterEvent event,
    Emitter<AppVersionState> emit,
  ) {
    // Only allow "later" if it's not a force update
    if (!state.isForceUpdate) {
      emit(state.copyWith(status: AppVersionStatus.dismissed));
    }
  }
}
