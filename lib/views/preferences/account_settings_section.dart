import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/views/account/logout_sheet.dart';

import '../../config.dart';
import '../widgets/modal_item.dart';
import '../app_localizations.dart';
import '../account/select_site_sheet.dart';
import '../account/change_password_sheet.dart';

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
        child: const SelectSiteSheet(),
      ),
      (
        title: t.changePassword,
        leading: Icons.password,
        trailing: Icons.more_horiz,
        child: const ChangePasswordSheet(),
      ),
      (
        title: t.logout,
        leading: Icons.logout,
        trailing: Icons.more_horiz,
        child: const LogoutSheet(),
      ),
    ];

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: items.length,
        (BuildContext context, int index) => ModalItems(
          index: index,
          height: listItemHeight,
          title: items[index].title,
          leading: Icon(items[index].leading),
          trailing: Icon(items[index].trailing),
          child: items[index].child,
        ),
      ),
    );
  }
}
