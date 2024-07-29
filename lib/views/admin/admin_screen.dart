import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/section_header.dart';
import 'app_admin_section.dart';
import 'sites_section.dart';

class AdminScreen extends HookConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SectionHeader(
          title: Text(t.appAdmin),
          leading: const Icon(Icons.code),
        ),
        AppAdminSection(),
        SectionHeader(
          title: Text(t.siteAdmin),
          leading: const Icon(Icons.domain),
        ),
        const SitesSection(),
      ],
    );
  }
}
