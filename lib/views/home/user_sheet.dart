import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/user.dart';
import '../../providers/groups_repository.dart';
import '../widgets/modal_sheet.dart';
import 'group_sheet.dart';

class UserSheet extends HookConsumerWidget {
  final User user;
  const UserSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref
        .watch(groupsRepositoryProvider)
        .where((group) => group.users.contains(user.id))
        .toList();

    return ModalSheet(
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
                        builder: (context) => GroupSheet(group: group),
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
