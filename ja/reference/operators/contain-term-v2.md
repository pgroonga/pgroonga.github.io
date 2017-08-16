---
title: "&>演算子"
upper_level: ../
---

# `&>`演算子

1.2.1で追加。

## 概要

`&>`演算子は単語の配列中に指定した単語が含まれているかどうかをチェックします。

## 構文

```sql
column &> term
```

`column`は検索対象のカラムです。型は`varchar[]`型です。

`term`は検索条件の単語です。型は`varchar`です。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_varchar_array_term_search_ops_v2`：`varchar[]`型のデフォルト

  * `pgroonga_varchar_array_ops`：`varchar[]`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  tags varchar(255)[]
);

CREATE INDEX pgroonga_tags_index ON memos USING pgroonga (tags);
```

```sql
INSERT INTO memos VALUES (1, ARRAY['PostgreSQ']);
INSERT INTO memos VALUES (2, ARRAY['Groonga']);
INSERT INTO memos VALUES (3, ARRAY['PGroonga', 'PostgreSQL', 'Groonga']);
INSERT INTO memos VALUES (4, ARRAY['Groonga']);
```

`&>`演算子を使うと単語の配列中から`'Groonga'`という単語を含むレコードを検索できます。

```sql
SELECT * FROM memos WHERE tags &> 'Groonga';
--  id |             tags              
-- ----+-------------------------------
--   2 | {Groonga}
--   3 | {PGroonga,PostgreSQL,Groonga}
--   4 | {Groonga}
-- (3 rows)
```
