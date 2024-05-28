import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/groups_repository.dart';
import '../app_localizations.dart';
import 'group_sheet.dart';

class GroupsSection extends HookConsumerWidget {
  const GroupsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groups = ref.watch(groupsRepositoryProvider);

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: groups.length + 1,
        (BuildContext context, int index) => ColoredBox(
          color: listItemsStripeColor(context, index),
          child: ListTile(
            title: Text(
              index == 0 ? t.allMembers : groups[index - 1].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.more_horiz),
            onTap: () => showBottomSheet(
              context: context,
              builder: (context) => GroupSheet(
                group: index == 0 ? null : groups[index - 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
