import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fpdart/fpdart.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../repositories/subscribe_repository.dart';
import '../../providers/conf_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/list_items_section.dart';
import '../widgets/text_input.dart';
import '../validators.dart';

class SubscribeSection extends HookConsumerWidget {
  const SubscribeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return ListItemsSection(
      childCount: 1,
      items: (index) => ModalSheetItemProps(
        title: t.subscribe,
        leading: const Icon(Icons.outgoing_mail),
        trailing: const Icon(Icons.more_horiz),
        child: const SubscribeForm(),
      ),
    );
  }
}

@visibleForTesting
class SubscribeForm extends HookConsumerWidget {
  const SubscribeForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final forSubscriber = ref.watch(
      confRepositoryProvider.select(
        (conf) => (conf is Success<Conf>) ? conf.data.forSubscriber : null,
      ),
    );
    final message = useState<Either<String, void>>(Either.of(null));
    final task = SubscribeRepository(t: t, useState: useState);

    Future<void> save() async {
      message.value = await task.run();
      if (message.value.isRight()) {
        ref.read(modalSheetControllerProviderProvider.notifier).close();
      }
    }

    return FocusTraversalGroup(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: cardItemPadding,
              child: forSubscriber == null
                  ? Text(t.defaultLoadingMessage)
                  : MarkdownBody(
                      data: forSubscriber,
                      onTapLink: onTapLink,
                      styleSheet: markdownStyleSheet(context),
                    ),
            ),
            ...task.params.map(
              (param) => Padding(
                padding: cardItemPadding,
                child: TextInput(param: param),
              ),
            ),
            const SizedBox(height: buttonGap),
            message.value.match(
              (l) => Padding(
                padding: cardItemPadding,
                child: Text(
                  l,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              (r) => const SizedBox.shrink(),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: cardItemPadding,
                  child: FilledButton(
                    onPressed: validateAll(task.params) ? () => save() : null,
                    child: Row(
                      children: [
                        const Icon(Icons.send),
                        const SizedBox(width: buttonGap),
                        Text(t.send),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
