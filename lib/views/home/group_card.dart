import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../repositories/groups_repository.dart';
import '../../repositories/users_repository.dart';
import '../app_localizations.dart';
import 'user_card.dart';

class GroupCard extends HookConsumerWidget {
  final Group group;
  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final users = ref
        .watch(usersRepositoryProvider)
        .where((user) => group.users.contains(user.id))
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
                    group.name,
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
            child: ColoredBox(
              color: Theme.of(context).colorScheme.background,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) => ColoredBox(
                  color: index.isEven
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.shadow.withAlpha(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: baseSize),
                    child: Row(
                      children: [
                        Expanded(child: Text(users[index].name)),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () => showBottomSheet(
                            context: context,
                            builder: (context) => UserCard(
                              user: users[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: users.length,
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
