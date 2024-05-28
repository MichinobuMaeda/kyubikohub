import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/license.dart';
import 'license_sheet.dart';

class LicensesSection extends HookConsumerWidget {
  const LicensesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return SliverFixedExtentList(
      itemExtent: baseSize * 4.0,
      delegate: SliverChildBuilderDelegate(
        childCount: entries.data?.length ?? 0,
        (BuildContext context, int index) => Material(
          type: MaterialType.transparency,
          child: ListTile(
            title: Text(
              entries.data![index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              entries.data![index].body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.more_horiz),
            hoverColor: listItemsHoverColor(context),
            tileColor: listItemsStripeColor(context, index),
            onTap: () => showBottomSheet(
              context: context,
              builder: (context) => LicenseSheet(
                title: entries.data![index].title,
                body: entries.data![index].body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
