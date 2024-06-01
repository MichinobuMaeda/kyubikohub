import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../providers/account_repository.dart';
import '../../providers/conf_repository.dart';
import '../../providers/firebase_utils.dart';
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
    final accountStatus = ref.watch(accountStatusProvider);
    final isEdit = useState(false);
    final desc = useState('');

    return SliverToBoxAdapter(
      child: SizedBox(
        height: baseSize * 24.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            about == null
                ? Text(t.defaultLoadingMessage)
                : Expanded(
                    child: Padding(
                      padding: cardItemPadding.copyWith(top: 0.0),
                      child: Stack(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          isEdit.value
                              ? TextField(
                                  controller: textController,
                                  onChanged: (value) {
                                    desc.value = value;
                                  },
                                  maxLines: null,
                                )
                              : Markdown(
                                  data: about,
                                  padding: const EdgeInsets.all(0.0),
                                  onTapLink: onTapLink,
                                  styleSheet: markdownStyleSheet(context),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (accountStatus.admin && isEdit.value)
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  color: Theme.of(context).colorScheme.outline,
                                  onPressed: () async {
                                    await updateDoc(
                                      confRef,
                                      {'desc': desc.value},
                                    );
                                    isEdit.value = false;
                                  },
                                ),
                              if (accountStatus.admin && isEdit.value)
                                const SizedBox(width: buttonGap),
                              if (accountStatus.admin && isEdit.value)
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  color: Theme.of(context).colorScheme.outline,
                                  onPressed: () {
                                    isEdit.value = false;
                                  },
                                ),
                              if (accountStatus.admin && !isEdit.value)
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Theme.of(context).colorScheme.outline,
                                  onPressed: () {
                                    isEdit.value = true;
                                    desc.value = about;
                                    textController.text = about;
                                  },
                                ),
                              if (accountStatus.admin && !isEdit.value)
                                const SizedBox(width: buttonGap),
                              if (!isEdit.value)
                                IconButton(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
