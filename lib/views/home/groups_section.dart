import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/groups_repository.dart';
import '../widgets/modal_item.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
import 'users_section.dart';

class GroupsSection extends HookConsumerWidget {
  final String? user;
  const GroupsSection({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final items = [
      (title: t.allMembers, data: null),
      ...(user == null
              ? ref.watch(groupsRepositoryProvider)
              : ref
                  .watch(groupsRepositoryProvider)
                  .where((group) => group.users.contains(user)))
          .map((group) => (title: group.name, data: group)),
    ];

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: items.length,
        (BuildContext context, int index) => ModalItem(
          index: index,
          title: items[index].title,
          trailing: const Icon(Icons.more_horiz),
          child: CustomScrollView(
            slivers: [
              SectionHeader(
                title: t.users,
                leading: Icons.people,
              ),
              UsersSection(group: items[index].data),
            ],
          ),
        ),
      ),
    );
  }
}
