# 開発手順

[目次](index.md) に戻る

## 前提

- nvm
- fvm
- pyenv
- Java >= 11
- curl
- genhtml (optional)

## ビルドとテスト

```bash
git clone git@github.com:MichinobuMaeda/kyubikohub.git
cd kyubikohub
npm i
cd functions
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
cd ..
fvm flutter pub get
npm test && genhtml coverage/lcov.info -o coverage
npm start
fvm dart run build_runner watch
```

`genhtml` が無い場合は `&& genhtml coverage/lcov.info -o coverage` を省略する。

カバレッジの HTML の出力先

- Functions: `functions/htmlcov/index.html`
- Flutter: `coverage/index.html`
