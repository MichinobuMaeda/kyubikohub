import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repositories/site_repository.dart';
import 'navigation.dart';
import 'auth/guard_login.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import 'about/about_screen.dart';

Future<void> onSiteChange(WidgetRef ref, GoRouterState state) async {
  final site = state.pathParameters['site'];
  if (site != null && site.isNotEmpty) {
    ref.read(siteRepositoryProvider.notifier).onSiteChange(site);
  }
}

GoRouter router(WidgetRef ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Navigation(state: state, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const AboutScreen();
            },
          ),
          GoRoute(
            path: '/:site',
            builder: (context, state) {
              onSiteChange(ref, state);
              return const GuardLogin(child: HomeScreen());
            },
          ),
          GoRoute(
            path: '/:site/settings',
            builder: (context, state) {
              onSiteChange(ref, state);
              return const GuardLogin(child: SettingsScreen());
            },
          ),
          GoRoute(
            path: '/:site/about',
            builder: (context, state) {
              onSiteChange(ref, state);
              return const AboutScreen();
            },
          ),
        ],
      )
    ],
    errorBuilder: (context, state) {
      return const AboutScreen();
    },
  );
}
