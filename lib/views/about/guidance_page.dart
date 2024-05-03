import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../repositories/site_repository.dart';
import '../../providers/data_state.dart';
import '../app_localizations.dart';

class GuidancePage extends HookConsumerWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);

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
                      site.data.name,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
# ${site.data.name}

${site.data.desc}
'''),
                      ),
                    ),
                    Expanded(
                      child: Markdown(
                        data: site.data.desc,
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
