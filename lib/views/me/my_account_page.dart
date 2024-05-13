import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/auth_repository.dart';
import '../widgets/reset_password_card.dart';
import '../app_localizations.dart';
import 'change_password_section.dart';
import 'logout_section.dart';

class MyAccountPage extends HookConsumerWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChangePasswordSection(),
          const Divider(),
          Padding(
            padding: cardItemPadding,
            child: FilledButton(
              child: Text(t.resetPassword),
              onPressed: () => showBottomSheet(
                context: context,
                builder: (context) => ResetPasswordCard(
                  title: t.resetPassword,
                  email: getUserEmail(),
                ),
              ),
            ),
          ),
          const Divider(),
          const LogoutSection(),
        ],
      ),
    );
  }
}
