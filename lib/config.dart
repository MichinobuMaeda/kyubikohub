import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

const String appTitle = "Kyubiko Hub";

// !!!!! DON"T EDIT !!!!!
// it's to be replaced with 'version' in pubspec.yaml on deployment.
const String version = 'for test';

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
    measurementId: "G-8VLR54KLH9");
const String webRecaptchaSiteKey = '6LdNMMApAAAAACl1rU-RlsVwWBqOW8jnbUYmY8CR';

// Style -- key parameters
const themeMode = ThemeMode.system;
const seedColor = Color.fromARGB(255, 85, 107, 47);
const defaultFontFamily = fontNameNotoSans;
const monospaceFontFamily = 'monospace';
const baseSize = 16.0;
final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
Color linkColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.blue.shade800
        : Colors.lightBlue.shade300;

// Style -- relative settings
final bodySmall = TextStyle(
  fontSize: baseSize * 0.9,
  fontWeight: FontWeight.normal,
  color: colorScheme.onBackground,
);
final bodyMedium = bodySmall.copyWith(fontSize: baseSize);
final bodyLarge = bodyMedium.copyWith(fontSize: baseSize * 1.1);
final titleSmall = bodyMedium.copyWith(
  fontSize: baseSize * 1.2,
  color: colorScheme.primary,
);
final titleMedium = titleSmall.copyWith(fontSize: baseSize * 1.4);
final titleLarge = titleSmall.copyWith(fontSize: baseSize * 1.6);

const buttonGap = baseSize * 0.75;
const iconTextGap = baseSize * 0.25;
const iconButtonTransformVerticalOffset = Offset(0, -baseSize * 2.5);
const cardItemPadding = EdgeInsets.all(buttonGap);
const imagePadding = EdgeInsets.all(baseSize);

ThemeData lightTheme = ThemeData(
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
    tileColor: colorScheme.background,
    titleTextStyle: titleSmall,
    subtitleTextStyle: bodyMedium,
  ),
);

ThemeData darkTheme = lightTheme.copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
);

void onTapLink(String text, String? href, String? title) {
  if (href != null && href.trim().isNotEmpty) {
    launchUrl(
      Uri.parse(href.trim()),
      mode: LaunchMode.externalApplication,
    );
  }
}

MarkdownStyleSheet markdownStyleSheet(BuildContext context) =>
    MarkdownStyleSheet(
      p: bodyMedium,
      h1: titleLarge.copyWith(fontSize: baseSize * 2.0),
      h2: titleLarge,
      h3: titleMedium,
      h4: titleSmall,
      h5: titleSmall.copyWith(
        fontSize: bodyLarge.fontSize,
        fontWeight: FontWeight.bold,
      ),
      h6: titleSmall.copyWith(
        fontSize: bodyMedium.fontSize,
        fontWeight: FontWeight.bold,
      ),
      code: bodyMedium.copyWith(fontFamily: monospaceFontFamily),
      a: bodyMedium.copyWith(color: linkColor(context)),
    );
