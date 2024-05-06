import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../repositories/site_repository.dart';
import '../../providers/about_app_provider.dart';
import '../../models/data_state.dart';
import '../widgets/go_site.dart';
import '../app_localizations.dart';

class AboutAppPage extends HookConsumerWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final about = ref.watch(aboutAppProvider);
    final site = ref.watch(siteRepositoryProvider);
    final bool isSite = switch (site) {
      Loading() || Error() => false,
      Success() => true,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSite)
          Padding(
            padding: cardItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GoSite(title: t.moveToSite, message: t.askAdminSiteId),
              ],
            ),
          ),
        Card(
          child: Row(
            children: [
              const SizedBox(
                height: baseSize * 6,
                width: baseSize * 6,
                child: Center(
                  child: Padding(
                    padding: imagePadding,
                    child: Image(image: assetImageLogo),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${t.version}: $version',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        switch (about) {
          Loading() => Text(t.defaultLoadingMessage),
          Error() => Text(about.message),
          Success() => Expanded(
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
# #appTitle

${t.version}: $version

${about.data}
'''),
                      ),
                    ),
                    Expanded(
                      child: Markdown(
                        data: about.data,
                        onTapLink: onTapLink,
                        padding: cardItemPadding,
                        styleSheet: markdownStyleSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        },
      ],
    );
  }
}
