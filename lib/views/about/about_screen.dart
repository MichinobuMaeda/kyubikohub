import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/account_repository.dart';
import '../app_localizations.dart';
import '../account/select_site_form.dart';
import '../account/login_section.dart';
import '../widgets/section_header.dart';
import '../widgets/list_items_section.dart';
import 'guidance_section.dart';
import 'about_app_section.dart';
import 'licenses_section.dart';
import 'subscribe_section.dart';

class AboutScreen extends HookConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final account = ref.watch(accountRepositoryProvider);
    final isLoading = account is Loading<Account?>;
    final isMember = account is Success<Account?> && account.data != null;
    final bool isSite = ref.watch(
      siteRepositoryProvider.select(
        (site) => site is Success<SiteRecord>,
      ),
    );

    return CustomScrollView(
      slivers: [
        if (!isLoading && !isMember && isSite)
          SectionHeader(
            title: Text(t.login),
            leading: const Icon(Icons.login),
          ),
        if (!isLoading && !isMember && isSite) const LoginSection(),
        if (!isMember)
          ListItemsSection(
            childCount: 1,
            items: (index) => ModalSheetItemProps(
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
        if (isSite) const GuidanceSection(),
        SectionHeader(
          title: Text(t.aboutTheApp),
          leading: const Icon(Icons.code),
        ),
        const AboutAppSection(),
        const SubscribeSection(),
        SectionHeader(
          title: Text(t.licenses),
          leading: const Icon(Icons.notes),
        ),
        const LicensesSection(),
      ],
    );
  }
}
