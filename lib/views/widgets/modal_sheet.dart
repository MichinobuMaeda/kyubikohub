import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../app_localizations.dart';

class ModalSheet extends HookConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget> topActions;
  final List<Widget> bottomActions;

  const ModalSheet({
    super.key,
    required this.title,
    required this.body,
    this.topActions = const [],
    this.bottomActions = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);

    return TapRegion(
      onTapOutside: (_) => controller.close(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              baseSize * 1.5, // Left
              baseSize * 0.25, // Top
              baseSize * 0.5, // Right
              baseSize * 0.25, // Bottom
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: baseSize * 0.25),
                    child: Text(
                      title,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ...topActions.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: buttonGap),
                    child: item,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () => controller.close(),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(baseSize * 0.25),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: body,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...bottomActions.map(
                (item) => Padding(
                  padding: cardItemPadding,
                  child: item,
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: TextButton(
                  child: Text(t.close),
                  onPressed: () => controller.close(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
