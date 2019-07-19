---
title: "!&^| 演算子"
upper_level: ../
---

# `!&^|`演算子

2.2.1で追加。

## 概要

`!&^|`演算子はプレフィックスの配列を使って否定前方一致検索をします。配列の中の1つ以上のプレフィックスがマッチしたらそのレコードはマッチしなかったことになります。

## 構文

```sql
column !&^| prefixes
```

`column`は検索対象のカラムです。型は`text`型です。


`prefixes`は検索したいプレフィックスの配列です。型は`text[]`型です。

この演算子は`column`の値が`prefixes`中のどのプレフィックスからも始まっていなければ`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * [`pgroonga_text_term_search_ops_v2`][text-term-search-ops-v2]：`text`型用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  alias text
);

CREATE INDEX pgroonga_tag_alias_index ON tags
  USING pgroonga (alias pgroonga_text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL', 'PG');
INSERT INTO tags VALUES ('Groonga',    'grn');
INSERT INTO tags VALUES ('PGroonga',   'pgrn');
INSERT INTO tags VALUES ('Mroonga',    'mrn');
```

`!&^|`演算子でプレフィックスの配列を使った否定前方一致検索をできます。

```sql
SELECT * FROM tags WHERE alias !&^| ARRAY['pg', 'mrn'];
--     name    | alias 
-- ------------+-------
--  Groonga | grn
-- (1 row)
```

## 参考

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

[text-term-search-ops-v2]:../#text-term-search-ops-v2

[prefix-search-v2]:prefix-search-v2.html

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
