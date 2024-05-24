import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/groups_repository.dart';
import '../app_localizations.dart';
import 'group_card.dart';

class GroupsPage extends HookConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groups = ref.watch(groupsRepositoryProvider);

    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: baseSize * 64),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => ColoredBox(
            color: index.isOdd
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: baseSize),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      index == 0 ? t.allMembers : groups[index - 1].name,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => showBottomSheet(
                      context: context,
                      builder: (context) => GroupCard(
                        group: index == 0 ? null : groups[index - 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          itemCount: groups.length + 1,
        ),
      ),
    );
  }
}
