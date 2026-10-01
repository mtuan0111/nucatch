import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

import 'package:nucatch/helpers/auth_error_text.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/lightning_painter.dart';

/// Opens [SignInSheet] as a modal.
///
/// `useRootNavigator: true` so it renders above the tour/tutorial spotlight
/// overlays, matching `showDialog`'s default and the rest of the app's
/// dialogs.
Future<void> showSignInSheet(BuildContext context) {
  final userBloc = context.read<UserBloc>();
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) =>
        BlocProvider.value(value: userBloc, child: const SignInSheet()),
  );
}

/// Google/Apple sign-in UI. Every action dispatches a [UserBloc] event and
/// lets the bloc's own loading/error state drive the UI — no direct service
/// calls from a widget.
///
/// Self-contained: owns its own error / link-conflict / link-success
/// feedback, so wherever it is opened from gets that feedback for free
/// without the host screen wiring it up separately.
class SignInSheet extends StatelessWidget {
  const SignInSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listenWhen: (prev, curr) =>
              curr.errorKey != null && prev.errorKey != curr.errorKey,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(authErrorText(context, state.errorKey!))),
            );
            context.read<UserBloc>().add(AuthErrorCleared());
          },
        ),
        BlocListener<UserBloc, UserState>(
          listenWhen: (prev, curr) =>
              !prev.shouldShowLinkSuccess && curr.shouldShowLinkSuccess,
          listener: (context, state) {
            // The upgrade succeeded, so the sheet has served its purpose —
            // close it before confirming, or the toast lands behind it.
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(lang(context).linkSuccessMessage)),
            );
            context.read<UserBloc>().add(LinkSuccessCleared());
          },
        ),
        BlocListener<UserBloc, UserState>(
          listenWhen: (prev, curr) =>
              !prev.shouldShowLinkConflict && curr.shouldShowLinkConflict,
          listener: (context, state) => showDialog<void>(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<UserBloc>(),
              child: const _LinkConflictDialog(),
            ),
          ),
        ),
      ],
      // As a modal sheet this sits flush against the screen edge, so without
      // this the last button lands under the home indicator on a
      // gesture-navigation phone. `top: false` because the sheet is anchored
      // at the bottom.
      child: SafeArea(
        top: false,
        child: DeviceWrapper(
          child: Container(
            margin: const EdgeInsets.all(kPaddingL),
            padding: const EdgeInsets.all(kPaddingXL),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  BorderRadius.circular(LayoutConfig.layoutBorderRadius),
            ),
            child: const _SignInBody(),
          ),
        ),
      ),
    );
  }
}

class _SignInBody extends StatelessWidget {
  const _SignInBody();

  @override
  Widget build(BuildContext context) {
    final loading = context.select((UserBloc b) => b.state.isAuthenticating);
    // Which platforms can actually complete an Apple sign-in — and by which
    // mechanism — lives in one place, shared with the service-layer
    // backstop. See isAppleSignInSupported.
    final canSignInWithApple = isAppleSignInSupported;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          lang(context).signInTitle,
          style: AppTextStyles.titleLarge(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpaceM),
        Text(
          lang(context).signInSubtitle,
          style: AppTextStyles.bodyMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpaceXL),
        _ProviderButton(
          label: lang(context).signInWithGoogle,
          icon: FontAwesomeIcons.google,
          enabled: !loading,
          onPressed: () =>
              context.read<UserBloc>().add(SignInWithGoogleRequested()),
        ),
        if (canSignInWithApple) ...[
          const SizedBox(height: kSpaceM),
          _ProviderButton(
            label: lang(context).signInWithApple,
            icon: FontAwesomeIcons.apple,
            enabled: !loading,
            onPressed: () =>
                context.read<UserBloc>().add(SignInWithAppleRequested()),
          ),
        ],
        if (loading) ...[
          const SizedBox(height: kSpaceXL),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _ProviderButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: label,
      iconData: icon,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topLeft,
      // A disabled CustomElevatedButton takes a null onPressed — unlike
      // AnimatedButton's `isEnable`, which only dims it and still fires.
      onPressed: enabled ? onPressed : null,
      backgroundBuilder: (context, borderRadius) => LightningWidget(
        baseColor: Theme.of(context).primaryColor,
        seed: label.hashCode,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Asks whether to abandon the current guest session for the existing
/// account that already owns the credential the user just presented.
///
/// Only reachable from a real [AuthLinkConflict]: the scores tied to the
/// guest `uid` genuinely do not come along, so this has to be a deliberate
/// choice rather than a silent switch.
class _LinkConflictDialog extends StatelessWidget {
  const _LinkConflictDialog();

  @override
  Widget build(BuildContext context) {
    return AlertTemplate(
      title: lang(context).linkConflictTitle,
      message: lang(context).linkConflictMessage,
      possitiveButtonLabel: lang(context).linkConflictSwitch,
      onPossitiveButtonPressed: () {
        context.read<UserBloc>().add(AccountSwitchConfirmed());
        Navigator.of(context).pop();
      },
      negativeButtonLabel: coreLang(context).cancel,
      onNegativeButtonPressed: () {
        context.read<UserBloc>().add(LinkConflictDismissed());
        Navigator.of(context).pop();
      },
    );
  }
}
