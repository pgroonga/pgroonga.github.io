---
title: ユーザー
---

# ユーザー

以下はPGroongaユーザーです。

## Zulip

[Zulip](https://zulip.org/)はパワフルなオープンソースのグループチャットアプリケーションです。全言語対応の全文検索機能を実現するためにPGroongaを使っています。なぜなら、[PostgreSQL組み込みの全文検索機能]({{ site.postgresql_doc_base_url.ja }}/textsearch.html)は同時に1つの言語しかサポートできないからです。PGroongaは同時にすべての言語をサポートできます。

## waja

ECサイト[waja](https://www.waja.co.jp/)のキーワード検索エンジンに採用しました。

PGroongaを採用した主な理由は次の通りです。

  * 既存の検索処理と整合性を取りやすい

  * インデックスの追加のみで全文検索機能を付与できる

  * 十分に高速である

同義語検索、オートコンプリート機能も備えており、運用でデータベースをメンテナンスすることで機能改善する作りになっています。

[開発者のブログ](https://www.waja.co.jp/corp/6359)も読んでみてください。

## （サービス名を教えてください）

（サービスの説明、どのようにPGroongaを使っているか、どうしてPGroongaを選んだかを教えてください。）

↑のことを [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) で書いて教えてください。英語のページですが日本語で書いても構いません。
