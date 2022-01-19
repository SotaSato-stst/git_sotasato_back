# Hojokin Dock Scraping

## 概要
最新の補助金情報をスクレイピングで取得するためのアプリケーションです。

## 環境構築

### ライブラリのインストール
`pip-tools`を使います。  
`pip-sync`コマンドで、必要なライブラリをインストールします。  
新しいライブラリを追加したい場合、`requirements.in`に追記したのち、 `pip-compile` を使います。  

### Credentialsの設置
Google Cloud Storageへのアップロードテストを行うには、アクセスキーファイル `scraping/gcloud-account.json` を設置する必要があります。  
ファイルは管理者に依頼して作成してもらってください。  

## 構成
### main
全体の処理を担う関数です。
はじめに必要な初期設定を行います。
その後、controllerに対してスクレイピング処理実行を指示します。

### controller
スクレイピング処理の実行していきます。
各スクリプトファイルから受け取ったデータを、Google Cloud Storageにアップロードします。

### scripts/
サイト毎の構造に最適化されたデータ取得処理を実行します。

## デプロイ
※追記
