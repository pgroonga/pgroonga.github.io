---
title: "jsonb型以外の型用の&?>演算子"
layout: ja
---

# `jsonb`型以外の型用の`&?>`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&?>`演算子はクエリーの配列で全文検索を実行します。1つ以上のクエリーがマッチすればそのレコードはマッチしたことになります。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column &?> queries
```

`column`は検索対象のカラムです。

`queries`は全文検索するクエリーの配列です。`text[]`型です。

`queries`内の1つ以上のクエリーが`column`に対してマッチすればこの演算子は`true`を返します。

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

`&?>`演算子を使うと複数のクエリーで全文検索を実行できます。

```sql
SELECT * FROM memos WHERE content &?> ARRAY['Groonga 全文検索', 'PostgreSQL -PGroonga'];
--  id |                          content                           
-- ----+------------------------------------------------------------
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (2 rows)
```

`Groonga 全文検索`クエリーは`id`が`2`のレコードにマッチします。

`PostgreSQL -PGroonga`クエリーは`id`が`1`のレコードにマッチします。

## 参考

  * [`&?`演算子](query-v2.html)

  * [Groongaのクエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)

  * [`&@>`演算子](match-contain-v2.html)
