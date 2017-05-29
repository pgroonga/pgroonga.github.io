---
title: "&@> operator"
upper_level: ../
---

# `&@>` operator

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&@>` operator performs full text search by array of keywords. If one or more keywords are found, the record is matched.

## Syntax

```sql
column &@> keywords
```

`column` is a column to be searched.

`keywords` is an array of keywords for full text search. It's `text[]` type.

The operator returns `true` when one or more keyword in `keywords` are included in `column`.

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can perform full text search with keywords by `&@>` operator:

```sql
SELECT * FROM memos WHERE content &@> ARRAY['engine', 'database'];
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   1 | PostgreSQL is a relational database management system.
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (2 rows)
```

`column &@> ARRAY['KEYWORD1', 'KEYWORD2']` equals to `column &? 'KEYWORD1 OR KEYWORD2'`.

## See also

  * [`&@` operator](match-v2.html)

  * [`&?` operator](query-v2.html)
