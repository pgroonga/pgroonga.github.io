---
title: "@>演算子"
upper_level: ../
---

# `@>`演算子

## 概要

PGroongaは`@>`演算子の検索をインデックスを使って高速に実現できます。

[`@>`演算子は組み込みのPostgreSQLの演算子][postgresql-array-operators]です。`@>`演算子は右辺の配列型の値が左辺の配列型の値のサブセットなら`true`を返します。

## 構文

この演算子の構文は次の通りです。

```sql
column @> query
```

`column`は検索対象のカラムです。`text[]`型か`varchar[]`型です。

`query`はクエリーとして使われます。`column`と同じ型でなければいけません。

この演算子は`query`が`column`の値のサブセットなら`true`を返し、それ以外の時は`false`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * [`pgroonga_text_array_term_search_ops_v2`][text-array-term-search-ops-v2]：`text[]`型用

  * [`pgroonga_varchar_array_term_search_ops_v2`][varchar-array-term-search-ops-v2]：`varchar[]`型用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  tags text[]
);

CREATE INDEX pgroonga_memos_index
  ON memos
  USING pgroonga (tags pgroonga_text_array_term_search_ops_v2);

INSERT INTO memos VALUES (ARRAY['Groonga', 'PGroonga', 'PostgreSQL']);
INSERT INTO memos VALUES (ARRAY['Groonga', 'Mroonga', 'MySQL']);
```

シーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

マッチする例は次の通りです。

```sql
SELECT * FROM memos WHERE tags @> ARRAY['Groonga', 'PGroonga'];
--              tags              
-- -------------------------------
--  {Groonga,PGroonga,PostgreSQL}
-- (1 row)
```

マッチしない例は次の通りです。

```sql
SELECT * FROM memos WHERE tags @> ARRAY['Mroonga', 'PGroonga'];
--  tags 
-- ------
-- (0 rows)
```

[postgresql-array-operators]:{{ site.postgresql_doc_base_url.ja }}/functions-array.html#ARRAY-OPERATORS-TABLE

[text-array-term-search-ops-v2]:../#text-array-term-search-ops-v2

[varchar-array-term-search-ops-v2]:../#varchar-array-term-search-ops-v2
