# README
 Ruby, Railsで学習した内容のアウトプットのため、Qiita風の記事作成アプリを想定し作成しました。
 ※自身ではバックエンド部分の実装を行い、フロントエンド部分は用意されていたものを使用してつなぎ合わせました。

# 動作環境
- Ruby: 3.1.3
- Rails: 6.1.7.1
- Node 14.20.0
- Vue.js: 2.6.11
- DB: PostgreSQL

# 機能一覧
- ユーザー登録、ログイン機能（devise_token_auth）
- 記事一覧取得機能
- 記事投稿機能
  - 本番記事投稿
  - 下書き記事投稿
- マイページ機能
- テストコード実装(RSpec)
- CIの導入(GitHub Actions)
  - Githubへpush時、Rspec及びRubocopが自動で実行

# ドキュメント
作業内容の確認や自身の考えていることの言語化を目的に、
本APIの実装過程をドキュメントに取りまとめました。

https://thundering-bladder-8d0.notion.site/WonderfulEditor-6857d111f6d14d1d99b313f55380ddd9?pvs=4
