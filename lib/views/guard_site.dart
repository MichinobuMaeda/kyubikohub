import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/site_repository.dart';
import '../providers/data_state.dart';
import 'about/about_app_screen.dart';

class GuardSite extends HookConsumerWidget {
  final Widget child;
  const GuardSite({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final site = ref.watch(siteRepositoryProvider);

    return switch (site) {
      Loading() || Error() => const AboutAppScreen(),
      Success() => child,
    };
  }
}
