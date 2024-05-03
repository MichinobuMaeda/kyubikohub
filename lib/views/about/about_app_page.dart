import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../repositories/site_repository.dart';
import '../../providers/about_app_provider.dart';
import '../../providers/data_state.dart';
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

    final selectedSite = useState<String?>(null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSite)
          Padding(
            padding: cardItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 384.0),
                        child: Text(
                          "${t.forUsers}\n${t.askAdminSiteId}",
                          maxLines: 8,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: buttonGap),
                    SizedBox(
                      width: 96.0,
                      child: TextField(
                        onChanged: (value) {
                          selectedSite.value = value;
                        },
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          context.go('/$value');
                        },
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          label: Text(t.siteId),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: Theme.of(context).colorScheme.onBackground,
                      onPressed: () {
                        context.go('/${selectedSite.value}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        Card(
          child: Row(
            children: [
              const SizedBox(
                height: aboutLogoAreaSize,
                width: aboutLogoAreaSize,
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
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${t.version}: $version',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
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
