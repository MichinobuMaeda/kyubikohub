import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/site_repository.dart';
import '../../providers/data_state.dart';
// import '../app_localizations.dart';
import '../base/screen_base.dart';
import '../widgets/sliver_title.dart';

class ScreenAboutSite extends HookConsumerWidget {
  const ScreenAboutSite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final t = AppLocalizations.of(context)!;

    return ScreenBase(
      [
        ref.read(siteRepositoryProvider).when(
              data: (site) => switch (site) {
                Loading() => const SliverTitle('--'),
                Error() => const SliverTitle('--'),
                Success() => SliverTitle(site.data.name),
              },
              error: (error, stackTrace) => const SliverTitle('--'),
              loading: () => const SliverTitle('--'),
            ),
      ],
      AppState.loading,
    );
  }
}
