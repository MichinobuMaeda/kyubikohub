import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/views/account/logout_form.dart';

import '../widgets/modal_items_section.dart';
import '../app_localizations.dart';
import '../account/select_site_form.dart';
import '../account/change_password_form.dart';

class AccountSettingsSection extends HookConsumerWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final items = [
      ModalItem(
        title: t.selectSite,
        leading: const Icon(Icons.exit_to_app),
        trailing: const Icon(Icons.more_horiz),
        child: const SelectSiteForm(),
      ),
      ModalItem(
        title: t.changePassword,
        leading: const Icon(Icons.password),
        trailing: const Icon(Icons.more_horiz),
        child: const ChangePasswordForm(),
      ),
      ModalItem(
        title: t.logout,
        leading: const Icon(Icons.logout),
        trailing: const Icon(Icons.more_horiz),
        child: const LogoutForm(),
      ),
    ];

    return ModalItemsSection(
      childCount: items.length,
      item: (index) => items[index],
    );
  }
}
