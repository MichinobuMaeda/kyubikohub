import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/repositories/account_repository.dart';
import 'package:kyubikohub/repositories/site_repository.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../repositories/auth_repository.dart';
import '../widgets/select_site.dart';
import '../app_localizations.dart';

class MyAccountPage extends HookConsumerWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final accountRepository = ref.read(accountRepositoryProvider.notifier);
    final site = ref.watch(siteRepositoryProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: cardItemPadding,
            child: SelectSite(),
          ),
          Padding(
            padding: cardItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: cardItemPadding,
                  child: FilledButton(
                    onPressed: () {
                      accountRepository.onAuthUserChanged(
                        (site as Success<Site>).data,
                        null,
                      );
                      logout();
                    },
                    child: Text(t.logout),
                  ),
                ),
                Text(
                  t.whyLogout,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
