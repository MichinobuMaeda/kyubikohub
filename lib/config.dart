import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

const String appTitle = 'Kyubiko Hub';
const String appUrl = 'https://kyubikohub.web.app';
const String testUrl = 'https://localhost:9099';
const String supportEmail = 'noreply@kyubikohub.firebaseapp.com';

// !!!!! DON"T EDIT !!!!!
// it's to be replaced with 'version' in pubspec.yaml on deployment.
const String version = 'for test';

const String adminsSiteId = 'admins';
const String testSiteId = 'test';
const String managersGroupId = 'managers';

// Licenses to add manually
const List<List<String>> licenseAssets = [
  // [text, product1, product2, ...]
  ['LICENSE', 'kyubikohub'],
  ['assets/fonts/OFL.txt', 'Noto Sans JP'],
];

// Assets
const String fontNameNotoSans = 'NotoSans';
const assetImageLogo = AssetImage('assets/images/logo-192.png');

// Firebase
const FirebaseOptions firebaseOptions = FirebaseOptions(
  // !!!!! DON"T EDIT !!!!!
  // it's to be replaced with a secret of GitHub Actions on deployment.
  apiKey: 'FIREBASE_API_KEY',
  authDomain: "kyubikohub.firebaseapp.com",
  projectId: "kyubikohub",
  storageBucket: "kyubikohub.appspot.com",
  messagingSenderId: "114575052714",
  appId: "1:114575052714:web:9ce6fc0483224f61fe65d3",
  measurementId: "G-8VLR54KLH9",
);
const String webRecaptchaSiteKey = '6LdNMMApAAAAACl1rU-RlsVwWBqOW8jnbUYmY8CR';

const FirebaseOptions testFirebaseOptions = FirebaseOptions(
  apiKey: 'test',
  authDomain: "localhost",
  projectId: "kyubikohub",
  storageBucket: "kyubikohub.appspot.com",
  messagingSenderId: "114575052714",
  appId: "1:114575052714:web:9ce6fc0483224f61fe65d3",
  measurementId: "G-8VLR54KLH9",
);

// Style -- key parameters
const themeMode = ThemeMode.system;
const seedColor = Color.fromARGB(255, 85, 107, 47);
const defaultFontFamily = fontNameNotoSans;
const monospaceFontFamily = 'monospace';
const baseSize = 16.0;
Color linkColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.blue.shade800
        : Colors.lightBlue.shade300;

// Style -- relative settings
ThemeData themeData(Brightness brightness) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  final bodySmall = TextStyle(
    fontSize: baseSize * 0.9,
    fontWeight: FontWeight.normal,
    color: colorScheme.onSurface,
  );
  final bodyMedium = bodySmall.copyWith(fontSize: baseSize);
  final bodyLarge = bodyMedium.copyWith(fontSize: baseSize * 1.1);
  final titleSmall = bodyMedium.copyWith(
    fontSize: baseSize * 1.2,
    color: colorScheme.primary,
  );
  final titleMedium = titleSmall.copyWith(fontSize: baseSize * 1.4);
  final titleLarge = titleSmall.copyWith(fontSize: baseSize * 1.6);

  return ThemeData(
    colorScheme: colorScheme,
    fontFamily: defaultFontFamily,
    useMaterial3: true,
    textTheme: TextTheme(
      bodySmall: bodySmall,
      bodyMedium: bodyMedium,
      bodyLarge: bodyLarge,
      titleSmall: titleSmall,
      titleMedium: titleMedium,
      titleLarge: titleLarge,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: bodyMedium,
      unselectedLabelStyle: bodyMedium,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: colorScheme.onSurface,
      titleTextStyle: titleSmall,
      subtitleTextStyle: bodyMedium,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(80),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withAlpha(160),
        height: 0.5,
      ),
      suffixIconColor: colorScheme.onSurface,
    ),
  );
}

const buttonGap = baseSize * 0.75;
const iconTextGap = baseSize * 0.25;
const iconButtonTransformVerticalOffset = Offset(0, -baseSize * 2.5);
const cardItemPadding = EdgeInsets.all(buttonGap);
const imagePadding = EdgeInsets.all(baseSize);

void onTapLink(String text, String? href, String? title) {
  if (href != null && href.trim().isNotEmpty) {
    launchUrl(
      Uri.parse(href.trim()),
      mode: LaunchMode.externalApplication,
    );
  }
}

MarkdownStyleSheet markdownStyleSheet(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return MarkdownStyleSheet(
    p: textTheme.bodyMedium,
    h1: textTheme.titleLarge?.copyWith(fontSize: baseSize * 2.0),
    h2: textTheme.titleLarge,
    h3: textTheme.titleMedium,
    h4: textTheme.titleSmall,
    h5: textTheme.titleSmall?.copyWith(
      fontSize: textTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.bold,
    ),
    h6: textTheme.titleSmall?.copyWith(
      fontSize: textTheme.bodyMedium?.fontSize,
      fontWeight: FontWeight.bold,
    ),
    code: textTheme.bodyMedium?.copyWith(fontFamily: monospaceFontFamily),
    a: textTheme.bodyMedium?.copyWith(color: linkColor(context)),
  );
}
