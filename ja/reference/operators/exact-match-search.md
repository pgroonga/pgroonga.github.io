---
title: "&= 演算子"
upper_level: ../
---

# `&=` 演算子

2.4.6 で追加

## 概要

`&=` 演算子は完全一致検索を実行します。

## 構文

```sql
column &= keyword
column &= (keyword, NULL, index_name)::pgroonga_full_text_search_condition
```

1つ目の構文は通常使用しません。

2つ目の構文はPGroongaのインデックスが使用されるかどうかに関わらず、カスタマイズしたノーマライザーを使用するためのものです。

以下は1つ目の使い方の説明です。

```sql
column &= keyword
```

`column`は検索対象のカラムです。型は`text`型か`varchar`型です。

`keyword` は完全一致検索で使うキーワードです。 `text` 型です。

`column` と `keyword` が完全に一致した時に `true` を返します。

以下は2つ目の使い方の説明です。

```sql
column &= (keyword, NULL, index_name)::pgroonga_full_text_search_condition
```

`column`は検索対象のカラムです。型は`text`型か`varchar`型です。

`keyword` は完全一致検索で使うキーワードです。 `text` 型です。

2つ目の引数はNULLのみ設定されます。この構文は検索スコアーの最適化をするためのものでは無いためです。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_term_search_ops_v2`：`text`用

  * `pgroonga_varchar_term_search_ops_v2`：`varchar`用

## 使い方

以下のようにPostgreSQLがPGroongaのインデックスを使う場合は、 `&=` 演算子はカスタマイズしたノーマライザーを使えます。

したがって、 以下の例のようにPostgreSQLは `gr-oonga` のような検索キーワードで2つのレコード(Groonga と groonga)を返します。

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
QUERY PLAN
Bitmap Heap Scan on tags
   Recheck Cond: (name &= 'gr-oonga'::text)
   ->  Bitmap Index Scan on pgrn_index
         Index Cond: (name &= 'gr-oonga'::text)
(4 rows)

SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
--    name    
-- -----------
--  PGroonga
--  pglogical
-- (2 rows)
```

しかし、PostgreSQLがPGroongaのインデックスを使わない場合は、 `&=` 演算子はカスタマイズしたノーマライザーを使えません。

したがって、 以下の例のようにPostgreSQLは `gr-oonga` のような検索キーワードではレコードを返しません。

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
QUERY PLAN
Seq Scan on tags
  Filter: (name &= 'gr-oonga'::text)
(2 rows)

SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
 name 
------
(0 rows)
```

一方、2つ目の構文を使う場合は、PGroongaのインデックスを使うかどうかに関わらず、完全一致検索でカスタマイズしたノーマライザーを使えます。

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2);

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= ('groonga', NULL, 'pgrn_index')::pgroonga_full_text_search_condition
 ORDER BY id;
QUERY PLAN
Sort
  Sort Key: id
  ->  Seq Scan on tags
        Filter: (name &= '(groonga,,pgrn_index)'::pgroonga_full_text_search_condition)
(4 rows)

SELECT name
  FROM tags
 WHERE name &= ('groonga', NULL, 'pgrn_index')::pgroonga_full_text_search_condition
 ORDER BY id;
  name   
---------
 Groonga
 groonga
(2 rows)
```
