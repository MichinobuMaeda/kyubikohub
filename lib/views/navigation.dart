import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/nav_item.dart';
import '../providers/data_state.dart';
import '../repositories/site_repository.dart';
import 'widgets/update_app_message.dart';
import 'app_localizations.dart';

const pathHome = '';
const pathMe = '/me';
const pathAbout = '/about';

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
      Loading() || Error() => null,
      Success() => site.data.id,
    };

    final navItems = [
      NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: t.home,
        path: pathHome,
      ),
      NavItem(
        icon: Icons.account_circle_outlined,
        selectedIcon: Icons.account_circle,
        label: t.me,
        path: pathMe,
      ),
      NavItem(
        icon: Icons.info_outlined,
        selectedIcon: Icons.info,
        label: t.about,
        path: pathAbout,
      ),
    ];

    String itemPath(int index) => '/$siteId${navItems[index].path}';

    final selectedIndex = () {
      if (siteId != null && siteId.isNotEmpty) {
        for (int index = 0; index < navItems.length; ++index) {
          if (state.uri.path == itemPath(index)) {
            return index;
          }
        }
      }
      return navItems.length - 1;
    }();

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
                context.go(itemPath(index));
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
      bottomNavigationBar: (siteId == null || landscape)
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
                context.go(itemPath(index));
              },
            ),
    );
  }
}
