// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kyubikohub/views/app_localizations.dart';
import 'package:kyubikohub/views/widgets/sliver_loading_message.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale:  Locale('ja'),
          supportedLocales:  [
            Locale('ja'),
          ],
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverLoadingMessage(message: 'Test message'),
              ],
            ),
          ),
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Test message'), findsOne);
  });
}
