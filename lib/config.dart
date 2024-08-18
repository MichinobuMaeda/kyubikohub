import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

const String projectId = 'kyubikohub';
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

// App default
const int homeNoticesCount = 6;

// Licenses to add manually
const List<List<String>> licenseAssets = [
  // [text, product1, product2, ...]
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

const functionsRegion = 'asia-northeast2';

const noticesLimit = 1000;
const noticesShort = 3;

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

const buttonGap = baseSize * 0.75;
const iconTextGap = baseSize * 0.5;
const iconButtonTransformVerticalOffset = Offset(0, -baseSize * 2.5);
const cardItemPadding = EdgeInsets.all(buttonGap);
const cardItemPaddingHalf = EdgeInsets.all(buttonGap * 0.5);
const imagePadding = EdgeInsets.all(baseSize);
const contentWidth = baseSize * 54;

const listItemHeight = baseSize * 3.0;
const listItemHeightWithSubtitle = baseSize * 4.4;
const sectionHeaderHeight = listItemHeight;
Color sectionHeaderColor(BuildContext context) =>
    Theme.of(context).colorScheme.primaryContainer.withAlpha(224);

const textBoxMaxLines = 64;

const inputDecorationThemeContentPadding = EdgeInsets.only(
  left: baseSize / 2,
  right: baseSize / 2,
  top: baseSize,
  bottom: baseSize,
);

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
    fontFamily: defaultFontFamily,
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
      titleTextStyle: bodyLarge,
      subtitleTextStyle: bodySmall,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: inputDecorationThemeContentPadding,
      labelStyle: TextStyle(color: colorScheme.primary),
      helperStyle: TextStyle(color: colorScheme.tertiary),
      border: const OutlineInputBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      constraints: BoxConstraints(
        minWidth: contentWidth,
        maxWidth: contentWidth,
      ),
    ),
  );
}

Color sectionColor(BuildContext context) =>
    Theme.of(context).colorScheme.surfaceContainerLowest;

Color listItemsStripeColor(BuildContext context, int index) => index.isOdd
    ? Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(192)
    : sectionColor(context);

Color listItemsHoverColor(BuildContext context) =>
    Theme.of(context).colorScheme.primaryFixed.withAlpha(64);

Color modalColor(BuildContext context) =>
    Theme.of(context).colorScheme.tertiaryContainer;

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

// https://www.geeksforgeeks.org/flutter-generate-strong-random-password/
const passwordChars =
    '!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
const defaultPasswordLength = 16;
String generatePassword() {
  final random = Random();
  String password = '';
  for (int i = 0; i < defaultPasswordLength; i++) {
    password += passwordChars[random.nextInt(passwordChars.length)];
  }
  return password;
}

String formatYmdHms(DateTime ts) =>
    ts.toIso8601String().substring(0, 19).replaceFirst('T', ' ');

String formatYmdHm(DateTime ts) =>
    ts.toIso8601String().substring(0, 16).replaceFirst('T', ' ');

String formatYmd(DateTime ts) => ts.toIso8601String().substring(0, 10);

const regAlphaNumerics = r"^[a-zA-Z0-9]+$";
const regLCasesAndNumerics = r"^[a-z0-9]+$";
const regUCasesAndNumerics = r"^[A-Z0-9]+$";
const regEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";
const regTel = r"^([0-9]+)(-[0-9]+)*$";
const regZip = r"^([0-9]+)(-[0-9]+)*$";
