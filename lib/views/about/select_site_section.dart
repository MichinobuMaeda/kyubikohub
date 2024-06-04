import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/modal_items_section.dart';
import '../app_localizations.dart';
import '../account/select_site_form.dart';

class SelectSiteSection extends HookConsumerWidget {
  const SelectSiteSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return ModalItemsSection(
      childCount: 1,
      item: (index) => ModalItem(
        title: t.selectSite,
        leading: const Icon(Icons.exit_to_app),
        trailing: const Icon(Icons.more_horiz),
        child: const SelectSiteForm(),
      ),
    );
  }
}
