import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/user.dart';
import '../../providers/groups_repository.dart';
import '../app_localizations.dart';
import 'group_card.dart';

class UserCard extends HookConsumerWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groups = ref
        .watch(groupsRepositoryProvider)
        .where((group) => group.users.contains(user.id))
        .toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: cardItemPadding,
                  child: Text(
                    user.name,
                    maxLines: 8,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: cardItemPadding,
                  child: Row(
                    children: groups
                        .map(
                          (group) => Padding(
                            padding: const EdgeInsets.only(right: buttonGap),
                            child: OutlinedButton(
                              onPressed: () => showBottomSheet(
                                context: context,
                                builder: (context) => GroupCard(group: group),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.people),
                                  const SizedBox(width: buttonGap),
                                  Text(group.name),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: cardItemPadding,
                child: TextButton(
                  child: Text(t.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
