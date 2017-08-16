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
```

`column`は検索対象のカラムです。型は`text`型か`text[]`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値が`prefix`から始まっていれば`true`を返します。

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

## 参考

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html

