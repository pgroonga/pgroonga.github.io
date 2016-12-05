---
title: "&^~演算子"
upper_level: ../
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

`column`は検索対象のカラムです。`text`型です。

`prefix`は含まれているべきプレフィックスです。`text`型です。

`column`の値はカタカナにします。`prefix`はローマ字かひらがなかカタカナにします。

`column`の値が`prefix`から始まっていれば`true`を返します。

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE tag_readings (
  name text,
  katakana text,
  PRIMARY KEY (name, katakana)
);

CREATE INDEX pgroonga_tag_reading_katakana_index ON tag_readings
  USING pgroonga (katakana pgroonga.text_term_search_ops_v2);
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

  * [`&^`演算子](prefix-search-v2.html)

  * [`&^>`演算子](prefix-search-contain-v2.html)

  * [`&^~>`演算子](prefix-rk-search-contain-v2.html)
