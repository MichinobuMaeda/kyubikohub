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
  final bool enabled;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
    required this.enabled,
  });
}

List<NavItem> navItems(BuildContext context) {
  final t = AppLocalizations.of(context)!;

  return [
    NavItem(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home),
      label: t.home,
      path: '',
      enabled: true,
    ),
    NavItem(
      icon: const Icon(Icons.settings_outlined),
      selectedIcon: const Icon(Icons.settings),
      label: t.settings,
      path: '/settings',
      enabled: true,
    ),
    NavItem(
      icon: const Icon(Icons.info_outlined),
      selectedIcon: const Icon(Icons.info),
      label: t.information,
      path: '/about',
      enabled: true,
    ),
  ];
}

class Navigation extends HookConsumerWidget {
  final Widget child;
  const Navigation({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Row(
        children: [
          if (landscape)
            ref.watch(siteRepositoryProvider).when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  data: (site) => switch (site) {
                    Loading() => const SizedBox.shrink(),
                    Error() => const SizedBox.shrink(),
                    Success() => NavigationRail(
                        labelType: NavigationRailLabelType.all,
                        selectedIndex: 0,
                        destinations: [
                          ...navItems(context).map(
                            (item) => NavigationRailDestination(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: Text(
                                item.label,
                                overflow: TextOverflow.fade,
                              ),
                              disabled: !item.enabled,
                            ),
                          ),
                        ],
                        onDestinationSelected: (index) {
                          final items = navItems(context);
                          if (0 <= index && index < items.length) {
                            context.go('/${site.data.id}${items[index].path}');
                          }
                        },
                      ),
                  },
                ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: landscape
          ? null
          : ref.watch(siteRepositoryProvider).when(
                loading: () => null,
                error: (error, stackTrace) => null,
                data: (site) => switch (site) {
                  Loading() => null,
                  Error() => null,
                  Success() => NavigationBar(
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysShow,
                      selectedIndex: 0,
                      destinations: [
                        ...navItems(context).map(
                          (item) => NavigationDestination(
                            icon: item.icon,
                            selectedIcon: item.selectedIcon,
                            label: item.label,
                            enabled: item.enabled,
                          ),
                        ),
                      ],
                      onDestinationSelected: (index) {
                        final items = navItems(context);
                        if (0 <= index && index < items.length) {
                          context.go('/${site.data.id}${items[index].path}');
                        }
                      },
                    ),
                },
              ),
    );
  }
}
