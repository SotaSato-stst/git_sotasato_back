# Hojokin Dock Scraping

## 概要
最新の補助金情報をスクレイピングで取得するためのアプリケーションです。

## 環境構築

```
$ brew install yarn
$ yarn install
$ yarn dev
```

### story bookの活用
コンポーネント管理をしながらUIの開発ができる。（再利用するUIを修正しやすくするためのデバッグ機能。）

```
$ yarn nuxt storybook
```

### エディタの設定
vscodeのsettings.jsonにて以下の箇所を追加すると、ファイル保存時に自動でlint修正

```diff
{
+  "editor.codeActionsOnSave": {
+      "source.fixAll.eslint": true,
+      "source.fixAll.stylelint": true
+  },
}
```

### UIライブラリの使用
Element UIを使用しています。  
https://element.eleme.io/#/en-US/component/quickstart  
一通りコンポーネントの種類を把握してみてください。

### Credentialsの設置
※追記

## 構成
※追記

## デプロイ
※追記
