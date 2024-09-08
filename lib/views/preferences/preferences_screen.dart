import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/account_repository.dart';
import '../widgets/section_header.dart';
import '../../l10n/app_localizations.dart';
import 'site_settings_section.dart';
import 'account_settings_section.dart';

class MeScreen extends HookConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final accountStatus = ref.watch(accountStatusProvider);

    return CustomScrollView(
      slivers: [
        if (accountStatus.manager)
          SectionHeader(
            title: Text(t.siteSettings),
            leading: const Icon(Icons.build_circle),
          ),
        if (accountStatus.manager) const SiteSettingsSection(),
        SectionHeader(
          title: Text(t.accountSettings),
          leading: const Icon(Icons.account_circle),
        ),
        const AccountSettingsSection(),
      ],
    );
  }
}
