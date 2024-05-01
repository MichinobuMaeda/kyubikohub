# 認可

[目次](index.md) に戻る

## 実装

`firestore.rules`

## テスト

ローカルのテスト

```bash
npm run test:firestore
```

デプロイ時のテストは [配置](deployment.md) 参照。

## 仕様

### デフォルト

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore                              |権限無し                      |

### ゲスト

認証無しの利用者

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: service/conf                |read                          |

### メンバー

サイト `site` のグループ `gid` アカウント `uid` 、ユーザー `user`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: sites/`site`                  |read                          |
|Firestore: sites/`site`/prefs/profile    |read                          |
|Firestore: sites/`site`/accounts/`uid`   |read                          |
|Firestore: sites/`site`/users/*          |read                          |
|Firestore: sites/`site`/users/`user`     |read, update                  |
|Firestore: sites/`site`/groups/*         |read                          |

### サイト管理者

サイト `site` のグループ managers のアカウント `uid` 、ユーザー `user`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: sites/`site`                  |read, update                  |
|Firestore: sites/`site`/prefs/profile    |read, update                  |
|Firestore: sites/`site`/prefs/*          |read, update                  |
|Firestore: sites/`site`/accounts/!`uid`  |read, update, create, delete  |
|Firestore: sites/`site`/users/`user`     |read, update                  |
|Firestore: sites/`site`/users/*          |read, update, create, delete  |
|Firestore: sites/`site`/groups/managers  |read, update                  |
|Firestore: sites/`site`/groups/!managers |read, update, create, delete  |

### システム管理者

サイト admins のメンバー `uid`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: service/conf                |read, update                  |
|Firestore: sites/admins                 |read, update                  |
|Firestore: sites/!admins                |read, update, create, delete  |

## 検討事項

追加検討中の機能のデータを除き、無し。
