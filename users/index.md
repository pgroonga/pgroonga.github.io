---
title: Users
---

# Users

Here are PGroonga users.

## Zulip

[Zulip](https://zulip.org/) is a powerful open source group chat. It uses PGroonga to implement all languages support full text search. Because [PostgreSQL built-in full text search feature]({{ site.postgresql_doc_base_url.en }}/textsearch.html) supports only one language at the same time. PGroonga can support all languages at the same time.

## waja

ECサイト[waja](https://www.waja.co.jp/) のキーワード検索エンジンに採用しました。
既存の検索処理と整合性を取りやすかったこと、インデックスの追加のみで全文検索機能を付与できること、十分に高速であること、が主な採用理由です。
同義語検索、オートコンプリート機能も備えており、運用でデータベースをメンテナンスすることで機能改善する作りになっています。

## (Send us your service name)

(Send us your service description, how do you use PGroonga and why did you choose PGroonga.)

You can send your use case from [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) .
