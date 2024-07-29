import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../../l10n/app_localizations.dart';

class GuidanceSection extends HookConsumerWidget {
  const GuidanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final accountStatus = ref.watch(accountStatusProvider);
    final guide = site is Success<SiteRecord>
        ? accountStatus.manager
            ? '''
${site.data.selected.forGuests}

${site.data.selected.forMembers}

${site.data.selected.forManagers}
'''
            : accountStatus.account != null
                ? '''
${site.data.selected.forGuests}

${site.data.selected.forMembers}
'''
                : '''
${site.data.selected.forGuests}
'''
        : null;

    return SliverList.list(
      children: [
        ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: switch (site) {
            Loading() => Padding(
                padding: cardItemPadding,
                child: Text(t.defaultLoadingMessage),
              ),
            Error() => Padding(
                padding: cardItemPadding,
                child: Text(site.message),
              ),
            Success() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: cardItemPadding,
                              child: Text(
                                site.data.selected.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: cardItemPadding,
                            child: IconButton(
                              icon: const Icon(Icons.copy),
                              color: Theme.of(context).colorScheme.outline,
                              onPressed: () => Clipboard.setData(
                                ClipboardData(text: '''
# ${site.data.selected.name}

$guide
'''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: cardItemPaddingHalf.copyWith(top: 0.0),
                      child: ColoredBox(
                        color: sectionColor(context),
                        child: Padding(
                          padding: cardItemPaddingHalf,
                          child: guide == null
                              ? Text(t.defaultLoadingMessage)
                              : MarkdownBody(
                                  data: guide,
                                  onTapLink: onTapLink,
                                  styleSheet: markdownStyleSheet(context),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          },
        ),
      ],
    );
  }
}
