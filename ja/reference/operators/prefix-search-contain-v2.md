---
title: "&^>演算子"
---

# `&^>`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&^>`演算子は前方一致検索を実行します。

前方一致検索は入力補完機能を実現する場合に便利です。

## 構文

```sql
column &^> prefix
```

`column`は検索対象のカラムです。`text[]`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`のどれかの値が`prefix`から始まっていれば`true`を返します。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  aliases text[]
);

CREATE INDEX pgroonga_tag_aliases_index ON tags
  USING pgroonga (aliases pgroonga.text_array_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL', ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES ('Groonga',    ARRAY['Groonga', 'grn']);
INSERT INTO tags VALUES ('PGroonga',   ARRAY['PGroonga', 'pgrn']);
```

`&^>`演算子を使うと指定したプレフィックスで前方一致検索を実行できます。

```sql
SELECT * FROM tags WHERE aliases &^> 'pg';
--     name    |     aliases     
-- ------------+-----------------
--  PostgreSQL | {PostgreSQL,PG}
--  PGroonga   | {PGroonga,pgrn}
-- (2 rows)
```

## 参考

  * [`&^`演算子](prefix-search-v2.html)

  * [`&^~`演算子](prefix-rk-search-v2.html)

  * [`&^~>`演算子](prefix-rk-search-contain-v2.html)
