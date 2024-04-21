# テストデータ

[目次](index.md) に戻る

Firebase Local Emulator Suite によるテストのために、以下のテストデータを作成する。

## 概要

- 組織: Administrators
    - グループ: Managers
        - メンバー: Primary user
- 組織: Test
    - グループ: Managers
        - メンバー: Manager
    - グループ: Group 01
        - メンバー: Manager
        - メンバー: User 01
        - メンバー: User 02
    - グループ: Group 02
        - メンバー: User 02

## Authentication

- uid: `primary_id`
    - email: "primary\@example.com"
    - password: "password"
- uid: `manager_id`
    - email: "manager\@example.com"
    - password: "password"
- uid: `user01_id`
    - email: "user01\@example.com"
    - password: "password"
- uid: `user02_id`
    - email: "user02\@example.com"
    - password: "password"

## Firestore

- collection: `service`
    - doc: `conf`
        - dataVersion: 1
        - uiVersion: "for test"
        - policy: "## Privacy policy"
- collection: `orgs`
    - doc: `admins`
        - name: "Administrators"
        - collection: `accounts`
            - doc: `primary_id`
                - user: `primary's user id`
        - collection: `users`
            - doc: `primary's user id`
                - name: "Primary user"
                - email: "primary\@example.com"
        - collection: `groups`
            - doc: `managers`
                - name: "Managers"
                - users
                    - `primary's user id`
    - test
        -name: "Test"
        - collection: `accounts`
            - doc: `manager_id`
                - user: `manager's user id`
            - doc: `user01_id`
                - user: `user01's user id`
            - doc: `user02_id`
                - user: `user02's user id`
        - collection: `users`
            - doc: `manager's user id`
                - name: "Manager"
                - email: "manager\@example.com"
            - doc: `user01's user id`
                - name: "User 01"
                - email: "user01\@example.com"
            - doc: `user02's user id`
                - name: "User 02"
                - email: "user02\@example.com"
        - collection: `groups`
            - doc: `managers`
                - name: "Managers"
                - users
                    - `manager's user id`
            - doc: `group01`
                - name: "Group 01"
                - users
                    - `user01's user id`
                    - `user02's user id`
            - doc: `group02`
                - name: "Group 02"
                - users
                    - `user02's user id`

## 検討事項

無し
