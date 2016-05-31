---
title: "&^~演算子"
---

# `&^~`演算子

## 概要

この演算子はv2演算子クラスを使います。v2演算子クラスはPGroonga 2.0.0まで互換性を提供しません。注意して使ってください。

`&^~`演算子は[前方一致RK検索](http://groonga.org/ja/docs/reference/operations/prefix_rk_search.html)を実行します。Rはローマ字でKは仮名（ひらがなとカタカナ）という意味です。

前方一致RK検索は日本語を検索するときに便利です。

前方一致RK検索は入力補完機能を実装するときに便利です。

## 構文

```sql
column &^~ prefix
```

`column`は検索対象のカラムです。`text`型か`text[]`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値はカタカナにします。`prefix`はローマ字かひらがなかカタカナにします。

`column`の値が`prefix`から始まっていれば`true`を返します。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  readings text[]
);

CREATE INDEX pgroonga_tags_index ON tags
  USING pgroonga (readings pgroonga.text_array_term_search_ops_v2);
```

注意：もし`text`型に対して前方一致RK検索を使いたい場合は、`pgroonga.text_array_term_search_ops_v2`演算子クラスではなく、`pgroonga.text_term_search_ops_v2`演算子クラスを使ってください。

```sql
INSERT INTO tags VALUES ('PostgreSQL',
                         ARRAY['ポストグレスキューエル', 'ポスグレ', 'ピージー']);
INSERT INTO tags VALUES ('Groonga',    ARRAY['グルンガ']);
INSERT INTO tags VALUES ('PGroonga',   ARRAY['ピージールンガ']);
INSERT INTO tags VALUES ('pglogical',  ARRAY['ピージーロジカル']);
```

`&^~`演算子を使うとローマ字でプレフィックスを指定して前方一致RK検索を実行できます。

```sql
SELECT * FROM tags WHERE readings &^~ 'pi-ji-';
--     name    |                  readings                  
-- ------------+--------------------------------------------
--  PostgreSQL | {ポストグレスキューエル,ポスグレ,ピージー}
--  PGroonga   | {ピージールンガ}
--  pglogical  | {ピージーロジカル}
-- (3 rows)
```

プレフィックスにひらがなを使うこともできます。

```sql
SELECT * FROM tags WHERE readings &^~ 'ぴーじー';
--     name    |                  readings                  
-- ------------+--------------------------------------------
--  PostgreSQL | {ポストグレスキューエル,ポスグレ,ピージー}
--  PGroonga   | {ピージールンガ}
--  pglogical  | {ピージーロジカル}
-- (3 rows)
```

プレフィックスにカタカナを使うこともできます。

```sql
SELECT * FROM tags WHERE readings &^~ 'ピージー';
--     name    |                  readings                  
-- ------------+--------------------------------------------
--  PostgreSQL | {ポストグレスキューエル,ポスグレ,ピージー}
--  PGroonga   | {ピージールンガ}
--  pglogical  | {ピージーロジカル}
-- (3 rows)
```

## 参考

  * [`&^`演算子](prefix-search-v2.html)
