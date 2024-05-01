import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

const String appTitle = "Kyubiko Hub";

// !!!!! DON"T EDIT !!!!! UI version replaced with 'version' in pubspec.yaml
const String version = 'for test';

// Licenses to be added manually
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
    apiKey: 'FIREBASE_API_KEY',
    authDomain: "kyubikohub.firebaseapp.com",
    projectId: "kyubikohub",
    storageBucket: "kyubikohub.appspot.com",
    messagingSenderId: "114575052714",
    appId: "1:114575052714:web:9ce6fc0483224f61fe65d3",
    measurementId: "G-8VLR54KLH9");
const String webRecaptchaSiteKey = '6LdNMMApAAAAACl1rU-RlsVwWBqOW8jnbUYmY8CR';

// Style
const themeMode = ThemeMode.system;
const seedColor = Color.fromARGB(255, 85, 107, 47);
const defaultFontFamily = fontNameNotoSans;

Color stripedBackground(BuildContext context, int index) => index.isOdd
    ? Theme.of(context).colorScheme.surfaceVariant
    : Theme.of(context).colorScheme.background;

Color linkColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.blue.shade800
        : Colors.lightBlue.shade300;

const textTheme = TextTheme(
  bodySmall: TextStyle(fontSize: 14),
  bodyMedium: TextStyle(fontSize: 18),
  bodyLarge: TextStyle(fontSize: 20),
);

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  fontFamily: defaultFontFamily,
  useMaterial3: true,
  textTheme: textTheme,
);

final darkTheme = theme.copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
);

const tabIconMargin = 4.0;

const aboutLogoAreaSize = 144.0;
const aboutLogoAreaPadding = 16.0;

void onTapLink(String text, String? href, String? title) {
  if (href != null) {
    launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
  }
}

MarkdownStyleSheet markdownStyleSheet(BuildContext context) =>
    MarkdownStyleSheet(
      p: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h1: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h2: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h3: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h4: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h5: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      h6: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      code: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      a: TextStyle(color: linkColor(context)),
    );
