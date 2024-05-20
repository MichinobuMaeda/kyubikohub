import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../widgets/bottom_card.dart';
import '../app_localizations.dart';

class LicenseCard extends HookConsumerWidget {
  final String title;
  final String body;
  const LicenseCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return BottomCard(
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

    // Card(
    //   child: Column(
    //     children: [
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Expanded(
    //             child: Padding(
    //               padding: cardItemPadding,
    //               child: Text(
    //                 title,
    //                 maxLines: 8,
    //                 style: Theme.of(context).textTheme.titleSmall,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //           ),
    //           IconButton(
    //             icon: const Icon(Icons.copy),
    //             color: Theme.of(context).colorScheme.onBackground,
    //             onPressed: () => Clipboard.setData(
    //               ClipboardData(text: '$title\n\n$body'),
    //             ),
    //           ),
    //           const SizedBox(width: buttonGap),
    //           IconButton(
    //             icon: const Icon(Icons.close),
    //             color: Theme.of(context).colorScheme.onBackground,
    //             onPressed: () => Navigator.pop(context),
    //           )
    //         ],
    //       ),
    //       Expanded(
    //         child: SingleChildScrollView(
    //           child: ColoredBox(
    //             color: Theme.of(context).colorScheme.background,
    //             child: Padding(
    //               padding: cardItemPadding,
    //               child: Text(
    //                 body,
    //                 maxLines: 1000,
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 8.0),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Padding(
    //             padding: cardItemPadding,
    //             child: TextButton(
    //               child: Text(t.copy),
    //               onPressed: () => Clipboard.setData(
    //                 ClipboardData(text: '$title\n\n$body'),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: cardItemPadding,
    //             child: TextButton(
    //               child: Text(t.close),
    //               onPressed: () => Navigator.pop(context),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
