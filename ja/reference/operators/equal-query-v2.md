---
title: "&=~演算子"
upper_level: ../
---

# `&=~`演算子

3.0.0で追加。

## 概要

`&=~`演算子はクエリーを使って等価検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。`キーワード1 キーワード2`と書くとAND検索できます。`キーワード1 -キーワード2`と書くとNOT検索できます。

## 構文

使い方は1つです。

```sql
column &=~ query
```

`column`は検索対象のカラムです。`text[]`型か`varchar[]`型です。

`query`は等価検索のクエリーです。`text`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_array_term_search_ops_v2`: Default for `text[]`

  * `pgroonga_varchar_array_term_search_ops_v2`: Default for `carchar[]`

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  id integer,
  names text[]
);

CREATE INDEX pgroonga_tag_names_index ON tags
 USING pgroonga (names pgroonga_text_array_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES (1, ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES (2, ARRAY['Groonga', 'grn', 'groonga']);
INSERT INTO tags VALUES (3, ARRAY['PGroonga', 'pgrn', 'SQL']);
```

`&=~`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して等価できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

```sql
SELECT * FROM tags WHERE names &=~ 'grn OR sql';
--  id |         names         
-- ----+-----------------------
--   2 | {Groonga,grn,groonga}
--   3 | {PGroonga,pgrn,SQL}
-- (2 rows)
```

## 参考

  * [`@>`演算子][contain-array]：配列を使った包含検索


  * [Groongaのクエリーの構文][groonga-query-syntax]

[contain-array]:contain-array.html

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html
