import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/auth_repository.dart';
import '../../providers/account_repository.dart';
import '../../providers/log_repository.dart';
import '../widgets/bottom_card.dart';
import '../app_localizations.dart';

class LogoutSection extends HookConsumerWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final accountRepository = ref.read(accountRepositoryProvider.notifier);

    return Padding(
      padding: cardItemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            onPressed: () => showBottomSheet(
              context: context,
              builder: (context) => BottomCard(
                title: t.warning,
                body: SingleChildScrollView(
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
                          FilledButton(
                            onPressed: () {
                              accountRepository.cancel(next: logout);
                              logInfo(
                                site is Success
                                    ? (site as Success).data.id
                                    : null,
                                'Logout',
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).colorScheme.error,
                              ),
                            ),
                            child: Text(t.logout),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.error,
              ),
            ),
            child: Text(t.logout),
          ),
          const SizedBox(height: buttonGap),
          Text(
            t.whyLogout,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}
