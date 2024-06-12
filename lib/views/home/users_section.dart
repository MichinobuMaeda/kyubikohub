import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../models/group.dart';
import '../../models/nav_item.dart';
import '../../providers/account_repository.dart';
import '../../providers/users_repository.dart';
import '../widgets/list_items_section.dart';

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
            name: NavPath.user.name,
            pathParameters: NavPath.user.pathParameters(
              site: site,
              param: user.id,
            ),
          ),
        )
        .toList();

    return ListItemsSection(
      childCount: users.length,
      items: (index) => LinkItemProps(
        title: users[index].title,
        trailing: const Icon(Icons.more_horiz),
        name: users[index].name,
        pathParameters: users[index].pathParameters,
      ),
    );
  }
}
