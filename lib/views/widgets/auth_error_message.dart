import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../app_localizations.dart';

class AuthErrorMessage extends HookConsumerWidget {
  final String? status;
  final String? successMessage;
  const AuthErrorMessage({
    super.key,
    required this.status,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return status == 'ok'
        ? successMessage != null
            ? Padding(
                padding: cardItemPadding,
                child: Text(
                  successMessage!,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              )
            : const SizedBox.shrink()
        : Padding(
            padding: cardItemPadding,
            child: Text(
              statusToMessage(t, status),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
  }
}

String statusToMessage(AppLocalizations t, String? status) {
  switch (status) {
    case null || '' || 'ok':
      return '';
    case 'email-required':
      return t.emailRequired;
    case 'password-required':
      return t.passwordRequired;
    case 'invalid-email':
      return t.invalidEmail;
    case 'user-disabled':
      return t.userDisabled;
    case 'user-not-found':
      return t.userNotFound;
    case 'wrong-password':
      return t.wrongPassword;
    case 'curPassword-required':
      return t.curPasswordRequired;
    case 'newPassword-required':
      return t.newPasswordRequired;
    case 'conPassword-required':
      return t.conPasswordRequired;
    case 'password-mismatch':
      return t.passwordMismatch;
    case 'weak-password':
      return t.weakPassword;
    default:
      return t.authFailed;
  }
}
