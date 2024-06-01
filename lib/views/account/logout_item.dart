import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/providers/modal_sheet_controller_provider.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/account_repository.dart';
import '../../providers/log_repository.dart';
import '../widgets/modal_item.dart';
import '../app_localizations.dart';

class LogoutItem extends HookConsumerWidget {
  final int index;
  const LogoutItem({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final modalSheetController =
        ref.read(modalSheetControllerProviderProvider.notifier);
    final accountRepository = ref.read(accountRepositoryProvider.notifier);

    return ModalItem(
      index: index,
      title: t.logout,
      leading: const Icon(Icons.logout),
      trailing: const Icon(Icons.more_horiz),
      child: SingleChildScrollView(
        child: Padding(
          padding: cardItemPadding,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.confirmTo(action: t.logout),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: buttonGap),
                Text(
                  t.whyLogout,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: buttonGap),
                OutlinedButton(
                  onPressed: () {
                    modalSheetController.close();
                    accountRepository.cancel(next: logout);
                    logInfo(
                      site is Success<SiteRecord>
                          ? site.data.selected.id
                          : null,
                      'Logout',
                    );
                  },
                  child: Text(t.logout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
