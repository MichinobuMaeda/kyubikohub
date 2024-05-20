import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/log_repository.dart';
import '../widgets/select_site.dart';
import '../app_localizations.dart';
import '../widgets/reset_password_card.dart';
import '../widgets/auth_error_message.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final passwordVisible = useState(false);
    final status = useState<String?>(null);
    final email = useState('');
    final password = useState('');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: cardItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.loginSite(
                      site: site is Success<Site> ? site.data.name : ''),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: buttonGap),
                const SelectSite(),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: baseSize * 24,
              child: TextField(
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
            child: SizedBox(
              width: baseSize * 24,
              child: TextField(
                onChanged: (value) {
                  password.value = value;
                },
                obscureText: !passwordVisible.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
            child: FilledButton(
              child: Text(t.login),
              onPressed: () async {
                status.value = await loginWithEmailAndPassword(
                  email: email.value,
                  password: password.value,
                );
                if (status.value == null) {
                  logInfo(
                    site is Success ? (site as Success).data.id : null,
                    'Login with email: $email',
                  );
                } else {
                  logError(
                    site is Success ? (site as Success).data.id : null,
                    'Login with email: $email, error: $status.value',
                  );
                }
              },
            ),
          ),
          AuthErrorMessage(status: status.value),
          const Divider(),
          Padding(
            padding: cardItemPadding,
            child: FilledButton(
              child: Text(t.forgetYourPassword),
              onPressed: () => showBottomSheet(
                context: context,
                builder: (context) => ResetPasswordCard(
                  title: t.forgetYourPassword,
                  email: email.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
