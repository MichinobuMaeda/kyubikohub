import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kyubikohub/models/data_state.dart';

import '../../config.dart';
import '../../providers/log_repository.dart';
import '../../providers/site_repository.dart';
import '../app_localizations.dart';
import '../widgets/modal_sheet.dart';

class SelectSiteSheet extends HookConsumerWidget {
  final int index;
  const SelectSiteSheet({super.key, this.index = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final selectedSite = useState<String?>(null);
    final site = ref.watch(siteRepositoryProvider);
    final oldSite = switch (site) {
      Loading() || Error() => null,
      Success() => site.data.$1.id,
    };

    return SliverToBoxAdapter(
      child: SizedBox(
        height: listItemHeight,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            leading: const Icon(Icons.domain),
            title: Text(t.selectSite),
            trailing: const Icon(Icons.more_horiz),
            hoverColor: listItemsHoverColor(context),
            tileColor: listItemsStripeColor(context, index),
            onTap: () => showBottomSheet(
              context: context,
              builder: (context) => ModalSheet(
                title: t.selectSite,
                body: SingleChildScrollView(
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
                          if (oldSite != null)
                            const SizedBox(height: buttonGap),
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
