import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config.dart';
import '../models/nav_item.dart';
import '../providers/site_repository.dart';
import 'home/home_screen.dart';
import 'home/user_screen.dart';
import 'home/group_screen.dart';
import 'about/about_screen.dart';
import 'admin/admin_screen.dart';
import 'admin/logs_screen.dart';
import 'preferences/preferences_screen.dart';
import 'navigation.dart';

GoRouter router(WidgetRef ref) => GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return Navigation(
              site: state.uri.pathSegments.isNotEmpty
                  ? state.uri.pathSegments[0]
                  : null,
              path: state.uri.pathSegments.length >= 2
                  ? state.uri.pathSegments[1]
                  : null,
              child: child,
            );
          },
          routes: [
            GoRoute(
              name: 'root',
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AboutScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.home.name,
              path: joinPath('/:site', NavPath.home.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.group.name,
              path: joinPath(
                joinPath('/:site', NavPath.group.path),
                ':${NavPath.group.param}',
              ),
              pageBuilder: (context, state) => NoTransitionPage(
                child: GroupScreen(
                  group: state.pathParameters[NavPath.group.param],
                ),
              ),
            ),
            GoRoute(
              name: NavPath.users.name,
              path: joinPath('/:site', NavPath.users.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: GroupScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.user.name,
              path: joinPath(
                joinPath('/:site', NavPath.user.path),
                ':${NavPath.user.param}',
              ),
              pageBuilder: (context, state) => NoTransitionPage(
                child: UserScreen(
                  user: state.pathParameters[NavPath.user.param],
                ),
              ),
            ),
            GoRoute(
              name: NavPath.logs.name,
              path: joinPath('/:site', NavPath.logs.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LogsScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.preferences.name,
              path: joinPath('/:site', NavPath.preferences.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MeScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.about.name,
              path: joinPath('/:site', NavPath.about.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AboutScreen(),
              ),
            ),
            GoRoute(
              name: NavPath.admin.name,
              path: joinPath('/:site', NavPath.admin.path),
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminScreen(),
              ),
            ),
          ],
        ),
      ],
      redirect: (context, state) => guardPath(state, ref),
    );

String joinPath(String basePath, String subPath) =>
    subPath.isEmpty ? basePath : [basePath, subPath].join('/');

@visibleForTesting
Future<String?> guardPath(GoRouterState state, WidgetRef ref) async {
  final resAdmin = guardAdmin(state);
  if (resAdmin != null) {
    return resAdmin;
  }
  return guardSite(state, ref);
}

@visibleForTesting
String? guardAdmin(GoRouterState state) {
  final paramSite = state.pathParameters[paramSiteName];

  if (paramSite != null && paramSite != adminsSiteId) {
    final locationAdmin = state.namedLocation(
      NavPath.admin.name,
      pathParameters: {
        "site": paramSite,
      },
    );
    if (state.matchedLocation.startsWith(locationAdmin)) {
      final locationHome = state.namedLocation(
        NavPath.home.name,
        pathParameters: {
          "site": paramSite,
        },
      );
      return locationHome;
    }
  }
  return null;
}

@visibleForTesting
Future<String?> guardSite(GoRouterState state, WidgetRef ref) async {
  final paramSite = state.pathParameters['site'];
  final checked = await ref
      .read(siteParamRepositoryProvider.notifier)
      .onSiteParamChanged(paramSite);

  if (paramSite == checked) {
    return null;
  } else if (checked == null) {
    debugPrint('INFO    : redirect to /');
    return '/';
  } else {
    debugPrint('INFO    : redirect to /$checked');
    return '/$checked';
  }
}
