import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../repositories/site_repository.dart';
import '../../repositories/auth_repository.dart';
import '../widgets/select_site.dart';
import '../app_localizations.dart';

enum LoginMethod { emailLink, password }

class LoginMethodItem {
  final LoginMethod value;
  final String title;
  const LoginMethodItem({required this.value, required this.title});
}

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final loginMethods = [
      LoginMethodItem(value: LoginMethod.emailLink, title: t.emailLink),
      LoginMethodItem(value: LoginMethod.password, title: t.emailAndPassword),
    ];
    final loginMethod = useState(LoginMethod.emailLink);
    final errorMessage = useState('');
    final email = useState('');
    final password = useState('');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: cardItemPadding,
            child: Text(
              t.loginSite(site: site is Success<Site> ? site.data.name : ''),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Padding(
            padding: cardItemPadding,
            child: SelectSite(),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: cardItemPadding,
                  child: Text(
                    t.selectLoginMethod,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ...loginMethods.map(
                  (item) => RadioListTile(
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    value: item.value,
                    groupValue: loginMethod.value,
                    onChanged: (value) {
                      loginMethod.value = value!;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: 256.0,
              child: TextField(
                onChanged: (value) {
                  email.value = value;
                },
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
              width: 256.0,
              child: TextField(
                onChanged: (value) {
                  password.value = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  label: Text(t.password),
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
