import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_localizations.dart';
import '../widgets/section_header.dart';
import '../account/select_site_item.dart';
import '../account/change_password_item.dart';
import '../account/logout_item.dart';

class MeScreen extends HookConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    int index = 0;

    return CustomScrollView(
      slivers: [
        SectionHeader(
          title: t.myAccount,
          leading: Icons.account_circle,
        ),
        SliverToBoxAdapter(child: SelectSiteSheet(index: index++)),
        SliverToBoxAdapter(child: ChangePasswordItem(index: index++)),
        SliverToBoxAdapter(child: LogoutItem(index: index++)),
      ],
    );
  }
}
