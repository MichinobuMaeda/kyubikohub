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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) {
            selectedSite.value = value;
          },
          textInputAction: TextInputAction.go,
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
        Text(t.askAdminSiteId, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
