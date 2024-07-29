import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kyubikohub/models/nav_item.dart';

import '../../l10n/app_localizations.dart';
import 'section_header.dart';

class GoBackHeader extends HookConsumerWidget {
  const GoBackHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return SectionHeader(
        title: Text(t.goBack),
        leading: const Icon(Icons.arrow_back_ios_new),
        color:
            Theme.of(context).colorScheme.surfaceContainerHigh.withAlpha(224),
        onTap: () => context.canPop()
            ? context.pop()
            : context.goNamed(NavPath.home.name));
  }
}
