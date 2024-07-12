import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/go_back_header.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
import 'notices_section.dart';

class NoticesScreen extends HookConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        const GoBackHeader(),
        SectionHeader(
          title: Text(t.notices),
          leading: const Icon(Icons.notifications),
        ),
        const NoticesSection(),
      ],
    );
  }
}
