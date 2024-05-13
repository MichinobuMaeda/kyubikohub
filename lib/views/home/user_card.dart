import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/user.dart';
import '../../providers/groups_repository.dart';
import '../widgets/bottom_card.dart';
import 'group_card.dart';

class UserCard extends HookConsumerWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref
        .watch(groupsRepositoryProvider)
        .where((group) => group.users.contains(user.id))
        .toList();

    return BottomCard(
      title: user.name,
      body: SingleChildScrollView(
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
    );
  }
}
