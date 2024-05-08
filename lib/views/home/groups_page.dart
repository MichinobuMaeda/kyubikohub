import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../repositories/groups_repository.dart';
import 'group_card.dart';

class GroupsPage extends HookConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsRepositoryProvider);

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => ColoredBox(
          color: index.isOdd
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.shadow.withAlpha(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: baseSize),
            child: Row(
              children: [
                Expanded(child: Text(groups[index].name)),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () => showBottomSheet(
                    context: context,
                    builder: (context) => GroupCard(
                      group: groups[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        itemCount: groups.length,
      ),
    );
  }
}
