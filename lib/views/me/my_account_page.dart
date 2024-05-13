import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'change_password_section.dart';
import 'reset_password_section.dart';
import 'logout_section.dart';

class MyAccountPage extends HookConsumerWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChangePasswordSection(),
          Divider(),
          ResetPasswordSection(),
          Divider(),
          LogoutSection(),
        ],
      ),
    );
  }
}
