import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/log_repository.dart';
import '../app_localizations.dart';
import '../widgets/modal_sheet.dart';
import 'auth_error_message.dart';

class ResetPasswordSheet extends HookConsumerWidget {
  final String title;
  final String? email;
  final TextEditingController _textEditingController = TextEditingController();
  ResetPasswordSheet({super.key, required this.title, this.email}) {
    _textEditingController.text = email ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final email = useState(this.email);
    final status = useState<String?>(null);

    return ModalSheet(
      title: title,
      body: SingleChildScrollView(
        child: Padding(
          padding: cardItemPadding,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    width: baseSize * 24,
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        email.value = value;
                      },
                      autofocus: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        label: Text(t.email),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: cardItemPadding,
                  child: FilledButton(
                    child: Text(t.resetPassword),
                    onPressed: () async {
                      status.value = null;
                      status.value = await resetPassword(
                        (site is Success) ? (site as Success).data.id : null,
                        email.value,
                      );
                      if (status.value == 'ok') {
                        logInfo(
                          site is Success ? (site as Success).data.id : null,
                          'Reset password of ${email.value} success',
                        );
                      } else {
                        logError(
                          site is Success ? (site as Success).data.id : null,
                          'Reset password of ${email.value} error: $status.value',
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    width: baseSize * 36,
                    child:
                        Text('${t.sendResetPasswordEmail}\n${t.acceptEmail}'),
                  ),
                ),
                AuthErrorMessage(status: status.value),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
