import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/tab_item.dart';
import '../app_localizations.dart';
import '../widgets/tabs_screen.dart';
import '../about/guidance_page.dart';
import '../about/about_app_page.dart';
import '../about/license_list_page.dart';
import 'login_page.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return TabsScreen(
      items: [
        TabItem(
          icon: Icons.login,
          label: t.login,
          page: const LoginPage(),
        ),
        TabItem(
          icon: Icons.support_agent,
          label: t.guidance,
          page: const GuidancePage(),
        ),
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
