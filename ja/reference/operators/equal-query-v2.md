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
column &=~ (query, weights, index_name)::pgroonga_full_text_search_condition
```

1つ目の使い方は他の使い方よりもシンプルです。多くの場合は1つ目の使い方で十分です。

2つ目の使い方は検索スコアーを最適化するときに便利です。たとえば、ブログアプリケーションで「タイトルは本文よりも重要」という検索を実現できます。

2つ目の使い方は3.0.8以降で使えます。

以下は1つ目の使い方の説明です。

```sql
column &=~ query
```

`column`は検索対象のカラムです。`text[]`型か`varchar[]`型です。

`query`は等価検索のクエリーです。`text`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

以下は2つ目の使い方の説明です。

```sql
column &@~ (query, weights, index_name)::pgroonga_full_text_search_condition
```

`column`は検索対象のカラムです。`text[]`型か`varchar[]`型です。

`query`は等価検索のクエリーです。`text`型です。

現時点では`weights`は`NULL`でなければいけません。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

3.0.8以降で使えます。

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
