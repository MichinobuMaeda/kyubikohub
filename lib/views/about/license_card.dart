import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../app_localizations.dart';

class LicenseCard extends HookConsumerWidget {
  final String title;
  final String body;
  const LicenseCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Card(
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
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () => Clipboard.setData(
                    ClipboardData(text: '$title\n\n$body'),
                  ),
              ),
              const SizedBox(width: buttonGap),
              IconButton(
                icon: const Icon(Icons.close),
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: cardItemPadding,
                  child: Text(
                    body,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: cardItemPadding,
                child: TextButton(
                  child: Text(t.copy),
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: '$title\n\n$body'),
                  ),
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
    );
  }
}
