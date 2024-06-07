import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils.dart';

import 'package:kyubikohub/config.dart';
import 'package:kyubikohub/models/data_state.dart';
import 'package:kyubikohub/models/conf.dart';
import 'package:kyubikohub/providers/conf_repository.dart';
import 'package:kyubikohub/providers/account_repository.dart';
import 'package:kyubikohub/views/about/about_app_section.dart';
import 'package:kyubikohub/views/app_localizations.dart';

const testDescription = 'Test data';

class ConfRepositoryStub extends ConfRepository {
  @override
  DataState<Conf> build() => const Success<Conf>(
        data: Conf(
          desc: testDescription,
          forGuests: '',
          forMembers: '',
          forMangers: '',
          uiVersion: '',
        ),
      );
}

void main() {
  testWidgets(
    'AboutAppSection shows the app title, version, description.',
    (WidgetTester tester) async {
      // Prepare
      final t = AppLocalizations();
      final overrides = [
        confRepositoryProvider.overrideWith(() => ConfRepositoryStub()),
        accountStatusProvider.overrideWith(
          (AccountStatusRef ref) => const AccountStatus(
            account: null,
            manager: false,
            admin: false,
          ),
        ),
      ];

      // Run
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides,
          child: getTestMaterialApp(
            AboutAppSection(),
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
