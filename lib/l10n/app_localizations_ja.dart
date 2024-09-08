import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get title => 'Kyubiko Hub';

  @override
  String get home => 'ホーム';

  @override
  String get me => '設定';

  @override
  String get about => '情報';

  @override
  String get administration => '管理';

  @override
  String get admin => 'アプリ管理者';

  @override
  String get manager => 'サイト管理者';

  @override
  String get notices => 'お知らせ';

  @override
  String get preferences => 'アプリの設定';

  @override
  String get accountSettings => 'アカウントの設定';

  @override
  String get siteSettings => 'サイトの設定';

  @override
  String get siteAdmin => 'サイトの管理';

  @override
  String get appAdmin => 'アプリの管理';

  @override
  String get guidance => 'ご案内';

  @override
  String get aboutTheApp => 'アプリについて';

  @override
  String get forGuests => 'ログイン前の案内';

  @override
  String get forMembers => 'ログイン後の案内';

  @override
  String get forManagers => 'サイト管理者向けの案内';

  @override
  String get forSubscriber => '利用申込みの案内';

  @override
  String get licenses => 'ライセンス';

  @override
  String get users => 'メンバー';

  @override
  String get groups => 'グループ';

  @override
  String get sites => 'サイト';

  @override
  String get siteId => 'サイトID';

  @override
  String get siteName => 'サイト名';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get curPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get conPassword => '新しいパスワード（確認）';

  @override
  String get allMembers => 'すべてのメンバー';

  @override
  String get id => 'ID';

  @override
  String get name => '名称';

  @override
  String get fullName => '氏名';

  @override
  String get displayName => '表示名';

  @override
  String get groupMembership => '所属グループ';

  @override
  String get operationLog => '操作ログ';

  @override
  String get sample => 'サンプル';

  @override
  String get subscriber => '利用者';

  @override
  String get tel => '電話番号';

  @override
  String get address => '住所';

  @override
  String get zip => '郵便番号';

  @override
  String get prefecture => '都道府県';

  @override
  String get city => '市区町村';

  @override
  String get bldg => '建物名・部屋番号';

  @override
  String get purposeSubscription => '利用の目的';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get copy => 'コピー';

  @override
  String get edit => '編集';

  @override
  String get update => '更新';

  @override
  String get add => '新規追加';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get restore => '復活';

  @override
  String get close => '閉じる';

  @override
  String get selectSite => 'サイトを選択する';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get resetPassword => 'パスワード再設定';

  @override
  String get forgetYourPassword => 'パスワードを忘れた場合';

  @override
  String get send => '送信';

  @override
  String get goBack => '戻る';

  @override
  String get warning => '警告';

  @override
  String get showMore => '続きを見る';

  @override
  String get subscribe => '利用申込み';

  @override
  String confirmTo(Object action) {
    return '本当に$actionしますか？';
  }

  @override
  String currentSiteId(String site) {
    return '現在のサイトID: $site';
  }

  @override
  String acceptEmail(String supportEmail) {
    return '$supportEmail からのメールを受信できるようにしておいてください。';
  }

  @override
  String get sendResetPasswordEmail => '「Kyubiko Hub のパスワードを再設定してください」という表題のメールをお送りします。そのメールに記載したリンクを使ってパスワードを再設定してください。';

  @override
  String errorOf(String item) {
    return 'エラー: $item';
  }

  @override
  String get required => '必須';

  @override
  String get alphaNumerics => '半角英数字';

  @override
  String get lCasesAndNumerics => '半角の小文字と数字';

  @override
  String get uCasesAndNumerics => '半角の大文字と数字';

  @override
  String get emailFormat => 'メールアドレスの形式';

  @override
  String get telFormat => '電話番号の形式';

  @override
  String get zipFormat => '郵便番号の形式';

  @override
  String lengthNotMoreThan(int length) {
    return '$length文字以下';
  }

  @override
  String lengthNotLessThan(int length) {
    return '$length文字以上';
  }

  @override
  String get authFailed => '認証に失敗しました。';

  @override
  String systemError(String message) {
    return 'システムエラー: $message';
  }

  @override
  String itemIsRequired(String item) {
    return '$itemを入力してください。';
  }

  @override
  String itemIsInvalid(String item) {
    return '$itemを正しい書式で入力してください。';
  }

  @override
  String itemIsDuplicated(String item) {
    return '$itemが重複しています。';
  }

  @override
  String get passwordMismatch => '新しいパスワードの確認の入力が一致しません。';

  @override
  String get weakPassword => '弱いパスワードです。';

  @override
  String get changedPassword => 'パスワードを変更しました。';

  @override
  String get userDisabled => 'メールアドレスまたはパスワードが間違っています。';

  @override
  String get userNotFound => 'メールアドレスまたはパスワードが間違っています。';

  @override
  String get wrongPassword => 'メールアドレスまたはパスワードが間違っています。';

  @override
  String get notForIndividualApplication => '個人で申し込む場合は不要';

  @override
  String get address2HelperText => '郵便物が届くように記載してください';

  @override
  String tooManyRequestsFrom(String from) {
    return '$from からのリクエストが多すぎます。';
  }

  @override
  String get saved => '保存しました。';

  @override
  String get deleted => '削除しました。';

  @override
  String get restored => '復活しました。';

  @override
  String get sentEmail => 'メールを送信しました。';

  @override
  String get whyLogout => '通常、ログアウトの操作は不要です。';

  @override
  String get noData => '表示するデータがありません';

  @override
  String get version => 'バージョン';

  @override
  String get defaultLoadingMessage => 'データ受信中 ...';

  @override
  String get defaultErrorMessage => 'エラー';

  @override
  String get updateThisApp => 'アプリを更新してください';

  @override
  String get adminPrivRequired => '管理者権限が必要です。';

  @override
  String get askAdminSiteId => 'サイトIDがわからない場合はサイト管理者に問い合わせてください。';

  @override
  String get askAdminHowToLogin => 'ログイン方法がわからない場合はサイト管理者に問い合わせてください。';

  @override
  String get unknown => '不明';
}
