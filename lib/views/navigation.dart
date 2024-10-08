import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config.dart';
import '../models/nav_item.dart';
import '../providers/account_repository.dart';
import 'about/about_screen.dart';
import 'widgets/update_app_message.dart';
import '../../l10n/app_localizations.dart';

class Navigation extends HookConsumerWidget {
  final Widget child;
  final String? site;
  final GoRoute? route;

  const Navigation({
    super.key,
    required this.site,
    required this.route,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final accountStatus = ref.watch(accountStatusProvider);
    final isMember = accountStatus.account != null;
    final showNav = site != null && isMember;
    final navItem = getNavItem(route);

    final navItems = [
      NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: t.home,
        navPath: NavPath.home,
      ),
      NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: t.me,
        navPath: NavPath.preferences,
      ),
      NavItem(
        icon: Icons.dns_outlined,
        selectedIcon: Icons.dns,
        label: t.administration,
        navPath: NavPath.admin,
      ),
      NavItem(
        icon: Icons.info_outlined,
        selectedIcon: Icons.info,
        label: t.about,
        navPath: NavPath.about,
      ),
    ]
        .where((item) => item.navPath != NavPath.admin || accountStatus.admin)
        .toList();

    final selectedIndex = () {
      for (int index = 0; index < navItems.length; ++index) {
        if (navItem == navItems[index].navPath) {
          return index;
        }
      }
      return navItems.length - 1;
    }();

    final leftPadding =
        max(MediaQuery.of(context).size.width - contentWidth, 0) / 2;

    return SafeArea(
      child: Scaffold(
        body: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: leftPadding),
            child: Row(
              children: [
                if (showNav && landscape)
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
                    onDestinationSelected: (index) =>
                        onDestinationSelected(context, navItems, index),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      const UpdateAppMessage(),
                      Expanded(
                        child: ColoredBox(
                          color: Theme.of(context).colorScheme.surface,
                          child: isMember ? child : const AboutScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: (!showNav || landscape)
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
                onDestinationSelected: (index) =>
                    onDestinationSelected(context, navItems, index),
              ),
      ),
    );
  }

  void onDestinationSelected(
    BuildContext context,
    List<NavItem> navItems,
    int index,
  ) {
    context.pushNamed(
      navItems[index].navPath.name,
      pathParameters: navItems[index].navPath.pathParameters(site: site ?? ''),
    );
  }
}

NavPath? getNavPath(GoRoute? route) {
  for (final navPath in NavPath.values) {
    if (navPath.name == route?.name) {
      return navPath;
    }
  }
  return null;
}

NavPath getNavItem(GoRoute? route) => switch (getNavPath(route)) {
      null ||
      NavPath.home ||
      NavPath.group ||
      NavPath.users ||
      NavPath.user ||
      NavPath.notices =>
        NavPath.home,
      NavPath.preferences => NavPath.preferences,
      NavPath.about => NavPath.about,
      NavPath.admin || NavPath.logs => NavPath.admin,
    };
