import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/license_entries_provider.dart';
import '../../providers/data_state.dart';
import '../app_localizations.dart';

class LicenseListPage extends HookConsumerWidget {
  const LicenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final licenses = ref.watch(licenseEntryProvider);

    return switch (licenses) {
      Loading() => Text(t.defaultLoadingMessage),
      Error() => Text(licenses.message),
      Success() => ListView(
          children: licenses.data
              .map(
                (entry) => ListTile(
                  title: Text(
                    entry.title,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  subtitle: Text(
                    entry.body,
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ),
              )
              .toList(),
        ),
    };
  }
}
