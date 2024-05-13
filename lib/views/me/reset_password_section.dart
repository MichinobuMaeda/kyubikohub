import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/log_repository.dart';
import '../app_localizations.dart';

class ResetPasswordSection extends HookConsumerWidget {
  const ResetPasswordSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final errorMessage = useState<String?>(null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: cardItemPadding,
          child: FilledButton(
            child: Text(t.resetPassword),
            onPressed: () async {
              final message = await resetMyPassword(
                (site is Success) ? (site as Success).data.id : null,
              );
              if (message == null) {
                logInfo(
                  site is Success ? (site as Success).data.id : null,
                  'Reset password success',
                );
              } else {
                logError(
                  site is Success ? (site as Success).data.id : null,
                  'Reset password error: $message',
                );
              }
              switch (message) {
                case null:
                  errorMessage.value = '';
                  break;
                default:
                  errorMessage.value = t.authFailed;
                  break;
              }
            },
          ),
        ),
        Padding(
          padding: cardItemPadding,
          child: Text('${t.sendResetPasswordEmail}\n${t.acceptEmail}'),
        ),
        if (errorMessage.value?.isNotEmpty == true)
          Padding(
            padding: cardItemPadding,
            child: Text(
              errorMessage.value ?? t.authFailed,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (errorMessage.value?.isEmpty == true)
          Padding(
            padding: cardItemPadding,
            child: Text(
              t.sentEmail,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
      ],
    );
  }
}
