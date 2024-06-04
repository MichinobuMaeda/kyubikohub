import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kyubikohub/models/data_state.dart';

import '../../config.dart';
import '../../providers/log_repository.dart';
import '../../providers/site_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../app_localizations.dart';

class SelectSiteForm extends HookConsumerWidget {
  final int index;
  const SelectSiteForm({super.key, this.index = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final selectedSite = useState<String?>(null);
    final site = ref.watch(siteRepositoryProvider);
    final oldSite = switch (site) {
      Loading() || Error() => null,
      Success() => site.data.selected.id,
    };

    return SingleChildScrollView(
      child: Padding(
        padding: cardItemPadding,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (oldSite != null)
                Text(
                  t.currentSiteId(site: oldSite),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (oldSite != null) const SizedBox(height: buttonGap),
              TextField(
                onChanged: (value) {
                  selectedSite.value = value;
                },
                textInputAction: TextInputAction.go,
                autofocus: true,
                onSubmitted: (value) => goSite(
                  context,
                  ref,
                  oldSite,
                  value,
                ),
                decoration: InputDecoration(
                  labelText: t.siteId,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => goSite(
                      context,
                      ref,
                      oldSite,
                      selectedSite.value,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxWidth: baseSize * 24,
                    minHeight: baseSize * 5,
                  ),
                ),
              ),
              Text(
                t.askAdminSiteId,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  Future<void> goSite(
    BuildContext context,
    WidgetRef ref,
    String? oldSite,
    String? newSite,
  ) async {
    ref.read(modalSheetControllerProviderProvider.notifier).close();
    context.go('/${newSite?.trim()}');

    if (oldSite == null) {
      logAppInfo('Select site: $newSite');
    } else {
      logInfo(oldSite, 'Select site: $newSite');
    }
  }
}
