import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../app_localizations.dart';

class GuidancePage extends HookConsumerWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final isMember = ref.watch(accountRepositoryProvider) is Success;
    final guide = site is Success<(Site, List<Site>)>
        ? isMember
            ? '''
${site.data.$1.forGuests}

${site.data.$1.forMembers}
'''
            : '''
${site.data.$1.forGuests}
'''
        : '';

    return switch (site) {
      Loading() => Text(t.defaultLoadingMessage),
      Error() => Text(site.message),
      Success() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Row(
                children: [
                  Padding(
                    padding: cardItemPadding,
                    child: Text(
                      site.data.$1.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: iconButtonTransformVerticalOffset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      color: Theme.of(context).colorScheme.outline,
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: '''
# ${site.data.$1.name}

$guide
'''),
                      ),
                    ),
                    Expanded(
                      child: Markdown(
                        data: guide,
                        onTapLink: onTapLink,
                        padding: cardItemPadding,
                        styleSheet: markdownStyleSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    };
  }
}
