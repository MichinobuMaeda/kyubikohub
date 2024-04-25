import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils.dart';
import 'package:kyubikohub/views/app_localizations.dart';
import 'package:kyubikohub/views/widgets/sliver_loading_message.dart';

void main() {
  testWidgets(
    'SliverLoadingMessage shows default message',
    (WidgetTester tester) async {
      // Prepare

      // Run
      await tester.pumpWidget(
        ProviderScope(
          child: getTestSliverContainer(
            const SliverLoadingMessage(),
          ),
        ),
      );

      // Check
      expect(find.text(AppLocalizations().defaultLoadingMessage), findsOne);
    },
  );
  testWidgets(
    'SliverLoadingMessage shows given message',
    (WidgetTester tester) async {
      // Prepare

      // Run
      await tester.pumpWidget(
        ProviderScope(
          child: getTestSliverContainer(
            const SliverLoadingMessage(message: 'Test message'),
          ),
        ),
      );

      // Check
      expect(find.text('Test message'), findsOne);
    },
  );
}
