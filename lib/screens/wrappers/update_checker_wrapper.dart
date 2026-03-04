import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide UpdateCheckerWrapper; // Use local version that wraps skeleton_core's
import 'package:skeleton_core/src/widgets/update_checker_wrapper.dart' as core;
import 'package:nucatch/screens/dialogs/update_notice_dialog.dart';

/// Nucatch-specific update checker that wraps skeleton_core's
/// [UpdateCheckerWrapper] with the app's localized [UpdateNoticeDialog].
class UpdateCheckerWrapper extends StatelessWidget {
  final Widget child;

  const UpdateCheckerWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  void _showUpdateDialog(BuildContext context, AppVersionState state) {
    if (state.availableVersion == null || state.currentVersion == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: !state.isForceUpdate,
      builder: (dialogContext) => UpdateNoticeDialog(
        versionInfo: state.availableVersion!,
        currentVersion: state.currentVersion!,
        isForceUpdate: state.isForceUpdate,
        onUpdateLater: () {
          context.read<AppVersionBloc>().add(UpdateLaterEvent());
        },
        onDismiss: () {
          context.read<AppVersionBloc>().add(DismissUpdateEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return core.UpdateCheckerWrapper(
      onShowUpdateDialog: _showUpdateDialog,
      child: child,
    );
  }
}
