import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../widgets/modal_sheet.dart';
import '../app_localizations.dart';

class LicenseSheet extends HookConsumerWidget {
  final String title;
  final String body;
  const LicenseSheet({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return ModalSheet(
      title: title,
      body: SingleChildScrollView(
        child: Padding(
          padding: cardItemPadding,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              body,
              maxLines: 1000,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      topActions: [
        IconButton(
          icon: const Icon(Icons.copy),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => Clipboard.setData(
            ClipboardData(text: '$title\n\n$body'),
          ),
        ),
      ],
      bottomActions: [
        TextButton(
          child: Text(t.copy),
          onPressed: () => Clipboard.setData(
            ClipboardData(text: '$title\n\n$body'),
          ),
        ),
      ],
    );
  }
}
