import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_localizations.dart';
import '../widgets/section_header.dart';
import 'notices_section.dart';
import 'groups_section.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SectionHeader(
          title: t.notices,
          leading: Icons.notifications,
        ),
        const NoticesSection(),
        SectionHeader(
          title: t.groups,
          leading: Icons.people,
        ),
        const GroupsSection(),
      ],
    );
  }
}
