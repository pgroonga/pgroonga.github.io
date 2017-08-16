---
title: "&^~| operator"
upper_level: ../
---

# `&^~|` operator

Since 1.2.1.

## Summary

`&^~|` operator performs [prefix RK search][groonga-prefix-rk-search] by an array of prefixes. R is for [Romaji][wikipedia-romaji]. K is for [Katakana][wikipedia-katakana]. If one ore more prefixes are matched, the record is matched.

Prefix RK search is useful for Japanese.

Prefix RK search is useful for implementing input completion.

## Syntax

```sql
column &^~| prefixes
```

`column` is a column to be searched. It's `text` type or `text[]` type.

`prefixes` is an array of prefixes to be found. It's `text[]` type.

`column` values must be in Katakana. `prefixes` must be in Romaji, Hiragana or Katakana.

The operator returns `true` when the `column` value starts with one or more prefixes in `prefixes`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_term_search_ops_v2`: For `text`

  * `pgroonga.text_array_term_search_ops_v2`: For `text[]`

## Usage

Here are sample schema and data for examples:

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

You can perform prefix RK search with prefixes in Romaji by `&^~|` operator:

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['pi-ji-', 'posu'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

You can also use Hiragana for prefixes:

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['ぴーじー', 'ぽす'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

You can also use Katakana for prefixes:

```sql
SELECT * FROM tags WHERE reading &^~| ARRAY['ピージー', 'ポス'];
--     name    |        reading         
-- ------------+------------------------
--  PostgreSQL | ポストグレスキューエル
--  PGroonga   | ピージールンガ
--  pglogical  | ピージーロジカル
-- (3 rows)
```

## See also

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

[groonga-prefix-rk-search]:http://groonga.org/docs/reference/operations/prefix_rk_search.html

[wikipedia-romaji]:https://en.wikipedia.org/wiki/Romanization_of_Japanese

[wikipedia-katakana]:https://en.wikipedia.org/wiki/Katakana

[prefix-search-v2]:prefix-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-v2]:prefix-rk-search-v2.html
