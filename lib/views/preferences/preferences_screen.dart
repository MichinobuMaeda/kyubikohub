import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/account_repository.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
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
            title: t.siteSettings,
            leading: Icons.build_circle,
          ),
        SectionHeader(
          title: t.accountSettings,
          leading: Icons.account_circle,
        ),
        const AccountSettingsSection(),
      ],
    );
  }
}
