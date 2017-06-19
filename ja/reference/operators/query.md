---
title: "jsonb型以外の型用の@@演算子"
upper_level: ../
---

# `jsonb`型以外の型用の`@@`演算子

## 概要

この演算子は1.2.0から非推奨です。代わりに[`&?`演算子][query-v2]を使ってください。

`@@`演算子はクエリーを使って全文検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column @@ query
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`query`は全文検索用のクエリーです。`column`が`text`型または`text[]`型なら`query`は`text`型です。`column`が`varchar`型なら`query`は`varchar`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga.text_full_text_search_ops`：`text`のデフォルト

  * `pgroonga.text_array_full_text_search_ops`：`text[]`のデフォルト

  * `pgroonga.varchar_full_text_search_ops`：`varchar`用

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

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`@@`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して全文検索できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

```sql
SELECT * FROM memos WHERE content @@ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 rows)
```

クエリーの構文の詳細は[Groongaのドキュメント][groonga-query-syntax]を参照してください。

`カラム名:@キーワード`のように`カラム名:`から始まる構文を使うことはできません。これはPGroongaで無効にしています。

前方一致検索のために`カラム名:^値`という構文を使うことができません。前方一致検索には`値*`を使ってください。

## シーケンシャルスキャン

TODO: Describe about `SET search_path = "$user",public,pgroonga,pg_catalog;`.

## 参考

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [Groongaのクエリーの構文][groonga-query-syntax]

[match-v2]:match-v2.html
[query-v2]:query-v2.html
[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html
