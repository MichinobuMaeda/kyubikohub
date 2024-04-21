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

組織 `org` のグループ `gid` アカウント `uid` 、ユーザー `user`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: orgs/`org`                  |read                          |
|Firestore: orgs/`org`/prefs/profile    |read                          |
|Firestore: orgs/`org`/accounts/`uid`   |read                          |
|Firestore: orgs/`org`/users/*          |read                          |
|Firestore: orgs/`org`/users/`user`     |read, update                  |
|Firestore: orgs/`org`/groups/*         |read                          |

### 組織管理者

組織 `org` のグループ managers のアカウント `uid` 、ユーザー `user`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: orgs/`org`                  |read, update                  |
|Firestore: orgs/`org`/prefs/profile    |read, update                  |
|Firestore: orgs/`org`/prefs/*          |read, update                  |
|Firestore: orgs/`org`/accounts/!`uid`  |read, update, create, delete  |
|Firestore: orgs/`org`/users/`user`     |read, update                  |
|Firestore: orgs/`org`/users/*          |read, update, create, delete  |
|Firestore: orgs/`org`/groups/managers  |read, update                  |
|Firestore: orgs/`org`/groups/!managers |read, update, create, delete  |

### システム管理者

組織 admins のメンバー `uid`

|対象                                   |権限                          |
|---------------------------------------|------------------------------|
|Firestore: service/conf                |read, update                  |
|Firestore: orgs/admins                 |read, update                  |
|Firestore: orgs/!admins                |read, update, create, delete  |

## 検討事項

追加検討中の機能のデータを除き、無し。
