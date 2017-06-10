---
title: "&?|演算子"
upper_level: ../
---

# `&?|`演算子

1.2.1で追加。

## 概要

1.2.1から`&?>`演算子は非推奨になりました。代わりに`&?|`演算子を使ってください。

`&?|`演算子はクエリーの配列で全文検索をします。1つ以上のクエリーがマッチすればそのレコードはマッチしたことになります。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column &?| queries
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`queries`は全文検索するクエリーの配列です。`column`の型が`text`型または`text[]`型の場合は型は`text[]`型です。`column`の型が`varchar`型の場合は型は`varchar[]`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

`queries`内の1つ以上のクエリーが`column`に対してマッチすればこの演算子は`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga.text_full_text_search_ops_v2`：`text`用

  * `pgroonga.text_array_full_text_search_ops_v2`：`text[]`用

  * `pgroonga.varchar_full_text_search_ops_v2`：`varchar`用

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

`&?|`演算子を使うと複数のクエリーで全文検索できます。

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

  * [`&?`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [Groongaのクエリーの構文][groonga-query-syntax]

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

[query-v2]:query-v2.html

[match-in-v2]:match-in-v2.html

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html
