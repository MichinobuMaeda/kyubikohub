import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/data_state.dart';
import '../../../providers/policy_provider.dart';
import '../widgets/sliver_markdown.dart';
import '../widgets/sliver_loading_message.dart';
import '../widgets/sliver_error_message.dart';

class SliverPrivacyPolicy extends HookConsumerWidget {
  const SliverPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(policyProvider);
    return switch (policy) {
      Loading() => const SliverLoadingMessage(),
      Error() => SliverErrorMessage(policy.message),
      Success() => SliverMarkdown(policy.data, onTapLink: onTapLink),
    };
  }
}
