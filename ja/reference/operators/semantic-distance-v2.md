---
title: "<&@*>演算子"
upper_level: ../
---

# `<&@*>`演算子

4.0.5で追加。

まだ実験的な機能です。

## 概要

`<&@*>`演算子はテキスト間の距離を計算します。

値が小さいほど意味的に近いテキストと判断できます。

## 構文

```sql
column <&@*> pgroonga_condition(query)
```

`column`は検索対象のカラムです。型は`text`型です。

`query`は距離を計算するクエリーです。型は`text`型です。

[`pgroonga_condition`関数][condition]を使います。

[`pgroonga_condition`関数][condition]には引数がいくつかありますが、`query`のみを指定してご利用ください。

## 演算子クラス

この演算子を使うには`pgroonga_text_semantic_search_ops_v2`演算子クラスを指定する必要があります。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

INSERT INTO memos VALUES (1, 'PostgreSQL is a RDBMS.');
INSERT INTO memos VALUES (2, 'Groonga is fast full text search engine.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga.');
```

次のようにインデックスを作成します。インデックス作成については[`CREATE INDEX USING pgroonga`][create-index]をご覧ください。

```sql
CREATE INDEX pgroonga_index ON memos
 USING pgroonga (content pgroonga_text_semantic_search_ops_v2)
 WITH (plugins = 'language_model/knn',
       model = 'hf:///groonga/all-MiniLM-L6-v2-Q4_K_M-GGUF');
```

`<&@*>` 演算子を`ORDER BY`で使うと距離が近い（= 意味が近い）順にソートできます。

```sql
SELECT id, content
  FROM memos
 ORDER BY content <&@*> pgroonga_condition('What is a MySQL alternative?');
--  id |                        content                        
-- ----+-------------------------------------------------------
--   1 | PostgreSQL is a RDBMS.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga.
--   2 | Groonga is fast full text search engine.
-- (3 rows)
```

## 参考

* [`CREATE INDEX USING pgroonga`][create-index]

* [`&@*`演算子][semantic-search-v2]: セマンティックサーチ

* [`pgroonga_condition`関数][condition]

[semantic-search-v2]:semantic-search-v2.html

[create-index]:../create-index-using-pgroonga.html#semantic-search

[condition]:../functions/pgroonga-condition.html
