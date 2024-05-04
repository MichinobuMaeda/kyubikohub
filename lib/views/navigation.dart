import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/nav_item.dart';
import 'widgets/update_app_message.dart';
import 'app_localizations.dart';

class Navigation extends HookConsumerWidget {
  final Widget child;
  final String? site;
  final NavPath? navPath;
  const Navigation({
    super.key,
    required this.site,
    required this.navPath,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final navItems = [
      NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: t.home,
        navPath: NavPath.home,
      ),
      NavItem(
        icon: Icons.account_circle_outlined,
        selectedIcon: Icons.account_circle,
        label: t.me,
        navPath: NavPath.me,
      ),
      NavItem(
        icon: Icons.info_outlined,
        selectedIcon: Icons.info,
        label: t.about,
        navPath: NavPath.about,
      ),
    ];

    final selectedIndex = () {
      for (int index = 0; index < navItems.length; ++index) {
        if (navPath == navItems[index].navPath) {
          return index;
        }
      }
      return navItems.length - 1;
    }();

    return Scaffold(
      body: Row(
        children: [
          if (site != null && landscape)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              selectedIndex: selectedIndex,
              destinations: [
                ...navItems.map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(
                      item.label,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
              onDestinationSelected: (index) {
                context.goNamed(
                  navItems[index].navPath.name,
                  pathParameters: {'site': site!},
                );
              },
            ),
          Expanded(
            child: Column(
              children: [
                const UpdateAppMessage(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: (site == null || landscape)
          ? null
          : NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: selectedIndex,
              destinations: [
                ...navItems.map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
                ),
              ],
              onDestinationSelected: (index) {
                context.goNamed(
                  navItems[index].navPath.name,
                  pathParameters: {'site': site!},
                );
              },
            ),
    );
  }
}
