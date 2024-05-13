import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config.dart';
import '../../../models/tab_item.dart';

class TabsScreen extends HookConsumerWidget {
  final List<TabItem> items;
  const TabsScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      animationDuration: null, //Duration.zero,
      initialIndex: 0,
      length: items.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: TabBar(
          isScrollable: true,
          tabs: items
              .map(
                (item) => Tab(
                  child: Row(
                    children: [
                      Icon(item.icon),
                      const SizedBox(width: iconTextGap),
                      Text(item.label),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        body: TabBarView(
          // physics: const NeverScrollableScrollPhysics(),
          children: items.map((item) => item.page).toList(),
        ),
      ),
    );
  }
}
