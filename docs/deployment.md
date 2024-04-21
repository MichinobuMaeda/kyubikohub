# 配置

[目次](index.md) に戻る

## 概要

デプロイメントの基盤として GitHub Actions を用いる。

Web版UIは Firebase Hosting にデプロイする。

デプロイメントは以下の2種類とする。

- Pull request 時
- main マージ時

## 実装

- `.github/workflows/firebase-hosting-pull-request.yml`
- `.github/workflows/firebase-hosting-merge.yml`

## セキュリティ

以下のものは GitHub Actions の Secrets で設定する。

- Firebase の接続情報
- 初回デプロイ時に作成するシステム管理者などのアカウント

## デプロイ時のテスト

Pull request 時には以下のものを対象とするテストを実施する。

- Flutter

main マージ時には以下のものを対象とするテストを実施する。また、そのテストのカバレッジを記録する。

- Firebase Functions
- Flutter

main マージ時に `firestore.rules` が変更されている場合は、以下のものを対象とするテストを実施する。

- Firestore rules

## データ移行

データ移行の要否は Firestore の `service/conf` の `dataVersion` の値で判定する。
データ移行完了時に `dataVersion` の値を更新する。

データ移行のトリガーは Firestore の `service/deployment` の削除とする。

## UI更新

UIのバージョンは `pubspec.yaml` の `version` とする。
デプロイ時にUIのバージョンを `service/conf` の `uiVersion` に格納する。

## 検討事項

- Web版以外のUIのデプロイ
