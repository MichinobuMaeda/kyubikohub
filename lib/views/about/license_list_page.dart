import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/license.dart';
import 'license_card.dart';

class LicenseListPage extends HookConsumerWidget {
  const LicenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = useFuture(LicenseRegistry.licenses
        .map(
          (entry) => License(
            title: entry.packages.toList().join(', '),
            body: entry.paragraphs
                .toList()
                .map((p) => p.text.trim())
                .join('\n\n'),
          ),
        )
        .toList());

    return ListView.builder(
      itemCount: (entries.data ?? []).length,
      itemBuilder: (BuildContext context, int index) => ColoredBox(
        color: index.isOdd
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surfaceContainer,
        child: ListTile(
          title: Text(
            (entries.data ?? [])[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            (entries.data ?? [])[index].body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => showBottomSheet(
              context: context,
              builder: (context) => LicenseCard(
                title: (entries.data ?? [])[index].title,
                body: (entries.data ?? [])[index].body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
