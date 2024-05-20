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
        appBar: AppBar(
          title: const SizedBox.shrink(),
          toolbarHeight: 0,
          bottom: TabBar(
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
        ),
        body: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: TabBarView(
            children: items.map((item) => item.page).toList(),
          ),
        ),
      ),
    );
  }
}
