import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../repositories/site_repository.dart';
import '../../providers/data_state.dart';
import '../app_localizations.dart';
import 'guidance_page.dart';
import 'about_app_page.dart';
import 'license_list_page.dart';

class TabItem {
  final IconData icon;
  final String label;
  final Widget page;

  const TabItem(
    this.icon,
    this.label,
    this.page,
  );
}

class AboutScreen extends HookConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final site = ref.watch(siteRepositoryProvider);
    final bool isSite = switch (site) {
      Loading() || Error() => false,
      Success() => true,
    };
    final tabItems = [
      if (isSite)
        TabItem(
          Icons.support_agent,
          t.guidance,
          const GuidancePage(),
        ),
      TabItem(
        Icons.code,
        t.aboutTheApp,
        const AboutAppPage(),
      ),
      TabItem(
        Icons.notes,
        t.licenses,
        const LicenseListPage(),
      ),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabItems.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: TabBar(
          isScrollable: true,
          tabs: tabItems
              .map((item) => Tab(
                    child: Row(children: [
                      Icon(item.icon),
                      const SizedBox(width: tabIconMargin),
                      Text(item.label),
                    ]),
                  ))
              .toList(),
        ),
        body: TabBarView(
          // physics: const NeverScrollableScrollPhysics(),
          children: tabItems.map((item) => item.page).toList(),
        ),
      ),
    );
  }
}
