import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../app_localizations.dart';

class BottomCard extends HookConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget> topActions;
  final List<Widget> bottomActions;

  const BottomCard({
    super.key,
    required this.title,
    required this.body,
    this.topActions = const [],
    this.bottomActions = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TapRegion(
      onTapOutside: (_) => Navigator.of(context).pop(),
      child: Card(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: cardItemPadding,
                    child: Text(
                      title,
                      maxLines: 8,
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
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            Expanded(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.background,
                child: body,
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
                    onPressed: () => Navigator.pop(context),
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
