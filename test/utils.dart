import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kyubikohub/l10n/app_localizations.dart';

Widget getTestMaterialApp(Widget child) => MaterialApp(
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
      home: Scaffold(body: CustomScrollView(slivers: [child])),
    );
