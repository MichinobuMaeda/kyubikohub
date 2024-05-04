import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils.dart';

import 'package:kyubikohub/config.dart';
import 'package:kyubikohub/views/app_localizations.dart';
import 'package:kyubikohub/providers/about_app_provider.dart';
import 'package:kyubikohub/models/data_state.dart';
import 'package:kyubikohub/views/about/about_app_page.dart';

void main() {
  testWidgets(
    'AboutAppPage shows the app title, version and description.',
    (WidgetTester tester) async {
      // Prepare
      final t = AppLocalizations();
      const testDescription = 'Test data';
      final overrides = [
        aboutAppProvider.overrideWith(
          (ref) => const Success(data: testDescription),
        ),
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
      expect(find.text(testDescription), findsOne);
    },
  );
}
