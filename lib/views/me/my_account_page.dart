import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../widgets/go_site.dart';
import '../app_localizations.dart';

class MyAccountPage extends HookConsumerWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: cardItemPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoSite(title: t.changeSite, message: t.askAdminSiteId),
            ],
          ),
        ),
      ],
    );
  }
}