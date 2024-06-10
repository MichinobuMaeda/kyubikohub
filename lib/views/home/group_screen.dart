import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/groups_repository.dart';
import '../widgets/go_back_header.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
import 'users_section.dart';

class GroupScreen extends HookConsumerWidget {
  final String? group;
  const GroupScreen({super.key, this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final groups = ref
        .watch(groupsRepositoryProvider)
        .where((item) => item.id == group)
        .toList();

    return CustomScrollView(
      slivers: [
        const GoBackHeader(),
        SectionHeader(
          title: Text(groups.isEmpty ? t.allMembers : groups[0].name),
          leading: const Icon(Icons.people),
        ),
        UsersSection(group: groups.isEmpty ? null : groups[0]),
      ],
    );
  }
}
