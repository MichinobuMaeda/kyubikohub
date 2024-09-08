import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../models/nav_item.dart';
import '../../providers/account_repository.dart';
import '../../providers/groups_repository.dart';
import '../widgets/list_item.dart';
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
      (context, ref, index, height) => ListItem.linkAction(
        index: index,
        height: height,
        title: groups[index].title,
        pathName: groups[index].name,
        pathParameters: groups[index].pathParameters,
      ),
    );
  }
}
