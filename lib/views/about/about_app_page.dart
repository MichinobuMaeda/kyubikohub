import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../providers/about_app_provider.dart';
import '../../providers/data_state.dart';
import '../app_localizations.dart';

class AboutAppPage extends HookConsumerWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final about = ref.watch(aboutAppProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              height: aboutLogoAreaSize,
              width: aboutLogoAreaSize,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(aboutLogoAreaPadding),
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
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  ),
                ),
                Text(
                  '${t.version}: $version',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Markdown(
            data: switch (about) {
              Loading() => t.defaultLoadingMessage,
              Error() => about.message,
              Success() => about.data,
            },
            onTapLink: onTapLink,
            padding: const EdgeInsets.all(4),
            styleSheet: markdownStyleSheet(context),
          ),
        ),
      ],
    );
  }
}
