# 開発手順

[目次](index.md) に戻る

## 必要なもの

- git
- nvm または `.nvmrc` に記載したバージョンの Node.js
- fvm または `.fvmrc` に記載したバージョンの flutter
- pyenv または `.python-version` に記載したバージョンの Python
- JRE (Java Runtime Environment) >= 11
- curl
- genhtml (optional)

nvm, fvm, pyenv でそれぞれ必要なバージョンをインストールする。

JRE の代わりに JDK でもよい。

編集したコードを push する場合は GitHub のアカウントを作成し、
ローカルの環境で以下の設定を済ませて、管理者に連絡すること。

```bash
git config --global user.name "あなたの名前"
git config --global user.email あなたのメールアドレス
```

## ビルドとテスト

以下の出力は 2024-04-30 時点のもの。最新のソースでは、それぞれのコマンドのバージョンが上がり、テスト数が増えている可能性がある。

```bash
$ git clone git@github.com:MichinobuMaeda/kyubikohub.git
$ cd kyubikohub
$ node --version
v18.19.1
$ python --version
Python 3.11.8
$ java --version
openjdk 21.0.2 2024-01-16
 ... ...
$ fvm flutter --version
Flutter 3.19.6 ...
 ... ...
$ npm i
$ cd functions
$ python -m venv venv
$ . venv/bin/activate
$ pip install -r requirements.txt
$ cd ..
$ fvm flutter pub get
$ npm test && genhtml coverage/lcov.info -o coverage
 ... ...
----------------------------------------------------------------------
Ran 16 tests in 2.030s

 OK
Wrote LCOV report to coverage.lcov
Wrote HTML report to htmlcov/index.html
 ... ...
Test Suites: 5 passed, 5 total
Tests:       214 passed, 214 total
Snapshots:   0 total
Time:        3.773 s, estimated 14 s
Ran all test suites matching /test/i.

> kyubikohub@1.0.0 test:ui
> fvm flutter test --coverage

00:02 +2: All tests passed!

Reading tracefile coverage/lcov.info.
 ... ...
$ npm start
$ fvm dart run build_runner watch
```

`genhtml` が無い場合は `&& genhtml coverage/lcov.info -o coverage` を省略する。
`genhtml` による HTML 出力の代わりに VS Code のプラグイン Coverage Gutters 等でカバレッジの詳細を参照すること。

`npm test` のテストをパスできない場合、環境に何らかの問題がある。

カバレッジの HTML の出力先

- Functions: `functions/htmlcov/index.html`
- Flutter: `coverage/index.html`
