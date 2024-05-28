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
  String get administration => '管理';
  // Tab Items
  String get notices => 'お知らせ';
  String get preferences => 'アプリの設定';
  String get myAccount => 'アカウントの設定';
  String get guidance => 'ご案内';
  String get aboutTheApp => 'アプリについて';
  String get licenses => 'ライセンス';
  String get users => 'メンバー';
  String get groups => 'グループ';
  String get sites => 'サイト';
  // Items
  String get siteId => 'サイトID';
  String get email => 'メールアドレス';
  String get password => 'パスワード';
  String get curPassword => '現在のパスワード';
  String get newPassword => '新しいパスワード';
  String get conPassword => '新しいパスワード（確認）';
  String get allMembers => 'すべてのメンバー';
  String get id => 'ID';
  String get siteName => 'サイト名';
  String get displayName => '表示名';
  // Actions
  String get login => 'ログイン';
  String get logout => 'ログアウト';
  String get copy => 'コピー';
  String get update => '更新';
  String get add => '新規追加';
  String get save => '保存';
  String get delete => '削除';
  String get restore => '復活';
  String get close => '閉じる';
  String get selectSite => 'サイトを選択する';
  String get changePassword => 'パスワード変更';
  String get resetPassword => 'パスワード再設定';
  String get forgetYourPassword => 'パスワードを忘れた場合';
  String get send => '送信';
  String get warning => '警告';
  // Errors
  String get authFailed => '認証に失敗しました。';
  String get systemError => 'システムエラーです。';
  String itemIsRequired({required String item}) => '$itemを入力してください。';
  String get passwordMismatch => '新しいパスワードの確認の入力が一致しません。';
  String get weakPassword => '弱いパスワードです。';
  String get changedPassword => 'パスワードを変更しました。';
  String get invalidEmail => '正しい書式のメールアドレスを入力してください。';
  String get userDisabled => 'メールアドレスまたはパスワードが間違っています。';
  String get userNotFound => userDisabled;
  String get wrongPassword => userDisabled;
  // Message
  String confirmTo({required String action}) => '本当に$actionしますか？';
  String currentSiteId({required String site}) => '現在のサイトID: $site';
  String get acceptEmail => '''
$supportEmail からのメールを受信できるようにしておいてください。''';
  String get sendResetPasswordEmail => '''
「$appTitle のパスワードを再設定してください」という表題のメールをお送りします。そのメールに記載したリンクを使ってパスワードを再設定してください。''';
  String get saved => '保存しました。';
  String get deleted => '削除しました。';
  String get restored => '復活しました。';
  String get sentEmail => 'メールを送信しました。';
  String get whyLogout => '通常、ログアウトの操作は不要です。';
  String get version => 'バージョン';
  String get defaultLoadingMessage => 'データ受信中 ...';
  String get defaultErrorMessage => 'エラー';
  String get updateThisApp => 'アプリを更新してください';
  String get adminPrivRequired => '管理者権限が必要です。';
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
