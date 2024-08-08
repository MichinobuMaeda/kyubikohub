import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja')
  ];

  /// No description provided for @title.
  ///
  /// In ja, this message translates to:
  /// **'Kyubiko Hub'**
  String get title;

  /// No description provided for @home.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get home;

  /// No description provided for @me.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get me;

  /// No description provided for @about.
  ///
  /// In ja, this message translates to:
  /// **'情報'**
  String get about;

  /// No description provided for @administration.
  ///
  /// In ja, this message translates to:
  /// **'管理'**
  String get administration;

  /// No description provided for @admin.
  ///
  /// In ja, this message translates to:
  /// **'アプリ管理者'**
  String get admin;

  /// No description provided for @manager.
  ///
  /// In ja, this message translates to:
  /// **'サイト管理者'**
  String get manager;

  /// No description provided for @notices.
  ///
  /// In ja, this message translates to:
  /// **'お知らせ'**
  String get notices;

  /// No description provided for @preferences.
  ///
  /// In ja, this message translates to:
  /// **'アプリの設定'**
  String get preferences;

  /// No description provided for @accountSettings.
  ///
  /// In ja, this message translates to:
  /// **'アカウントの設定'**
  String get accountSettings;

  /// No description provided for @siteSettings.
  ///
  /// In ja, this message translates to:
  /// **'サイトの設定'**
  String get siteSettings;

  /// No description provided for @siteAdmin.
  ///
  /// In ja, this message translates to:
  /// **'サイトの管理'**
  String get siteAdmin;

  /// No description provided for @appAdmin.
  ///
  /// In ja, this message translates to:
  /// **'アプリの管理'**
  String get appAdmin;

  /// No description provided for @guidance.
  ///
  /// In ja, this message translates to:
  /// **'ご案内'**
  String get guidance;

  /// No description provided for @aboutTheApp.
  ///
  /// In ja, this message translates to:
  /// **'アプリについて'**
  String get aboutTheApp;

  /// No description provided for @forGuests.
  ///
  /// In ja, this message translates to:
  /// **'ログイン前の案内'**
  String get forGuests;

  /// No description provided for @forMembers.
  ///
  /// In ja, this message translates to:
  /// **'ログイン後の案内'**
  String get forMembers;

  /// No description provided for @forManagers.
  ///
  /// In ja, this message translates to:
  /// **'サイト管理者向けの案内'**
  String get forManagers;

  /// No description provided for @forSubscriber.
  ///
  /// In ja, this message translates to:
  /// **'利用申込みの案内'**
  String get forSubscriber;

  /// No description provided for @licenses.
  ///
  /// In ja, this message translates to:
  /// **'ライセンス'**
  String get licenses;

  /// No description provided for @users.
  ///
  /// In ja, this message translates to:
  /// **'メンバー'**
  String get users;

  /// No description provided for @groups.
  ///
  /// In ja, this message translates to:
  /// **'グループ'**
  String get groups;

  /// No description provided for @sites.
  ///
  /// In ja, this message translates to:
  /// **'サイト'**
  String get sites;

  /// No description provided for @siteId.
  ///
  /// In ja, this message translates to:
  /// **'サイトID'**
  String get siteId;

  /// No description provided for @email.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレス'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get password;

  /// No description provided for @curPassword.
  ///
  /// In ja, this message translates to:
  /// **'現在のパスワード'**
  String get curPassword;

  /// No description provided for @newPassword.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード'**
  String get newPassword;

  /// No description provided for @conPassword.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード（確認）'**
  String get conPassword;

  /// No description provided for @allMembers.
  ///
  /// In ja, this message translates to:
  /// **'すべてのメンバー'**
  String get allMembers;

  /// No description provided for @id.
  ///
  /// In ja, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @siteName.
  ///
  /// In ja, this message translates to:
  /// **'サイト名'**
  String get siteName;

  /// No description provided for @displayName.
  ///
  /// In ja, this message translates to:
  /// **'表示名'**
  String get displayName;

  /// No description provided for @groupMembership.
  ///
  /// In ja, this message translates to:
  /// **'所属グループ'**
  String get groupMembership;

  /// No description provided for @operationLog.
  ///
  /// In ja, this message translates to:
  /// **'操作ログ'**
  String get operationLog;

  /// No description provided for @sample.
  ///
  /// In ja, this message translates to:
  /// **'サンプル'**
  String get sample;

  /// No description provided for @subscriber.
  ///
  /// In ja, this message translates to:
  /// **'利用者'**
  String get subscriber;

  /// No description provided for @tel.
  ///
  /// In ja, this message translates to:
  /// **'電話番号'**
  String get tel;

  /// No description provided for @address.
  ///
  /// In ja, this message translates to:
  /// **'住所'**
  String get address;

  /// No description provided for @zip.
  ///
  /// In ja, this message translates to:
  /// **'郵便番号'**
  String get zip;

  /// No description provided for @prefecture.
  ///
  /// In ja, this message translates to:
  /// **'都道府県'**
  String get prefecture;

  /// No description provided for @city.
  ///
  /// In ja, this message translates to:
  /// **'市区町村'**
  String get city;

  /// No description provided for @address1.
  ///
  /// In ja, this message translates to:
  /// **'町丁目番地号'**
  String get address1;

  /// No description provided for @address2.
  ///
  /// In ja, this message translates to:
  /// **'建物名・部屋番号'**
  String get address2;

  /// No description provided for @subscriberName.
  ///
  /// In ja, this message translates to:
  /// **'利用者名'**
  String get subscriberName;

  /// No description provided for @subscriberEmail.
  ///
  /// In ja, this message translates to:
  /// **'利用者メール'**
  String get subscriberEmail;

  /// No description provided for @purposeSubscription.
  ///
  /// In ja, this message translates to:
  /// **'利用の目的'**
  String get purposeSubscription;

  /// No description provided for @login.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// No description provided for @copy.
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In ja, this message translates to:
  /// **'更新'**
  String get update;

  /// No description provided for @add.
  ///
  /// In ja, this message translates to:
  /// **'新規追加'**
  String get add;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In ja, this message translates to:
  /// **'復活'**
  String get restore;

  /// No description provided for @close.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get close;

  /// No description provided for @selectSite.
  ///
  /// In ja, this message translates to:
  /// **'サイトを選択する'**
  String get selectSite;

  /// No description provided for @changePassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワード変更'**
  String get changePassword;

  /// No description provided for @resetPassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワード再設定'**
  String get resetPassword;

  /// No description provided for @forgetYourPassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを忘れた場合'**
  String get forgetYourPassword;

  /// No description provided for @send.
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get send;

  /// No description provided for @goBack.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get goBack;

  /// No description provided for @warning.
  ///
  /// In ja, this message translates to:
  /// **'警告'**
  String get warning;

  /// No description provided for @showMore.
  ///
  /// In ja, this message translates to:
  /// **'続きを見る'**
  String get showMore;

  /// No description provided for @subscribe.
  ///
  /// In ja, this message translates to:
  /// **'利用申込み'**
  String get subscribe;

  /// No description provided for @authFailed.
  ///
  /// In ja, this message translates to:
  /// **'認証に失敗しました。'**
  String get authFailed;

  /// No description provided for @systemError.
  ///
  /// In ja, this message translates to:
  /// **'システムエラーです。'**
  String get systemError;

  /// No description provided for @itemIsRequired.
  ///
  /// In ja, this message translates to:
  /// **'{item}を入力してください。'**
  String itemIsRequired(String item);

  /// No description provided for @passwordMismatch.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワードの確認の入力が一致しません。'**
  String get passwordMismatch;

  /// No description provided for @weakPassword.
  ///
  /// In ja, this message translates to:
  /// **'弱いパスワードです。'**
  String get weakPassword;

  /// No description provided for @changedPassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを変更しました。'**
  String get changedPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In ja, this message translates to:
  /// **'正しい書式のメールアドレスを入力してください。'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスまたはパスワードが間違っています。'**
  String get userDisabled;

  /// No description provided for @userNotFound.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスまたはパスワードが間違っています。'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスまたはパスワードが間違っています。'**
  String get wrongPassword;

  /// No description provided for @confirmTo.
  ///
  /// In ja, this message translates to:
  /// **'本当に{action}しますか？'**
  String confirmTo(Object action);

  /// No description provided for @currentSiteId.
  ///
  /// In ja, this message translates to:
  /// **'現在のサイトID: {site}'**
  String currentSiteId(String site);

  /// No description provided for @acceptEmail.
  ///
  /// In ja, this message translates to:
  /// **'{supportEmail} からのメールを受信できるようにしておいてください。'**
  String acceptEmail(String supportEmail);

  /// No description provided for @sendResetPasswordEmail.
  ///
  /// In ja, this message translates to:
  /// **'「Kyubiko Hub のパスワードを再設定してください」という表題のメールをお送りします。そのメールに記載したリンクを使ってパスワードを再設定してください。'**
  String get sendResetPasswordEmail;

  /// No description provided for @required.
  ///
  /// In ja, this message translates to:
  /// **'必須'**
  String get required;

  /// No description provided for @alphaNumerics.
  ///
  /// In ja, this message translates to:
  /// **'英数字'**
  String get alphaNumerics;

  /// No description provided for @lowercasesAndNumerics.
  ///
  /// In ja, this message translates to:
  /// **'半角英数字'**
  String get lowercasesAndNumerics;

  /// No description provided for @emailFormat.
  ///
  /// In ja, this message translates to:
  /// **'メールアドレスの形式'**
  String get emailFormat;

  /// No description provided for @telFormat.
  ///
  /// In ja, this message translates to:
  /// **'電話番号の形式'**
  String get telFormat;

  /// No description provided for @lengthNotLessThan.
  ///
  /// In ja, this message translates to:
  /// **'{length}文字以上'**
  String lengthNotLessThan(int length);

  /// No description provided for @notForIndividualApplication.
  ///
  /// In ja, this message translates to:
  /// **'個人で申し込む場合は不要'**
  String get notForIndividualApplication;

  /// No description provided for @address2HelperText.
  ///
  /// In ja, this message translates to:
  /// **'郵便物が届くように記載してください'**
  String get address2HelperText;

  /// No description provided for @saved.
  ///
  /// In ja, this message translates to:
  /// **'保存しました。'**
  String get saved;

  /// No description provided for @deleted.
  ///
  /// In ja, this message translates to:
  /// **'削除しました。'**
  String get deleted;

  /// No description provided for @restored.
  ///
  /// In ja, this message translates to:
  /// **'復活しました。'**
  String get restored;

  /// No description provided for @sentEmail.
  ///
  /// In ja, this message translates to:
  /// **'メールを送信しました。'**
  String get sentEmail;

  /// No description provided for @whyLogout.
  ///
  /// In ja, this message translates to:
  /// **'通常、ログアウトの操作は不要です。'**
  String get whyLogout;

  /// No description provided for @noData.
  ///
  /// In ja, this message translates to:
  /// **'表示するデータがありません'**
  String get noData;

  /// No description provided for @version.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get version;

  /// No description provided for @defaultLoadingMessage.
  ///
  /// In ja, this message translates to:
  /// **'データ受信中 ...'**
  String get defaultLoadingMessage;

  /// No description provided for @defaultErrorMessage.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get defaultErrorMessage;

  /// No description provided for @updateThisApp.
  ///
  /// In ja, this message translates to:
  /// **'アプリを更新してください'**
  String get updateThisApp;

  /// No description provided for @adminPrivRequired.
  ///
  /// In ja, this message translates to:
  /// **'管理者権限が必要です。'**
  String get adminPrivRequired;

  /// No description provided for @askAdminSiteId.
  ///
  /// In ja, this message translates to:
  /// **'サイトIDがわからない場合はサイト管理者に問い合わせてください。'**
  String get askAdminSiteId;

  /// No description provided for @askAdminHowToLogin.
  ///
  /// In ja, this message translates to:
  /// **'ログイン方法がわからない場合はサイト管理者に問い合わせてください。'**
  String get askAdminHowToLogin;

  /// No description provided for @unknown.
  ///
  /// In ja, this message translates to:
  /// **'不明'**
  String get unknown;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
