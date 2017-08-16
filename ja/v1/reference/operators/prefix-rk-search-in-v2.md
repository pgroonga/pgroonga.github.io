---
title: "&^~|演算子"
upper_level: ../
---

# `&^~|`演算子

1.2.1で追加。

## 概要

`&^~>`演算子は[前方一致RK検索](http://groonga.org/ja/docs/reference/operations/prefix_rk_search.html)を実行します。Rは[ローマ字][wikipedia-romaji]でKは[カタカナ][wikipedia-katakana]という意味です。配列の中の1つ以上のプレフィックスがマッチしたらそのレコードはマッチしたことになります。

前方一致RK検索は日本語を検索するときに便利です。

前方一致RK検索は入力補完機能を実装するときに便利です。

## 構文

```sql
column &^~| prefixes
```

`column`は検索対象のカラムです。型は`text`型か`text[]`型です。

`prefixes`は検索したいプレフィックスの配列です。型は`text[]`型です。

`column`の値はカタカナにします。`prefixes`はローマ字かひらがなかカタカナにします。

この演算子は`column`の値が`prefixes`中の1つ以上のプレフィックスから始まっていれば`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga.text_term_search_ops_v2`：`text`用

  * `pgroonga.text_array_term_search_ops_v2`：`text[]`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  reading text
);

CREATE INDEX pgroonga_tags_index ON tags
  USING pgroonga (reading pgroonga.text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL',
                         'ポストグレスキューエル');
INSERT INTO tags VALUES ('Groonga',   'グルンガ');
INSERT INTO tags VALUES ('PGroonga',  'ピージールンガ');
INSERT INTO tags VALUES ('pglogical', 'ピージーロジカル');
```

`&^~|`演算子を使うとローマ字でプレフィックスを複数指定して前方一致RK検索を実行できます。

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['pi-ji-', 'posu'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

プレフィックスにはひらがなを使うこともできます。

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['ぴーじー', 'ぽす'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

プレフィックスにカタカナを使うこともできます。

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['ピージー', 'ポス'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

## 参考

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~`演算子][prefix-rk-search-v2]：前方一致RK検索

[groonga-prefix-rk-search]:http://groonga.org/ja/docs/reference/operations/prefix_rk_search.html

[wikipedia-romaji]:https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97

[wikipedia-katakana]:https://ja.wikipedia.org/wiki/%E7%89%87%E4%BB%AE%E5%90%8D

[prefix-search-v2]:prefix-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-v2]:prefix-rk-search-v2.html
