import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../widgets/section_header.dart';
import '../account/select_site_item.dart';
import '../app_localizations.dart';
import '../account/login_section.dart';
import 'guidance_section.dart';
import 'about_app_section.dart';
import 'licenses_section.dart';

class AboutScreen extends HookConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isMember = ref.watch(siteAccountRepositoryProvider) is Success;
    final site = ref.watch(siteRepositoryProvider);
    final bool isSite = site is Success<SiteRecord>;
    int index = 0;

    return CustomScrollView(
      slivers: [
        if (!isMember)
          SliverToBoxAdapter(child: SelectSiteSheet(index: index++)),
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
        if (isSite) const GuidanceSection(),
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
