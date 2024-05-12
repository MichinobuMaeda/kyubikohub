import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../app_localizations.dart';

class SelectSite extends HookConsumerWidget {
  const SelectSite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final selectedSite = useState<String?>(null);

    return FilledButton(
      child: Text(t.selectSite),
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => Card(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: cardItemPadding,
                      child: Text(
                        t.selectSite,
                        maxLines: 8,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: cardItemPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onChanged: (value) {
                              selectedSite.value = value;
                            },
                            textInputAction: TextInputAction.go,
                            autofocus: true,
                            onSubmitted: (value) {
                              context.go('/${value.trim()}');
                            },
                            decoration: InputDecoration(
                              labelText: t.siteId,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  context.go('/${selectedSite.value?.trim()}');
                                },
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
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: cardItemPadding,
                    child: TextButton(
                      child: Text(t.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
