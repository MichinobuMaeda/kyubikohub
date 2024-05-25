import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../app_localizations.dart';
import 'site_card.dart';

class SitesPage extends HookConsumerWidget {
  const SitesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final siteProvider = ref.watch(siteRepositoryProvider);
    final List<Site> sites = (siteProvider is Success<(Site, List<Site>)>)
        ? siteProvider.data.$2
        : [];

    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: baseSize * 64),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => ColoredBox(
            color: index.isOdd
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surfaceContainer,
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      index == 0 ? t.add : sites[index - 1].name,
                      style: index != 0 && sites[index - 1].deleted
                          ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).colorScheme.error,
                            )
                          : null,
                    ),
                  ),
                  Icon(index == 0 ? Icons.add : Icons.edit)
                ],
              ),
              onTap: () {
                showBottomSheet(
                  context: context,
                  builder: (context) => SiteCard(
                    site: index == 0 ? null : sites[index - 1],
                  ),
                );
              },
            ),
          ),
          itemCount: sites.length + 1,
        ),
      ),
    );
  }
}
