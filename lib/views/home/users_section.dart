import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../models/group.dart';
import '../../models/nav_item.dart';
import '../../providers/account_repository.dart';
import '../../providers/users_repository.dart';
import '../widgets/link_items_section.dart';

class UsersSection extends HookConsumerWidget {
  final Group? group;
  const UsersSection({super.key, this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountRepositoryProvider);
    final site = (account is Success<Account?>) ? account.data?.site ?? '' : '';
    final users = ref
        .watch(usersRepositoryProvider)
        .where(
          (user) => group == null || group!.users.contains(user.id),
        )
        .map(
          (user) => (
            title: user.name,
            name: NavPath.users.param!,
            pathParameters: {
              'site': site,
              NavPath.users.param!: user.id,
            },
          ),
        )
        .toList();

    return LinkItemsSection(
      childCount: users.length,
      item: (index) => LinkItem(
        title: users[index].title,
        trailing: const Icon(Icons.more_horiz),
        name: users[index].name,
        pathParameters: users[index].pathParameters,
      ),
    );
  }
}
