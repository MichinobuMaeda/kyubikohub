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
      (
        title: t.selectSite,
        leading: Icons.exit_to_app,
        trailing: Icons.more_horiz,
        child: const SelectSiteForm(),
      ),
      (
        title: t.changePassword,
        leading: Icons.password,
        trailing: Icons.more_horiz,
        child: const ChangePasswordForm(),
      ),
      (
        title: t.logout,
        leading: Icons.logout,
        trailing: Icons.more_horiz,
        child: const LogoutForm(),
      ),
    ];

    return ModalItemsSection(
      childCount: items.length,
      item: (index) => ModalItem(
        title: items[index].title,
        leading: Icon(items[index].leading),
        trailing: Icon(items[index].trailing),
        child: items[index].child,
      ),
    );
  }
}
