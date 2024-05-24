import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kyubikohub/models/data_state.dart';

import '../../config.dart';
import '../../providers/log_repository.dart';
import '../../providers/site_repository.dart';
import '../app_localizations.dart';
import 'bottom_card.dart';

class SelectSite extends HookConsumerWidget {
  const SelectSite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final selectedSite = useState<String?>(null);
    final site = ref.watch(siteRepositoryProvider);
    final oldSite = switch (site) {
      Loading() || Error() => null,
      Success() => site.data.$1.id,
    };

    return FilledButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.domain),
          const SizedBox(width: iconTextGap),
          Text(t.selectSite),
        ],
      ),
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => BottomCard(
          title: t.selectSite,
          body: SingleChildScrollView(
            child: Padding(
              padding: cardItemPadding,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        selectedSite.value = value;
                      },
                      textInputAction: TextInputAction.go,
                      autofocus: true,
                      onSubmitted: (value) => goSite(
                        context,
                        oldSite,
                        value,
                      ),
                      decoration: InputDecoration(
                        labelText: t.siteId,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () => goSite(
                            context,
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
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  void goSite(
    BuildContext context,
    String? oldSite,
    String? newSite,
  ) {
    Navigator.pop(context);
    context.go('/${newSite?.trim()}');

    if (oldSite == null) {
      logAppInfo('Select site: $newSite');
    } else {
      logInfo(oldSite, 'Select site: $newSite');
    }
  }
}
