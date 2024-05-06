import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../app_localizations.dart';

class GoSite extends HookConsumerWidget {
  final String title;
  final String message;
  final double messageWidth;
  const GoSite({
    super.key,
    required this.title,
    required this.message,
    this.messageWidth = 384,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final selectedSite = useState<String?>(null);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: messageWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleLarge),
                Text(
                  message,
                  maxLines: 8,
                  style: bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
              context.go('/${value.trim()}');
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
            context.go('/${selectedSite.value?.trim()}');
          },
        ),
      ],
    );
  }
}
