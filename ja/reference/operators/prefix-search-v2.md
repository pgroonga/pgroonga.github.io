---
title: "&^演算子"
upper_level: ../
---

# `&^`演算子

1.2.1で追加。

## 概要

1.2.1から`text[]`用の`&^>`演算子は非推奨になりました。代わりに`&^`演算子を使ってください。

`&^`演算子は前方一致検索を実行します。

前方一致検索は入力補完機能を実現する場合に便利です。

## 構文

```sql
column &^ prefix
column &^ (prefix, NULL, index_name)::pgroonga_full_text_search_condition
```

多くの場合は1つ目の使い方で十分です。

2つ目の使い方はPGroongaのインデックスが使用されるかどうかに関わらず、カスタマイズしたノーマライザーを使用するためのものです。
2つ目の使い方は、2.4.6から使えます。

以下は1つ目の使い方の説明です。

```sql
column &^ prefix
```

`column`は検索対象のカラムです。型は`text`型か`text[]`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値が`prefix`から始まっていれば`true`を返します。

以下は2つ目の使い方の説明です。

```sql
column &^ (prefix, NULL, index_name)::pgroonga_full_text_search_condition
```

`column`は検索対象のカラムです。型は`text`型か`varchar`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

2つ目の引数はNULLのみ設定されます。この構文は検索スコアーの最適化をするためのものでは無いためです。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

これはシーケンシャルサーチのときにもPGroongaのインデックスに指定した検索オプションを使えるようにするために使われます。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_term_search_ops_v2`：`text`用

  * `pgroonga_text_array_term_search_ops_v2`：`text[]`用

  * `pgroonga_varchar_term_search_ops_v2`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2);
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

以下のように前方一致検索でカスタマイズしたノーマライザーを使えます。

```sql
CREATE TABLE tags (
  name text
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');
```

```sql
INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');
```

PGroongaのインデックスが使用されるかどうかに関わらず、カスタマイズしたノーマライザーで前方一致検索ができます。

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &^ ('-p_G', NULL, 'pgrn_index')::pgroonga_full_text_search_condition;
QUERY PLAN
Seq Scan on tags
  Filter: (name &^ '(-p_G,,pgrn_index)'::pgroonga_full_text_search_condition)
(2 rows)

SELECT name
  FROM tags
 WHERE name &^ ('-p_G', NULL, 'pgrn_index')::pgroonga_full_text_search_condition;
   name    
-----------
 PGroonga
 pglogical
(2 rows)
```

## 参考

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`!&^|`演算子][not-prefix-search-in-v2]：プレフィックスの配列での否定前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[not-prefix-search-in-v2]:not-prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
