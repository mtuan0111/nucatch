import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

import 'package:nucatch/helpers/auth_error_text.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/screens/dialogs/sign_in_sheet.dart';

/// The Account row inside Settings: offers Google/Apple sign-in while the
/// session is an anonymous guest, and shows which account is signed in (plus
/// a way out) once it isn't.
///
/// The sign-in itself happens in [showSignInSheet]; this row only decides
/// which of the two states to render. Sign-out is handled here because it
/// needs no provider sheet — it just returns to a fresh guest session.
class AccountSettingRow extends StatelessWidget {
  final UserState userState;

  const AccountSettingRow({super.key, required this.userState});

  @override
  Widget build(BuildContext context) {
    // Sign-out feedback has to live here rather than in the sheet: by the
    // time it happens the sheet is long gone, and an error would otherwise
    // be swallowed silently.
    return BlocListener<UserBloc, UserState>(
      listenWhen: (prev, curr) =>
          curr.errorKey != null && prev.errorKey != curr.errorKey,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorText(context, state.errorKey!))),
        );
        context.read<UserBloc>().add(AuthErrorCleared());
      },
      child: userState.isGuest
          ? _GuestView(loading: userState.isAuthenticating)
          : _SignedInView(
              label: userState.accountLabel ?? '',
              loading: userState.isAuthenticating,
            ),
    );
  }
}

class _GuestView extends StatelessWidget {
  final bool loading;

  const _GuestView({required this.loading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            lang(context).playingAsGuest,
            style: AppTextStyles.bodyMedium(context),
          ),
        ),
        const SizedBox(width: kSpaceM),
        CustomElevatedButton(
          text: lang(context).signInAction,
          buttonSize: ButtonSize.smallest,
          shapeAt: RoundedWithShapeAt.topRight,
          onPressed: loading ? null : () => showSignInSheet(context),
        ),
      ],
    );
  }
}

class _SignedInView extends StatelessWidget {
  final String label;
  final bool loading;

  const _SignedInView({required this.label, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            lang(context).signedInAs(label),
            style: AppTextStyles.bodyMedium(context),
            // A Google account label is an email address, which will not fit
            // beside the button on a phone — let it wrap rather than
            // overflow, since the row's height is not constrained.
            softWrap: true,
          ),
        ),
        const SizedBox(width: kSpaceM),
        CustomElevatedButton(
          text: lang(context).signOut,
          buttonSize: ButtonSize.smallest,
          shapeAt: RoundedWithShapeAt.topRight,
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          onPressed: loading
              ? null
              : () => context.read<UserBloc>().add(SignOutRequested()),
        ),
      ],
    );
  }
}
