import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../widgets/modal_item.dart';
import '../app_localizations.dart';
import '../account/select_site_sheet.dart';

class SelectSiteSection extends HookConsumerWidget {
  const SelectSiteSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (BuildContext context, int index) => ModalItems(
          index: index,
          height: listItemHeight,
          title: t.selectSite,
          leading: const Icon(Icons.exit_to_app),
          trailing: const Icon(Icons.more_horiz),
          child: const SelectSiteSheet(),
        ),
      ),
    );
  }
}
