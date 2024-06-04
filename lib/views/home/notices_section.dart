import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../app_localizations.dart';

class NoticesSection extends HookConsumerWidget {
  const NoticesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final notices = [
      'Test 1',
      'Test 2',
      'Test 3',
      'Test 4',
      'Test 5',
      'Test 6',
    ];

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: min(notices.length, homeNoticesCount),
        (BuildContext context, int index) => ColoredBox(
          color: listItemsStripeColor(context, index),
          child: ListTile(
            title: index == (homeNoticesCount - 1) && index < notices.length
                ? Text(t.showMore)
                : Text(
                    notices[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            leading: index == (homeNoticesCount - 1) && index < notices.length
                ? const Icon(Icons.more_vert)
                : null,
            trailing: index == (homeNoticesCount - 1) && index < notices.length
                ? null
                : const Icon(Icons.more_horiz),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
