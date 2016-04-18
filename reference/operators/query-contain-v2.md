---
title: "&?> operator for non jsonb types"
layout: en
---

# `&?>` operator for non jsonb types

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&?>` operator performs full text search by array of queries. If one or more queries are matched, the record is matched.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query.

## Syntax

```sql
column &?> queries
```

`column` is a column to be searched.

`queries` is an array of queries for full text search. It's `text[]` type.

The operator returns `true` when one or more query in `queries` are matched against `column`.

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

You can perform full text search with queries by `&?>` operator:

```sql
SELECT * FROM memos WHERE content &?> ARRAY['Groonga engine', 'PostgreSQL -PGroonga'];
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   1 | PostgreSQL is a relational database management system.
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (2 rows)
```

`Groonga engine` query matches against a record that its `id` is `2`.

`PostgreSQL -PGroonga` query matches against a record that its `id` is `1`.

## See also

  * [`&?` operator](query-v2.html)

  * [Groonga's query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html)

  * [`&@>` operator](match-contain-v2.html)
