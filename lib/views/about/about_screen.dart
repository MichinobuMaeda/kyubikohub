import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
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
  final bool appTop;
  const AboutScreen({super.key, required this.appTop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final tabItems = [
      if (!appTop)
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
        appBar: TabBar(
          isScrollable: true,
          tabs: tabItems
              .map((item) => Tab(
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: tabIconMargin),
                        child: Icon(item.icon),
                      ),
                      Text(item.label),
                    ]),
                  ))
              .toList(),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: tabItems.map((item) => item.page).toList(),
        ),
      ),
    );
  }
}
