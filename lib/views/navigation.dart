import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/data_state.dart';
import '../repositories/site_repository.dart';
import 'app_localizations.dart';

class NavItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final String path;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}

class Navigation extends HookConsumerWidget {
  final Widget child;
  final GoRouterState state;
  const Navigation({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final site = ref.watch(siteRepositoryProvider);
    final String? siteId = switch (site) {
      Loading() => null,
      Error() => null,
      Success() => site.data.id,
    };

    final navItems = [
      NavItem(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: t.home,
        path: '',
      ),
      NavItem(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: t.settings,
        path: '/settings',
      ),
      NavItem(
        icon: const Icon(Icons.info_outlined),
        selectedIcon: const Icon(Icons.info),
        label: t.information,
        path: '/about',
      ),
    ];

    final selectedIndex = pathToIndex(siteId, state.uri.path, navItems);

    return Scaffold(
      body: Row(
        children: [
          if (siteId != null && landscape)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              selectedIndex: selectedIndex,
              destinations: [
                ...navItems.map(
                  (item) => NavigationRailDestination(
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    label: Text(
                      item.label,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
              onDestinationSelected: (index) {
                context.go('/$siteId${navItems[index].path}');
              },
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: (siteId == null || landscape)
          ? null
          : NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: selectedIndex ?? navItems.length - 1,
              destinations: [
                ...navItems.map(
                  (item) => NavigationDestination(
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    label: item.label,
                  ),
                ),
              ],
              onDestinationSelected: (index) {
                context.go('/$siteId${navItems[index].path}');
              },
            ),
    );
  }

  int? pathToIndex(String? siteId, String path, List<NavItem> navItems) {
    if (siteId != null) {
      for (int index = 0; index < navItems.length; ++index) {
        if (path == "/$siteId${navItems[index].path}") {
          return index;
        }
      }
    }

    return null;
  }
}
