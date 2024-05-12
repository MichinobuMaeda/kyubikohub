import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../widgets/select_site.dart';
import '../app_localizations.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final passwordVisible = useState(false);
    final errorMessage = useState('');
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
          Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: baseSize * 16,
              child: TextField(
                onChanged: (value) {
                  email.value = value;
                },
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
              width: baseSize * 16,
              child: TextField(
                onChanged: (value) {
                  password.value = value;
                },
                obscureText: !passwordVisible.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
                final message = await loginWithEmailAndPassword(
                  email: email.value,
                  password: password.value,
                );
                switch (message) {
                  case null:
                    errorMessage.value = '';
                    break;
                  case 'email-required':
                    errorMessage.value = t.emailRequired;
                    break;
                  case 'password-required':
                    errorMessage.value = t.passwordRequired;
                    break;
                  case 'invalid-email':
                    errorMessage.value = t.invalidEmail;
                    break;
                  case 'user-disabled':
                    errorMessage.value = t.userDisabled;
                    break;
                  case 'user-not-found':
                    errorMessage.value = t.userNotFound;
                    break;
                  case 'wrong-password':
                    errorMessage.value = t.wrongPassword;
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
            child: Text(
              errorMessage.value,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
