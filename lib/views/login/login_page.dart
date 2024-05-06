import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../repositories/site_repository.dart';
import '../widgets/go_site.dart';
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
    final loginMethod = useState(LoginMethod.emailLink);
    final loginMethods = [
      LoginMethodItem(value: LoginMethod.emailLink, title: t.emailLink),
      LoginMethodItem(value: LoginMethod.password, title: t.password),
    ];
    final site = ref.watch(siteRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: cardItemPadding,
          child: Text(
            t.loginSite(site: site is Success<Site> ? site.data.name : ''),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: cardItemPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoSite(title: t.changeSite, message: t.askAdminSiteId),
            ],
          ),
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
      ],
    );
  }
}
