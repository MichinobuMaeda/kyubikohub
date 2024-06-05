import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_localizations.dart';
import '../widgets/section_header.dart';
import 'app_settings_section.dart';
import 'logs_section.dart';
import 'sites_section.dart';

class AdminScreen extends HookConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SectionHeader(
          title: t.appSettings,
          leading: Icons.code,
        ),
        AppSettingsSection(),
        SectionHeader(
          title: t.operationLog,
          leading: Icons.video_camera_front,
        ),
        const LogsSection(),
        SectionHeader(
          title: t.sites,
          leading: Icons.domain,
        ),
        const SitesSection(),
      ],
    );
  }
}
