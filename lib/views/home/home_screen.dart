import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/tab_item.dart';
import '../app_localizations.dart';
import '../widgets/tabs_screen.dart';
import 'notices_page.dart';
import 'groups_page.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TabsScreen(
      items: [
        TabItem(
          icon: Icons.notifications,
          label: t.notices,
          page: const NoticesPage(),
        ),
        TabItem(
          icon: Icons.people,
          label: t.groups,
          page: const GroupsPage(),
        ),
      ],
    );
  }
}
