import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils.dart';

import 'package:kyubikohub/config.dart';
import 'package:kyubikohub/models/data_state.dart';
import 'package:kyubikohub/models/conf.dart';
import 'package:kyubikohub/models/site.dart';
import 'package:kyubikohub/providers/conf_repository.dart';
import 'package:kyubikohub/providers/site_repository.dart';
import 'package:kyubikohub/views/about/about_app_page.dart';
import 'package:kyubikohub/views/app_localizations.dart';

const testDescription = 'Test data';

class ConfRepositoryStub extends ConfRepository {
  @override
  DataState<Conf> build() => const Success<Conf>(
        data: Conf(
          desc: testDescription,
          uiVersion: '',
        ),
      );
}

class SiteRepositoryLoading extends SiteRepository {
  @override
  DataState<Site> build() => const Loading();
}

class SiteRepositorySuccess extends SiteRepository {
  @override
  DataState<Site> build() => const Success(
    data: Site(
      id: 'test',
      name: 'test',
      forGuests: '',
      forMembers: '',
      forMangers: '',
    ),
  );
}

void main() {
  testWidgets(
    'AboutAppPage shows the app title, version, description'
    ' and "Select site" if site is not selected.',
    (WidgetTester tester) async {
      // Prepare
      final t = AppLocalizations();
      final overrides = [
        confRepositoryProvider.overrideWith(() => ConfRepositoryStub()),
        siteRepositoryProvider.overrideWith(() => SiteRepositoryLoading()),
      ];

      // Run
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides,
          child: getTestMaterialApp(
            const AboutAppPage(),
          ),
        ),
      );

      // Check
      expect(find.text(appTitle), findsOne);
      expect(find.text('${t.version}: $version'), findsOne);
      expect(find.text(t.selectSite), findsOne);
      expect(find.text(testDescription), findsOne);
    },
  );

  testWidgets(
    'AboutAppPage shows the app title, version, description'
    ' and hides "Select site" if site is selected.',
    (WidgetTester tester) async {
      // Prepare
      final t = AppLocalizations();
      final overrides = [
        confRepositoryProvider.overrideWith(() => ConfRepositoryStub()),
        siteRepositoryProvider.overrideWith(() => SiteRepositorySuccess()),
      ];

      // Run
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides,
          child: getTestMaterialApp(
            const AboutAppPage(),
          ),
        ),
      );

      // Check
      expect(find.text(appTitle), findsOne);
      expect(find.text('${t.version}: $version'), findsOne);
      expect(find.text(t.selectSite), findsNothing);
      expect(find.text(testDescription), findsOne);
    },
  );
}
