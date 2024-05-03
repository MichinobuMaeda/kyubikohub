import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repositories/site_repository.dart';
import 'home/home_screen.dart';
import 'about/about_site_screen.dart';
import 'me/me_screen.dart';
import 'navigation.dart';
import 'guard_site.dart';

GoRouter router(WidgetRef ref) {
  final siteRepository = ref.read(siteRepositoryProvider.notifier);

  Future<void> onSiteChange(GoRouterState state) =>
      siteRepository.onSiteChange(state.pathParameters['site']);

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
              return const GuardSite(child: AboutSiteScreen());
            },
          ),
          GoRoute(
            path: '/:site$pathHome',
            builder: (context, state) {
              onSiteChange(state);
              return const GuardSite(child: HomeScreen());
            },
          ),
          GoRoute(
            path: '/:site$pathMe',
            builder: (context, state) {
              onSiteChange(state);
              return const GuardSite(child: MeScreen());
            },
          ),
          GoRoute(
            path: '/:site$pathAbout',
            builder: (context, state) {
              onSiteChange(state);
              return const GuardSite(child: AboutSiteScreen());
            },
          ),
        ],
      )
    ],
    errorBuilder: (context, state) {
      return const GuardSite(child: AboutSiteScreen());
    },
  );
}
