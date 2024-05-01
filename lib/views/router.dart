import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/site_repository.dart';
import '../providers/data_state.dart';
import 'about_app/screen_about_app.dart';
import 'home/screen_home.dart';
import 'about_site/screen_about_site.dart';

Future<void> onSiteChange(WidgetRef ref, GoRouterState state) async {
  final site = state.pathParameters['site'];
  if (site != null && site.isNotEmpty) {
    ref.read(siteRepositoryProvider.notifier).onSiteChange(site);
  }
}

GoRouter router(WidgetRef ref) {
  return GoRouter(
    initialLocation: ref.watch(siteRepositoryProvider).when(
          loading: () => '/',
          error: (error, stackTrace) => '/',
          data: (site) => switch (site) {
            Loading() => '/',
            Error() => '/',
            Success() => "/${site.data.id}",
          },
        ),
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ScreenAboutApp(),
        ),
      ),
      GoRoute(
        path: '/:site',
        pageBuilder: (context, state) {
          onSiteChange(ref, state);
          return NoTransitionPage(
            key: state.pageKey,
            child: const ScreenHome(),
          );
        },
      ),
      GoRoute(
        path: '/:site/about',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const ScreenAboutSite(),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const ScreenAboutApp(),
    ),
  );
}
