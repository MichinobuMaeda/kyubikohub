import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/license.dart';
import 'license_card.dart';

class LicenseListPage extends HookConsumerWidget {
  const LicenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = useFuture(LicenseRegistry.licenses.toList());

    return ListView(
      children: entries.data
              ?.map(
                (entry) => License(
                  title: entry.packages.toList().join(', '),
                  body: entry.paragraphs
                      .toList()
                      .map((p) => p.text.trim())
                      .join('\n\n'),
                ),
              )
              .map(
                (entry) => ListTile(
                  title: Text(
                    entry.title,
                    overflow: TextOverflow.fade,
                    maxLines: licenseListTitleMaxLines,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  subtitle: Text(
                    entry.body,
                    overflow: TextOverflow.fade,
                    maxLines: licenseListBodyMaxLines,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => showBottomSheet(
                      context: context,
                      builder: (context) => LicenseCard(
                        title: entry.title,
                        body: entry.body,
                      ),
                    ),
                  ),
                ),
              )
              .toList() ??
          [],
    );
  }
}
