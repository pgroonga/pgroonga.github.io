---
title: "jsonb型以外の型用の@@演算子"
upper_level: ../
---

# `jsonb`型以外の型用の`@@`演算子

## 概要

1.2.0からこの演算子は非推奨になりました。代わりに[`&?`演算子](query-v2.html)を使ってください。

`@@`演算子はクエリーを使って全文検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column @@ query
```

`column`は検索対象のカラムです。

`query`は全文検索で使うクエリーです。`text`型です。

`query`では[Groongaのクエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を使います。

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

クエリーの構文の詳細は[Groongaのドキュメント](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を参照してください。

`カラム名:@キーワード`のように`カラム名:`から始まる構文を使うことはできません。これはPGroongaで無効にしています。

前方一致検索のために`カラム名:^値`という構文を使うことができません。前方一致検索には`値*`を使ってください。

## シーケンシャルスキャン

TODO: Describe about `SET search_path = "$user",public,pgroonga,pg_catalog;`.

## 参考

  * [`&@`演算子](match-v2.html)

  * [`%%`演算子](match.html)

    * 1.2.0から非推奨になりました。代わりに[`&@`演算子](match-v2.html)を使ってください。

  * [Groongaのクエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)
