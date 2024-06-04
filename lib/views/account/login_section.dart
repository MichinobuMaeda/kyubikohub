import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/log_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../app_localizations.dart';
import 'reset_password_form.dart';
import 'auth_error_message.dart';

class LoginSection extends HookConsumerWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final passwordVisible = useState(false);
    final status = useState<String?>(null);
    final email = useState('');
    final password = useState('');
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: baseSize * 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: cardItemPadding,
              child: SizedBox(
                width: baseSize * 24,
                child: TextField(
                  onChanged: (value) {
                    email.value = value;
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    label: Text(t.email),
                  ),
                ),
              ),
            ),
            Padding(
              padding: cardItemPadding,
              child: SizedBox(
                width: baseSize * 24,
                child: TextField(
                  onChanged: (value) {
                    password.value = value;
                  },
                  obscureText: !passwordVisible.value,
                  decoration: InputDecoration(
                    label: Text(t.password),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        passwordVisible.value = !passwordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: cardItemPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.login),
                        const SizedBox(width: iconTextGap),
                        Text(t.login),
                      ],
                    ),
                    onPressed: () async {
                      status.value = await loginWithEmailAndPassword(
                        email: email.value,
                        password: password.value,
                      );
                      if (status.value == null) {
                        logInfo(
                          site is Success
                              ? (site as Success<SiteRecord>).data.selected.id
                              : null,
                          'Login with email: $email',
                        );
                      } else {
                        logError(
                          site is Success
                              ? (site as Success<SiteRecord>).data.selected.id
                              : null,
                          'Login with email: $email, error: $status.value',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: buttonGap),
                  AuthErrorMessage(status: status.value),
                  const SizedBox(height: buttonGap),
                  OutlinedButton(
                    child: Text(t.forgetYourPassword),
                    onPressed: () {
                      controller.set(
                        showBottomSheet(
                          context: context,
                          builder: (context) => ResetPasswordForm(
                            title: t.forgetYourPassword,
                            email: email.value,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
