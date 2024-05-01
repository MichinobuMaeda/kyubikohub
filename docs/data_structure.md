# データ構造

[目次](index.md) に戻る

```mermaid
classDiagram
    class Conf
    Org *-- Account
    Org *-- User
    Org *-- Group
    Group o-- User
    User o-- Account
    Account o-- AuthenticationUser
    Group <|-- Managers
```

## collection: `service`

アプリの共通設定。
唯一の `service/conf` ドキュメントを持つ。

```mermaid
classDiagram
    class Conf
    Conf : +Integer dataVersion
    Conf : +String uiVersion
    Conf : +String policy
```

- `dataVersion`: このアプリのデータのバージョン。配置時に設定する。
- `uiVersion`: このアプリのUIのバージョン。配置時に設定し、UIのアップデートの要否の判定に用いる。
- `policy`: このアプリのプライバシーポリシーとして、システム管理者が設定する。

## collection: `sites`

このアプリを利用するサイト。
サイトの配下にそのサイトの利用者やグループを持つ。

```mermaid
classDiagram
    class Org
    Org : +String id
    Org : +String name
    Org : +collection accounts
    Org : +collection users
    Org : +collection groups
```

`id: admins` にはこのアプリを管理する特権を持つメンバー「システム管理者」を格納する。

## collection: `sites/[id]/accounts`

サイトのメンバーのアカウント。
通常、アプリのUIからは見えない属性を持つ。
1人のメンバーがサイト内の複数のアカウントを持つことができる。
1人のメンバーが異なるサイトのアカウントを持つことができる。

```mermaid
classDiagram
    class Account
    Account : +String id
    Account : +String user
```

- `id`: Firebase Authentication の `uid` と同じもの。
- `user`: サイトのユーザの `id` 。

## collection: `sites/[id]/users`

サイトのユーザ。
サイト内に共有する属性を持つ。
1人のメンバーは、サイト内では1個のユーザで表現される前提。
1人のメンバーが、異なるサイトのユーザとなることができる。

```mermaid
classDiagram
    class User
    User : +String id
    User : +String name
    User : +String email
```

## collection: `sites/[id]/groups`

サイトのグループ。

```mermaid
classDiagram
    class Group
    Group : +String id
    Group : +String name
    Group : +Array<String> users
```

- `users`: グループに所属するユーザの `id` の配列。

`id: managers` にはそのサイトを管理する特権を持つメンバー「サイト管理者」を格納する。

## 検討事項

追加検討中の機能のデータを除き、無し。
