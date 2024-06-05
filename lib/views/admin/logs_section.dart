import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/log.dart';
import '../../providers/log_repository.dart';
import '../widgets/modal_items_section.dart';
import '../app_localizations.dart';

class LogsSection extends HookConsumerWidget {
  final String? site;
  const LogsSection({super.key, this.site});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final logProvider = ref.watch(logRepositoryProvider.call(site: site));
    final List<Log?> logs = [
      ...logProvider.when(
        data: (items) => items,
        error: (e, s) => [],
        loading: () => [],
      ),
      null,
    ];

    return ModalItemsSection(
      childCount: logs.length,
      height: listItemHeightWithSubtitle,
      item: (index) => ModalItem(
        title: logs[index]?.ts.toIso8601String().replaceFirst('T', '') ??
            t.showMore,
        subtitle: logs[index]?.message,
        leading: logs[index] == null ? const Icon(Icons.more_vert) : null,
        trailing: logs[index] == null ? null : const Icon(Icons.more_horiz),
        child: SingleChildScrollView(
          child: Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: double.infinity,
              child: logs[index] == null
                  ? const Text('Under construction')
                  : Text(logs[index]!.message),
            ),
          ),
        ),
      ),
    );
  }
}
