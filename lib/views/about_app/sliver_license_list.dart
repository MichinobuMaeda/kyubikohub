import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/license_entries_provider.dart';
import '../../providers/data_state.dart';
import '../widgets/sliver_error_message.dart';
import '../widgets/sliver_loading_message.dart';

class SliverLicenseList extends HookConsumerWidget {
  const SliverLicenseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thm = Theme.of(context);
    final licenses = ref.watch(licenseEntryProvider);

    return switch (licenses) {
      Success() => SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => Container(
              padding: edgeInsetsInnerScrollPaneWithRightSpace,
              color: stripedBackground(context, index),
              height: scrollPaneHeightNarrow,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      licenses.data[index].title,
                      style: TextStyle(
                        color: thm.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      licenses.data[index].body,
                      style: TextStyle(
                        color: thm.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            childCount: licenses.data.length,
          ),
        ),
      Error() => SliverErrorMessage(licenses.message),
      Loading() => const SliverLoadingMessage(),
    };
  }
}
