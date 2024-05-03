import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/tab_item.dart';
import '../app_localizations.dart';
import '../widgets/tabs_screen.dart';
import 'preferences_page.dart';
import 'my_account_page.dart';

class MeScreen extends HookConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TabsScreen(
      items: [
        TabItem(
          icon: Icons.settings,
          label: t.preferences,
          page: const PreferencesPage(),
        ),
        TabItem(
          icon: Icons.account_circle,
          label: t.myAccount,
          page: const MyAccountPage(),
        ),
      ],
    );
  }
}
