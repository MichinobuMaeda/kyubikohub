import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/group.dart';
import '../../providers/users_repository.dart';
import '../widgets/modal_items_section.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
import 'groups_section.dart';

class UsersSection extends HookConsumerWidget {
  final Group? group;
  const UsersSection({super.key, this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final users = group == null
        ? ref.watch(usersRepositoryProvider)
        : ref
            .watch(usersRepositoryProvider)
            .where((user) => group!.users.contains(user.id))
            .toList();

    return ModalItemsSection(
      childCount: users.length,
      item: (index) => ModalItem(
        title: users[index].name,
        trailing: const Icon(Icons.more_horiz),
        child: CustomScrollView(
          slivers: [
            SectionHeader(
              title: t.groupMembership,
              leading: Icons.people,
            ),
            GroupsSection(user: users[index].id),
          ],
        ),
      ),
    );
  }
}
