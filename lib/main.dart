import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/app_localizations.dart';
import 'views/router.dart';
import 'providers/update_app_provider.dart';
import 'providers/provider_logger.dart';
import 'repositories/local_storage_repository.dart';
import 'config.dart';
import 'platforms.dart';

void main() async {
  SharedPreferences.setPrefix('kyubikohub');
  const bool isTest = version == 'for test';
  debugPrint('     env: ${isTest ? "test" : "production"}');

  debugPrint('Adding licenses manually.');
  for (var entry in licenseAssets) {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        entry.sublist(1),
        await rootBundle.loadString(entry[0]),
      );
    });
  }

  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('    info: Initializing Firebase.');
  await Firebase.initializeApp(options: firebaseOptions);
  if (isTest) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  } else {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(webRecaptchaSiteKey),
      // androidProvider: AndroidProvider.debug,
      // appleProvider: AppleProvider.appAttest,
    );
  }
  debugPrint('    info: Initialized Firebase.');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (isTest) {
    await prefs.remove('site');
  }

  debugPrint("    info: Show Widgets.");
  runApp(
    ProviderScope(
      observers: [
        if (isTest) ProviderLogger(),
      ],
      overrides: [
        updateAppProvider.overrideWith((ref) => updateAppImpl),
        localStorageRepositoryProvider.overrideWith((ref) => prefs)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        title: appTitle,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('ja'),
        supportedLocales: const [
          Locale('ja'),
        ],
        routerConfig: router(ref),
      );
}
