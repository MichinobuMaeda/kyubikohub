import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../repositories/firebase_repository.dart';
import '../../repositories/log_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../../l10n/app_localizations.dart';
import 'auth_error_message.dart';
import 'reset_password_form.dart';

class ChangePasswordForm extends HookConsumerWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final curPassword = useState<String>('');
    final newPassword = useState<String>('');
    final conPassword = useState<String>('');
    final curPasswordVisible = useState(false);
    final newPasswordVisible = useState(false);
    final conPasswordVisible = useState(false);
    final status = useState<String?>(null);
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: cardItemPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                curPassword.value = value;
              },
              obscureText: !curPasswordVisible.value,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                labelText: t.curPassword,
                suffixIcon: IconButton(
                  icon: Icon(curPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    curPasswordVisible.value = !curPasswordVisible.value;
                  },
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                newPassword.value = value;
              },
              obscureText: !newPasswordVisible.value,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                labelText: t.newPassword,
                suffixIcon: IconButton(
                  icon: Icon(newPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    newPasswordVisible.value = !newPasswordVisible.value;
                  },
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                conPassword.value = value;
              },
              obscureText: !conPasswordVisible.value,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                labelText: t.conPassword,
                suffixIcon: IconButton(
                  icon: Icon(conPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    conPasswordVisible.value = !conPasswordVisible.value;
                  },
                ),
              ),
            ),
            const SizedBox(height: buttonGap),
            FilledButton(
              child: Text(t.changePassword),
              onPressed: () async {
                status.value = null;
                status.value = await changePassword(
                  curPassword: curPassword.value,
                  newPassword: newPassword.value,
                  conPassword: conPassword.value,
                );
                if (status.value == 'ok') {
                  logInfo(
                    site is Success ? (site as Success).data.id : null,
                    'Change password success',
                  );
                } else {
                  logError(
                    site is Success ? (site as Success).data.id : null,
                    'Change password error: $status.value',
                  );
                }
              },
            ),
            AuthErrorMessage(status: status.value),
            const SizedBox(height: buttonGap),
            OutlinedButton(
              child: Text(t.forgetYourPassword),
              onPressed: () {
                controller.set(
                  showBottomSheet(
                    backgroundColor: modalColor(context),
                    context: context,
                    builder: (context) => ResetPasswordForm(
                      title: t.forgetYourPassword,
                      email: getUserEmail(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
