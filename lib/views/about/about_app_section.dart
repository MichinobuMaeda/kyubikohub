import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../providers/conf_repository.dart';
import '../app_localizations.dart';

class AboutAppSection extends HookConsumerWidget {
  final TextEditingController textController = TextEditingController();

  AboutAppSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final about = ref.watch(
      confRepositoryProvider.select(
        (conf) => (conf is Success<Conf>) ? conf.data.desc : null,
      ),
    );

    return SliverToBoxAdapter(
      child: SizedBox(
        height: baseSize * 24.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
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
            about == null
                ? Padding(
                    padding: cardItemPadding,
                    child: Text(t.defaultLoadingMessage),
                  )
                : Expanded(
                    child: Padding(
                      padding: cardItemPadding,
                      child: Markdown(
                        data: about,
                        padding: const EdgeInsets.all(0.0),
                        onTapLink: onTapLink,
                        styleSheet: markdownStyleSheet(context),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
