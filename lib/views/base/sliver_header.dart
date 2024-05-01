import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/site_repository.dart';
import '../../providers/data_state.dart';
import '../app_localizations.dart';

const double iconButtonSize = 40.0;

class SliverHeader extends HookConsumerWidget {
  final String appName;
  const SliverHeader(this.appName, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final thm = Theme.of(context);

    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: true,
      expandedHeight: 108.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          ref.watch(siteRepositoryProvider).when(
                loading: () => appName,
                error: (error, stackTrace) => appName,
                data: (site) => switch (site) {
                  Loading() => appName,
                  Error() => appName,
                  Success() => site.data.name,
                },
              ),
          style: TextStyle(
            color: thm.colorScheme.onPrimaryContainer,
          ),
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.all(12),
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: ref.watch(siteRepositoryProvider).when(
                      loading: () => [],
                      error: (error, stackTrace) => [],
                      data: (site) => switch (site) {
                        Loading() => [],
                        Error() => [],
                        Success() => [
                            IconButton(
                              color: thm.colorScheme.primary,
                              icon: const Icon(
                                Icons.home,
                                size: iconButtonSize,
                              ),
                              // tooltip: t.home,
                              tooltip: GoRouter.of(context)
                                  .routeInformationProvider
                                  .value
                                  .uri
                                  .path,
                              onPressed: GoRouter.of(context)
                                          .routeInformationProvider
                                          .value
                                          .uri
                                          .path ==
                                      "/${site.data.id}"
                                  ? null
                                  : () => context.go("/${site.data.id}"),
                            ),
                            IconButton(
                              color: thm.colorScheme.primary,
                              icon: const Icon(
                                Icons.account_circle,
                                size: iconButtonSize,
                              ),
                              tooltip: 'Account',
                              onPressed: null,
                            ),
                            IconButton(
                              color: thm.colorScheme.primary,
                              icon: const Icon(
                                Icons.settings,
                                size: iconButtonSize,
                              ),
                              tooltip: 'Settings',
                              onPressed: null,
                            ),
                            IconButton(
                              color: thm.colorScheme.primary,
                              icon: const Icon(
                                Icons.info,
                                size: iconButtonSize,
                              ),
                              tooltip: t.aboutThisApp,
                              onPressed: GoRouter.of(context)
                                          .routeInformationProvider
                                          .value
                                          .uri
                                          .path ==
                                      "/${site.data.id}/about"
                                  ? null
                                  : () => context.go("/${site.data.id}/about"),
                            ),
                          ],
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
