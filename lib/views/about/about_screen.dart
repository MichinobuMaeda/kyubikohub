import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../app_localizations.dart';
import '../account/select_site_form.dart';
import '../account/login_section.dart';
import '../widgets/section_header.dart';
import '../widgets/modal_items_section.dart';
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
        if (isSite && !isMember)
          SectionHeader(
            title: Text(t.login),
            leading: const Icon(Icons.login),
          ),
        if (isSite && !isMember) const LoginSection(),
        if (!isMember)
          ModalItemsSection(
            childCount: 1,
            item: (index) => ModalItem(
              title: t.selectSite,
              leading: const Icon(Icons.exit_to_app),
              trailing: const Icon(Icons.more_horiz),
              child: const SelectSiteForm(),
            ),
          ),
        if (isSite)
          SectionHeader(
            title: Text(t.guidance),
            leading: const Icon(Icons.support_agent),
          ),
        if (isSite) GuidanceSection(),
        SectionHeader(
          title: Text(t.aboutTheApp),
          leading: const Icon(Icons.code),
        ),
        AboutAppSection(),
        SectionHeader(
          title: Text(t.licenses),
          leading: const Icon(Icons.notes),
        ),
        const LicensesSection(),
      ],
    );
  }
}
