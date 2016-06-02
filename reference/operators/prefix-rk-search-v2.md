---
title: "&^~ operator"
---

# `&^~` operator

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&^~` operator performs [prefix RK search](http://groonga.org/docs/reference/operations/prefix_rk_search.html). R is for [Romaji](https://en.wikipedia.org/wiki/Romanization_of_Japanese). K is for [Kana](https://en.wikipedia.org/wiki/Kana).

Prefix RK search is useful for Japanese.

Prefix RK search is useful for implementing input completion.

## Syntax

```sql
column &^~ prefix
```

`column` is a column to be searched. It's `text` type.

`prefix` is a prefix to be found. It's `text` type.

`column` values must be in Katakana. `prefix` must be in Romaji, Hiragana or Katakana.

The operator returns `true` when the `column` value starts with `prefix`.

## Usage

Here are sample schema and data for examples:

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

You can perform prefix RK search with prefix in Romaji by `&^~` operator:

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'pi-ji-';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

You can also use Hiragana for prefix:

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'ぴーじー';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

You can also use Katakana for prefix:

```sql
SELECT * FROM tag_readings WHERE katakana &^~ 'ピージー';
--    name    |     katakana     
-- -----------+------------------
--  PGroonga  | ピージールンガ
--  pglogical | ピージーロジカル
-- (2 rows)
```

## See also

  * [`&^` operator](prefix-search-v2.html)

  * [`&^>` operator](prefix-search-contain-v2.html)

  * [`&^~>` operator](prefix-rk-search-contain-v2.html)
