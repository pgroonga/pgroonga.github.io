---
title: "&@*演算子（セマンティックサーチ）"
upper_level: ../
---

# `&@*`演算子（セマンティックサーチ）

4.0.5で追加。

まだ実験的な機能です。

## 概要

`pgroonga_text_semantic_search_ops_v2`演算子クラスにおいて、`&@*`演算子はセマンティックサーチを実行します。

類似文書検索を行う`&@*`演算子については[こちら][similar-search-v2]をご覧ください。

## 構文

```sql
column &@* pgroonga_condition(query)
```

`column`は検索対象のカラムです。型は`text`型です。

`query`はセマンティックサーチ用のクエリーです。型は`text`型です。

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

`&@*`演算子を使うと指定したクエリを使ってセマンティックサーチができます。

```sql
SELECT id, content
  FROM memos
 WHERE content &@* pgroonga_condition('What is a MySQL alternative?');
--  id |                        content                        
-- ----+-------------------------------------------------------
--   1 | PostgreSQL is a RDBMS.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga.
--   2 | Groonga is fast full text search engine.
-- (3 rows)
```

## 参考

* [`CREATE INDEX USING pgroonga`][create-index]

* [`<&@*>`演算子][semantic-distance-v2]: テキスト間の距離を計算

* [`&@*` operator][similar-search-v2]: 類似文書検索

* [`pgroonga_condition`関数][condition]

[similar-search-v2]:similar-search-v2.html
[semantic-distance-v2]:semantic-distance-v2.html

[create-index]:../create-index-using-pgroonga.html#semantic-search

[condition]:../functions/pgroonga-condition.html
