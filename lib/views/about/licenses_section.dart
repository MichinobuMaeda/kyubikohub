import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/license.dart';
import '../widgets/list_items_section.dart';
import '../app_localizations.dart';

class LicensesSection extends HookConsumerWidget {
  const LicensesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final entries = useFuture(
      LicenseRegistry.licenses
          .map(
            (entry) => License(
              title: entry.packages.toList().join(', '),
              body: entry.paragraphs
                  .toList()
                  .map((p) => p.text.trim())
                  .join('\n\n'),
            ),
          )
          .toList(),
    );

    return ListItemsSection(
      childCount: entries.data?.length ?? 0,
      height: listItemHeightWithSubtitle,
      items: (index) => ModalSheetItemProps(
        title: entries.data![index].title,
        subtitle: entries.data![index].body,
        trailing: const Icon(Icons.more_horiz),
        topActions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copyText(entries.data![index]),
          ),
        ],
        bottomActions: [
          TextButton(
            onPressed: () => copyText(entries.data![index]),
            child: Text(t.copy),
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                entries.data![index].body,
                maxLines: 1000,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void copyText(License license) => Clipboard.setData(
        ClipboardData(text: '${license.title}\n\n${license.body}'),
      );
}
