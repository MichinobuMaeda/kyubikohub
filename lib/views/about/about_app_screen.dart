import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/tab_item.dart';
import '../app_localizations.dart';
import '../widgets/tabs_screen.dart';
import 'about_app_page.dart';
import 'license_list_page.dart';

class AboutAppScreen extends HookConsumerWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TabsScreen(
      items: [
        TabItem(
          icon: Icons.code,
          label: t.aboutTheApp,
          page: const AboutAppPage(),
        ),
        TabItem(
          icon: Icons.notes,
          label: t.licenses,
          page: const LicenseListPage(),
        ),
      ],
    );
  }
}
