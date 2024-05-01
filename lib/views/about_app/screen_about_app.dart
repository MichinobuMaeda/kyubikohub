import 'package:flutter/material.dart';

import '../app_localizations.dart';
import '../base/screen_base.dart';
import '../widgets/sliver_title.dart';
import 'sliver_logo.dart';
import 'sliver_version.dart';
import 'sliver_about_app.dart';
import 'sliver_license_list.dart';

class ScreenAboutApp extends StatelessWidget {
  const ScreenAboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ScreenBase(
      [
        SliverTitle(t.aboutThisApp),
        const SliverVersion(),
        const SliverLogo(),
        const SliverAbout(About.guide),
        const SliverAbout(About.policy),
        SliverTitle(t.licenses),
        const SliverLicenseList(),
      ],
      AppState.loading,
    );
  }
}
