import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../widgets/section_header.dart';
import '../app_localizations.dart';
import '../account/login_section.dart';
import 'select_site_section.dart';
import 'guidance_section.dart';
import 'about_app_section.dart';
import 'licenses_section.dart';

class AboutScreen extends HookConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isMember = ref.watch(
      accountStatusProvider.select(
        (accountStatus) => accountStatus.account != null,
      ),
    );
    final bool isSite = ref.watch(
      siteRepositoryProvider.select(
        (site) => site is Success<SiteRecord>,
      ),
    );

    return CustomScrollView(
      slivers: [
        if (!isMember)
          const SelectSiteSection(),
        if (isSite && !isMember)
          SectionHeader(
            title: t.login,
            leading: Icons.login,
          ),
        if (isSite && !isMember) const LoginSection(),
        if (isSite)
          SectionHeader(
            title: t.guidance,
            leading: Icons.support_agent,
          ),
        if (isSite) GuidanceSection(),
        SectionHeader(
          title: t.aboutTheApp,
          leading: Icons.code,
        ),
        AboutAppSection(),
        SectionHeader(
          title: t.licenses,
          leading: Icons.notes,
        ),
        const LicensesSection(),
      ],
    );
  }
}
