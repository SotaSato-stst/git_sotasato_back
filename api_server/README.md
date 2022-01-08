# Hojokin Dock API Server

## 概要
補助金ドックのバックエンドアプリケーションであるAPI Serverです。

## 環境構築
```
$ rbenv install 3.0.3
$ gem install bundler -v 2.2.33
$ brew install mysql2
$ bundle install
$ bundle exec rails db:create
$ bundle exec rails db:migrate
$ bundle exec rails db:test:prepare
$ bundle exec rspec spec/
```

すべてのテストが通れば、環境構築の完了です。  

### 初期データの作成
```
$ bundle exec rails db:seed
```

rails consoleで、 `Supplier.last` などのレコードが存在していれば成功です。  

### 環境変数の設置
`.env` という名前のファイルを `api_server` 以下に配置し、環境変数を与えます。  
`.env.sample` に環境変数の一覧があります。

## APIドキュメントについて
1つ上のディレクトリ `openapi/schema.yml` にて定義されています。  
rspecの `spec/requests/` 内ファイルの `assert_response_schema_confirm` では、APIスキーマが定義と合っているかのテストを行っています。  

### Swagger Editor
https://editor.swagger.io/  
APIスキーマファイル(schema.yml)の内容を貼り付けて、API定義をUIでわかりやすく確認できます。  

### Postman Agent
https://www.postman.com/downloads/  
APIをデバッグする際に便利です。  

## デプロイ
※追記
