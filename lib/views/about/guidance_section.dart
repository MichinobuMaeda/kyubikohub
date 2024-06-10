import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../app_localizations.dart';

class GuidanceSection extends HookConsumerWidget {
  final _scrollController = ScrollController();

  GuidanceSection({super.key});

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

${site.data.selected.forMangers}
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

    return SliverToBoxAdapter(
      child: Container(
        color: sectionColor(context),
        height: baseSize * 24.0,
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
                Expanded(
                  child: Column(
                    children: [
                      guide == null
                          ? Padding(
                              padding: cardItemPadding,
                              child: Text(t.defaultLoadingMessage),
                            )
                          : Expanded(
                              child: Scrollbar(
                                controller: _scrollController,
                                child: Markdown(
                                  controller: _scrollController,
                                  data: guide,
                                  onTapLink: onTapLink,
                                  padding: cardItemPadding,
                                  styleSheet: markdownStyleSheet(context),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
