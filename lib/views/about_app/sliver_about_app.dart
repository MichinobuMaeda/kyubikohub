import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/data_state.dart';
import '../../providers/about_app_provider.dart';
import '../widgets/sliver_markdown.dart';
import '../widgets/sliver_loading_message.dart';
import '../widgets/sliver_error_message.dart';

enum About { guide, policy }

class SliverAbout extends HookConsumerWidget {
  final About about;
  const SliverAbout(this.about, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = ref.watch(aboutAppProvider);
    return switch (about) {
      Loading() => const SliverLoadingMessage(),
      Error() => SliverErrorMessage(about.message),
      Success() => SliverMarkdown(
          this.about == About.guide ? about.data.guide : about.data.policy,
          onTapLink: onTapLink,
        ),
    };
  }
}
