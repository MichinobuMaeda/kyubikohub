import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../providers/conf_repository.dart';
import '../../l10n/app_localizations.dart';

class AboutAppSection extends HookConsumerWidget {
  const AboutAppSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final about = ref.watch(
      confRepositoryProvider.select(
        (conf) => (conf is Success<Conf>) ? conf.data.desc : null,
      ),
    );
    const cardHeight = baseSize * 6.0;

    return SliverList.list(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          height: cardHeight,
          child: Stack(
            children: [
              Card(
                child: Row(
                  children: [
                    const SizedBox(
                      height: cardHeight,
                      width: cardHeight,
                      child: Center(
                        child: Padding(
                          padding: imagePadding,
                          child: Image(image: assetImageLogo),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: buttonGap),
                        Text(
                          appTitle,
                          style: Theme.of(context).textTheme.titleMedium,
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
# $appTitle

${t.version}: $version

$about
'''),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: cardItemPaddingHalf.copyWith(top: 0.0),
          child: ColoredBox(
            color: sectionColor(context),
            child: Padding(
              padding: cardItemPaddingHalf,
              child: about == null
                  ? Text(t.defaultLoadingMessage)
                  : MarkdownBody(
                      data: about,
                      onTapLink: onTapLink,
                      styleSheet: markdownStyleSheet(context),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
