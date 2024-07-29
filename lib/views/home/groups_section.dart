import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../models/nav_item.dart';
import '../../providers/account_repository.dart';
import '../../providers/groups_repository.dart';
import '../widgets/list_items_section.dart';
import '../../l10n/app_localizations.dart';

class GroupsSection extends HookConsumerWidget {
  final String? user;
  const GroupsSection({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final account = ref.watch(accountRepositoryProvider);
    final site = (account is Success<Account?>) ? account.data?.site ?? '' : '';
    final groups = [
      (
        title: t.allMembers,
        name: NavPath.users.name,
        pathParameters: NavPath.users.pathParameters(site: site),
      ),
      ...ref
          .watch(groupsRepositoryProvider)
          .where(
            (group) => user == null || group.users.contains(user),
          )
          .map(
            (group) => (
              title: group.name,
              name: NavPath.group.name,
              pathParameters: NavPath.group.pathParameters(
                site: site,
                param: group.id,
              ),
            ),
          ),
    ];

    return ListItemsSection(
      childCount: groups.length,
      items: (index) => LinkItemProps(
        title: groups[index].title,
        trailing: const Icon(Icons.more_horiz),
        name: groups[index].name,
        pathParameters: groups[index].pathParameters,
      ),
    );
  }
}
