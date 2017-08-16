---
title: "&^~演算子"
upper_level: ../
---

# `&^~`演算子

1.2.1で追加。

## 概要

1.2.1から`text[]`用の`&^~>`演算子は非推奨になりました。代わりに`&^~`演算子を使ってください。

`&^~`演算子は[前方一致RK検索][groonga-prefix-rk-search]をします。Rは[Romaji（ローマ字）][wikipedia-romaji]のRです。Kは[Katakana（カタカナ）][wikipedia-katakana]のKです。

前方一致RK検索は日本語を検索するときに便利です。

前方一致RK検索は入力補完機能を実装するときに便利です。

## 構文

```sql
column &^~ prefix
```

`column`は検索対象のカラムです。型は`text`型か`text[]`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値はカタカナにします。`prefix`はローマ字かひらがなかカタカナにします。

`column`の値が`prefix`から始まっていれば`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_term_search_ops_v2`：`text`用

  * `pgroonga_text_array_term_search_ops_v2`：`text[]`用

  * `pgroonga_varchar_term_search_ops_v2`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tag_readings (
  name text,
  katakana text,
  PRIMARY KEY (name, katakana)
);

CREATE INDEX pgroonga_tag_reading_katakana_index ON tag_readings
  USING pgroonga (katakana pgroonga_text_term_search_ops_v2);
```

```sql
INSERT INTO tag_readings VALUES ('PostgreSQL', 'ポストグレスキューエル');
INSERT INTO tag_readings VALUES ('PostgreSQL', 'ポスグレ');
INSERT INTO tag_readings VALUES ('Groonga',    'グルンガ');
INSERT INTO tag_readings VALUES ('PGroonga',   'ピージールンガ');
INSERT INTO tag_readings VALUES ('pglogical',  'ピージーロジカル');
```

`&^~`演算子を使うとローマ字でプレフィックスを指定して前方一致RK検索を実行できます。

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'pi-ji-';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

プレフィックスにひらがなを使うこともできます。

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'ぴーじー';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

プレフィックスにカタカナを使うこともできます。

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'ピージー';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

## 参考

  * [`&^`演算子][prefix-search-v2]：前方一致検索

  * [`&^|`演算子][prefix-search-in-v2]：プレフィックスの配列での前方一致検索

  * [`&^~|`演算子][prefix-rk-search-in-v2]：プレフィックスの配列での前方一致RK検索

[groonga-prefix-rk-search]:http://groonga.org/ja/docs/reference/operations/prefix_rk_search.html

[wikipedia-romaji]:https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97

[wikipedia-katakana]:https://ja.wikipedia.org/wiki/%E7%89%87%E4%BB%AE%E5%90%8D

[prefix-search-v2]:prefix-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
