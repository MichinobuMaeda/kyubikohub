import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/users_repository.dart';
import '../widgets/go_back_header.dart';
import '../widgets/section_header.dart';
import 'groups_section.dart';

class UserScreen extends HookConsumerWidget {
  final String? user;
  const UserScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref
        .watch(usersRepositoryProvider)
        .where((item) => item.id == user)
        .toList();

    return CustomScrollView(
      slivers: [
        const GoBackHeader(),
        SectionHeader(
          title: Text(users.isEmpty ? 'Unknown' : users[0].name),
          leading: const Icon(Icons.person),
        ),
        GroupsSection(user: user),
      ],
    );
  }
}
