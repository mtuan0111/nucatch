import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/screens/dialogs/update_notice_dialog.dart';

class UpdateCheckerWrapper extends StatefulWidget {
  final Widget child;

  const UpdateCheckerWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<UpdateCheckerWrapper> createState() => _UpdateCheckerWrapperState();
}

class _UpdateCheckerWrapperState extends State<UpdateCheckerWrapper> {
  @override
  void initState() {
    super.initState();
    // Check for updates when the app launches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppVersionBloc>().add(CheckForUpdateEvent());
    });
  }

  void _showUpdateDialog(AppVersionState state) {
    if (state.availableVersion == null || state.currentVersion == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: !state.isForceUpdate,
      builder: (context) => UpdateNoticeDialog(
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
    return BlocListener<AppVersionBloc, AppVersionState>(
      listenWhen: (previous, current) {
        // Only show dialog when status changes to updateAvailable
        return current.status == AppVersionStatus.updateAvailable &&
            previous.status != AppVersionStatus.updateAvailable;
      },
      listener: (context, state) {
        if (state.shouldShowUpdateDialog) {
          _showUpdateDialog(state);
        }
      },
      child: widget.child,
    );
  }
}
