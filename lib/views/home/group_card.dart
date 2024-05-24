import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/group.dart';
import '../../providers/users_repository.dart';
import '../widgets/bottom_card.dart';
import '../app_localizations.dart';
import 'user_card.dart';

class GroupCard extends HookConsumerWidget {
  final Group? group;
  const GroupCard({super.key, this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final users = group == null
        ? ref.watch(usersRepositoryProvider)
        : ref
            .watch(usersRepositoryProvider)
            .where((user) => group!.users.contains(user.id))
            .toList();

    return BottomCard(
      title: group == null ? t.allMembers : group!.name,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => ColoredBox(
          color: index.isEven
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surfaceContainer,
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
    );
  }
}
