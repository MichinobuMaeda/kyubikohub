import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../config.dart';

class AppLocalizations {
  AppLocalizations() : localeName = intl.Intl.canonicalizedLocale('ja');

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ja')];

  String get title => appTitle;
  String get login => 'ログイン';
  String get copy => 'コピー';
  String get close => '閉じる';
  String get home => 'ホーム';
  String get settings => '設定';
  String get information => '情報';
  String get guidance => 'ご案内';
  String get aboutTheApp => 'アプリについて';
  String get version => 'バージョン';
  String get licenses => 'ライセンス';
  String get defaultLoadingMessage => 'データ受信中 ...';
  String get defaultErrorMessage => 'エラー';
  String get updateThisApp => 'アプリを更新する';
  String get adminPrivRequired => '管理者権限が必要です。';
  String get siteId => 'サイトID';
  String get forUsers => '利用者はこちらから。';
  String get askAdminSiteId => 'サイトIDはサイト管理者に問い合わせてください。';
  String get askAdminHowToLogin => 'ログイン方法がわからない場合はサイト管理者に問い合わせてください。';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  return AppLocalizations();
}
