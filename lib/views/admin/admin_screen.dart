import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/tab_item.dart';
import '../app_localizations.dart';
import '../widgets/tabs_screen.dart';
import 'sites_page.dart';

class AdminScreen extends HookConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TabsScreen(
      items: [
        TabItem(
          icon: Icons.domain,
          label: t.sites,
          page: const SitesPage(),
        ),
      ],
    );
  }
}
