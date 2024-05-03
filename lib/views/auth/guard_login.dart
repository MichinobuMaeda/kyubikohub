import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/site_repository.dart';
import '../../providers/data_state.dart';
import '../about/about_screen.dart';

class GuardLogin extends HookConsumerWidget {
  final Widget child;
  const GuardLogin({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final site = ref.watch(siteRepositoryProvider);
    return switch (site) {
      Loading() || Error() => const AboutScreen(),
      Success() => child,
    };
  }
}
