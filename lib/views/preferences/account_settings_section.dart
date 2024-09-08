import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/views/account/logout_form.dart';

import '../../config.dart';
import '../../l10n/app_localizations.dart';
import '../account/select_site_form.dart';
import '../account/change_password_form.dart';
import '../widgets/modal_sheet.dart';
import '../widgets/list_item.dart';

class AccountSettingsSection extends HookConsumerWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final items = [
      (
        title: t.selectSite,
        leading: const Icon(Icons.exit_to_app),
        child: const SelectSiteForm(),
      ),
      (
        title: t.changePassword,
        leading: const Icon(Icons.password),
        child: const ChangePasswordForm(),
      ),
      (
        title: t.logout,
        leading: const Icon(Icons.logout),
        child: const LogoutForm(),
      ),
    ];

    return ListItemsSection(
      childCount: items.length,
      height: listItemHeight,
      (context, ref, index, height) => ListItem.modalAction(
        index: index,
        height: height,
        title: items[index].title,
        leading: items[index].leading,
        child: ModalSheet(
          title: items[index].title,
          child: items[index].child,
        ),
      ),
    );
  }
}
