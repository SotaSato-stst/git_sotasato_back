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
コンポーネント管理をしながらUIの開発ができます。（再利用するUIを修正しやすくするためのデバッグ機能。）

```
$ yarn nuxt storybook
```

### エディタの設定
vscodeのsettings.jsonにて以下の箇所を追加すると、ファイル保存時に自動でlint修正をしてくれます。

```diff
{
+  "editor.codeActionsOnSave": {
+      "source.fixAll.eslint": true,
+      "source.fixAll.stylelint": true
+  },
}
```

### Credentialsの設置
firebaseでアカウントのログイン機構を実現しています。  

まずはfirebaseでローカル環境専用のプロジェクトを作成します。  
https://console.firebase.google.com  
プロジェクト名の例: `hojokin-dock-local` など  
※アナリティクスなどの設定はしなくてよい  

次に、 `Authentication` から「メール / パスワード」のプロバイダを追加します。  
ここでテストユーザーを1つ作成しておきます。メールアドレスは存在しなくても構いません。  
※ここで作成したテストユーザーをapi_serverの環境変数(.envファイル)に設定しておくと、フロントとサーバーの疎通をテストできます。  

次に、 :gear: の設定画面から、「マイアプリ」にてWebアプリを追加します。  
アプリのニックネームの例: `web_front_local` など  
作成したマイアプリのfirebaseConfigを確認します。（ `apiKey` や `projectId` など）  

次に、以下のコマンドで `.env` というファイルを作成します。  

```
$ cp .env.sample .env
```

このファイルの中身に、先程のfirebaseConfigの情報を記入します。  
設定が終わってから、yarn devをしなおします。  

### UIライブラリの使用
Element UIを使用しています。  
https://element.eleme.io/#/en-US/component/quickstart  
一通りコンポーネントの種類を把握してみてください。

## 構成
※追記

## デプロイ
※追記
