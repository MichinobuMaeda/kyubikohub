import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../repositories/groups_repository.dart';
import '../../repositories/users_repository.dart';
import '../app_localizations.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: cardItemPadding,
                      child: Row(
                        children: [
                          Text(
                            t.groups,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(width: buttonGap),
                          Text(groups.map((group) => group.name).join(', ')),
                        ],
                      ),
                    ),
                  ],
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
