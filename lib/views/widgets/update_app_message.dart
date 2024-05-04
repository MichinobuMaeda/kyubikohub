import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/update_app_provider.dart';
import '../../providers/ui_version_provider.dart';
import '../../models/data_state.dart';
import '../app_localizations.dart';

class UpdateAppMessage extends HookConsumerWidget {
  const UpdateAppMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final updateApp = ref.watch(updateAppProvider);
    final uiVersion = ref.watch(uiVersionProvider);
    final toBeUpdate = switch (uiVersion) {
      Loading() || Error() => false,
      Success() => uiVersion.data != version,
    };

    return toBeUpdate
        ? ColoredBox(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: cardItemPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(t.updateThisApp)),
                  const SizedBox(width: buttonGap),
                  OutlinedButton(
                    onPressed: updateApp,
                    child: Row(
                      children: [
                        const Icon(Icons.refresh),
                        const SizedBox(width: iconTextGap),
                        Text(t.update),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
