---
title: "@@ operator"
layout: en
---

# `@@` operator

`キーワード1 OR キーワード2`のようにクエリー構文を使って全文検索をする
ときは`@@`演算子を使います。

```sql
SELECT * FROM memos WHERE content @@ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 行)
```

クエリー構文の詳細は
[Groognaのドキュメント](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)
を参照してください。

ただし、`カラム名:@キーワード`というように「`カラム名:`」から始まる構
文は無効にしてあります。そのため、前方一致検索をしたい場合は「`カラム
名:^値`」という構文は使えず、「`値*`」という構文だけが使えます。

注意してください。

