---
title: "&@演算子"
---

# `&@`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&@`演算子は1つのキーワードで全文検索を実行します。

## 構文

```sql
column &@ keyword
```

`column`は検索対象のカラムです。

`keyword`は全文検索で使うキーワードです。`text`型です。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`&@`演算子を使うと1つキーワードで全文検索できます。

```sql
SELECT * FROM memos WHERE content &@ 'engine';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (1 row)
```

複数のキーワードで検索したいときやAND/ORを使った検索をしたいときは[`&?`演算子](query-v2.html)を使います。

複数のキーワードでOR検索をしたいときは[`&@>`演算子](match-contain-v2.html)を使います。

## 参考

  * [`&?`演算子](query-v2.html)

  * [`&@>`演算子](match-contain-v2.html)
