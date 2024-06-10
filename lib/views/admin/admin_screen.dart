import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_localizations.dart';
import '../widgets/section_header.dart';
import 'app_settings_section.dart';
import 'sites_section.dart';

class AdminScreen extends HookConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SectionHeader(
          title: Text(t.appSettings),
          leading: const Icon(Icons.code),
        ),
        AppSettingsSection(),
        SectionHeader(
          title: Text(t.sites),
          leading: const Icon(Icons.domain),
        ),
        const SitesSection(),
      ],
    );
  }
}
