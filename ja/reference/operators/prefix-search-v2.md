---
title: "&^演算子"
upper_level: ../
---

# `&^`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&^`演算子は前方一致検索を実行します。

前方一致検索は入力補完機能を実現する場合に便利です。

## 構文

```sql
column &^ prefix
```

`column`は検索対象のカラムです。`text`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値が`prefix`から始まっていれば`true`を返します。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga.text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');
```

`&^`演算子を使うと指定したプレフィックスで前方一致検索を実行できます。

```sql
SELECT * FROM tags WHERE name &^ 'pg';
--    name    
-- -----------
--  PGroonga
--  pglogical
-- (2 rows)
```

## 参考

  * [`&^?`演算子](prefix-rk-search-v2.html)
