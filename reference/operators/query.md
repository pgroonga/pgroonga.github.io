---
title: "@@ operator for non jsonb types"
layout: en
---

# `@@` operator for non `jsonb` types

You can do full text search with multiple keywords by `@@` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

```sql
SELECT * FROM memos WHERE content @@ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 行)
```

See [Groogna document](http://groonga.org/docs/reference/grn_expr/query_syntax.html) for query syntax details.

Note that you can't use syntax that starts with `COLUMN_NAME:` like `COLUMN_NAME:@KEYWORD`. It's disabled in PGroonga.

You can't use `COLUMN_NAME:^VALUE` for prefix search. You need to use `VALUE*` for prefix search.

