---
title: "&@| operator"
upper_level: ../
---

# `&@|` operator

Since 2.0.0.

## Summary

`&@>` operator is deprecated since 1.2.1. Use `&@|` operator instead.

`&@|` operator performs full text search by array of keywords. If one or more keywords are found, the record is matched.

## Syntax

```sql
column &@| keywords
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`keywords` is an array of keywords for full text search. It's `text[]` type for `text` type or `text[]` type `column`. It's `varchar[]` for `varchar` type `column`.

The operator returns `true` when one or more keyword in `keywords` are included in `column`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_full_text_search_ops_v2`: For `text`.

  * `pgroonga.text_array_full_text_search_ops_v2`: For `text[]`.

  * `pgroonga.varchar_full_text_search_ops_v2`: For `varchar`.

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

You can perform full text search with keywords by `&@|` operator:

```sql
SELECT * FROM memos WHERE content &@| ARRAY['engine', 'database'];
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   1 | PostgreSQL is a relational database management system.
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (2 rows)
```

`column &@| ARRAY['KEYWORD1', 'KEYWORD2']` equals to `column &? 'KEYWORD1 OR KEYWORD2'`.

## See also

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`&?` operator][query-v2]: Full text search by easy to use query language

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

[match-v2]:match-v2.html
[query-v2]:query-v2.html
[query-in-v2]:query-in-v2.html
