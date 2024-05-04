import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/nav_item.dart';
import '../repositories/site_repository.dart';
import '../models/data_state.dart';
import 'home/home_screen.dart';
import 'about/about_app_screen.dart';
import 'about/about_site_screen.dart';
import 'me/me_screen.dart';
import 'navigation.dart';

GoRouter router(WidgetRef ref) => GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            final (site, navPath) = getNavPath(state);
            return Navigation(
              site: site,
              navPath: navPath,
              child: child,
            );
          },
          routes: [
            GoRoute(
              name: 'root',
              path: '/',
              builder: (context, state) => const AboutAppScreen(),
            ),
            GoRoute(
              name: NavPath.home.name,
              path: joinPath('/:site', NavPath.home.path),
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              name: NavPath.me.name,
              path: joinPath('/:site', NavPath.me.path),
              builder: (context, state) => const MeScreen(),
            ),
            GoRoute(
              name: NavPath.about.name,
              path: joinPath('/:site', NavPath.about.path),
              builder: (context, state) => const AboutSiteScreen(),
            ),
          ],
        ),
      ],
      redirect: (context, state) async {
        return await guardSite(state, ref);
      },
    );

String joinPath(String basePath, String subPath) =>
    subPath.isEmpty ? basePath : [basePath, subPath].join('/');

(String?, NavPath?) getNavPath(GoRouterState state) {
  final site = state.pathParameters['site'];
  if (site == null) {
    return (null, null);
  }
  final path =
      state.uri.pathSegments.length < 2 ? '' : state.uri.pathSegments[1];
  return (site, NavPath.values.firstWhere((navItem) => navItem.path == path));
}

Future<String?> guardSite(GoRouterState state, WidgetRef ref) async {
  final paramSite = state.pathParameters['site'];
  await ref.read(siteRepositoryProvider.notifier).onSiteChange(paramSite);
  final siteStatus = ref.watch(siteRepositoryProvider);
  final site = switch (siteStatus) {
    Loading() || Error() => null,
    Success() => siteStatus,
  };
  if (paramSite == site?.data.id) {
    return null;
  } else if (site == null) {
    debugPrint('Error: redirect to /');
    return '/';
  } else {
    debugPrint('Error: redirect to /${site.data.id}');
    return '/${site.data.id}';
  }
}
