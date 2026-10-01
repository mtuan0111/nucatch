import 'package:flutter/widgets.dart';
import 'package:nucatch/helpers/const.dart';

/// Translates an auth `errorKey` emitted by `AuthServices`/`UserBloc` into a
/// user-facing string.
///
/// The service layer deals only in keys — a `FirebaseAuthException` never
/// escapes it — so this is the single place that turns one into words. An
/// unrecognized key falls back to the generic failure rather than showing a
/// raw identifier.
String authErrorText(BuildContext context, String key) {
  final l = lang(context);
  return switch (key) {
    'authErrorCancelled' => l.authErrorCancelled,
    'authErrorNetwork' => l.authErrorNetwork,
    'authErrorCredentialRejected' => l.authErrorCredentialRejected,
    'authErrorProviderDisabled' => l.authErrorProviderDisabled,
    'authErrorAppleUnavailable' => l.authErrorAppleUnavailable,
    'authErrorTooManyRequests' => l.authErrorTooManyRequests,
    'authErrorAlreadyLinked' => l.authErrorAlreadyLinked,
    'authErrorAccountDisabled' => l.authErrorAccountDisabled,
    'authErrorAccountExistsDifferentCredential' =>
      l.authErrorAccountExistsDifferentCredential,
    'authErrorLinkConflict' => l.authErrorLinkConflict,
    _ => l.authError,
  };
}
