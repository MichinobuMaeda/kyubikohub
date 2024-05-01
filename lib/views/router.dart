import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repositories/site_repository.dart';
import 'navigation.dart';
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
          return Navigation(child: child);
          // return Navigation(child: const About(appTop: true));
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const AboutScreen(appTop: true);
            },
          ),
          GoRoute(
            path: '/:site',
            builder: (context, state) {
              onSiteChange(ref, state);
              return Text('path: /${state.pathParameters['site']}');
            },
          ),
          GoRoute(
            path: '/:site/settings',
            builder: (context, state) {
              onSiteChange(ref, state);
              return Text('path: /${state.pathParameters['site']}/settings');
            },
          ),
          GoRoute(
            path: '/:site/about',
            builder: (context, state) {
              onSiteChange(ref, state);
              return const AboutScreen(appTop: false);
            },
          ),
        ],
      )
    ],
    errorPageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const Navigation(child: Text('Routing error')),
    ),
  );
}
