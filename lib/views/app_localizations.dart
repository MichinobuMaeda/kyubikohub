import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../config.dart';

class AppLocalizations {
  String get title => appTitle;
  // Nav Items
  String get home => 'ホーム';
  String get me => '設定';
  String get about => '情報';
  // Tab Items
  String get notices => 'お知らせ';
  String get preferences => 'アプリの設定';
  String get myAccount => 'アカウントの設定';
  String get guidance => 'ご案内';
  String get aboutTheApp => 'アプリについて';
  String get licenses => 'ライセンス';
  String get filter => 'フィルター';
  String get removeFilter => 'フィルター解除';
  String get users => 'メンバー';
  String get groups => 'グループ';
  // Items
  String get email => 'メールアドレス';
  String get password => 'パスワード';
  // Actions
  String get login => 'ログイン';
  String get logout => 'ログアウト';
  String get copy => 'コピー';
  String get update => '更新';
  String get save => '保存';
  String get close => '閉じる';
  // Errors
  String get authFailed => '認証に失敗しました。';
  String get emailRequired => 'メールアドレスを入力してください。';
  String get passwordRequired => 'パスワードを入力してください。';
  String get invalidEmail => '正しい書式のメールアドレスを入力してください。';
  String get userDisabled => 'メールアドレスまたはパスワードが間違っています。';
  String get userNotFound => 'メールアドレスまたはパスワードが間違っています。';
  String get wrongPassword => 'メールアドレスまたはパスワードが間違っています。';

  String loginSite({required String site}) => 'サイト「$site」にログインします。';
  String get selectLoginMethod => 'ログイン方法を選択してください。';
  String get emailLink => 'ログイン用のリンクをメールで送信';
  String get emailAndPassword => 'メールアドレスとパスワード';
  String get whyLogout => '通常、ログアウトの操作は不要です。';
  String get version => 'バージョン';
  String get defaultLoadingMessage => 'データ受信中 ...';
  String get defaultErrorMessage => 'エラー';
  String get updateThisApp => 'アプリを更新してください';
  String get adminPrivRequired => '管理者権限が必要です。';
  String get siteId => 'サイトID';
  String get selectSite => 'サイトの選択';
  String get askAdminSiteId => 'サイトIDがわからない場合はサイト管理者に問い合わせてください。';
  String get askAdminHowToLogin => 'ログイン方法がわからない場合はサイト管理者に問い合わせてください。';

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
