---
title: "&@~| operator"
upper_level: ../
---

# `&@~|` operator

Since 1.2.2.

`&?|` operator is deprecated since 1.2.2. Use `&@~|` operator instead.

`&?>` operator is deprecated since 1.2.1. Use `&@~|` operator instead.

## Summary

`&@~|` operator performs full text search by an array of queries. If one or more queries are matched, the record is matched.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query.

## Syntax

```sql
column &@~| queries
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`queries` is an array of queries for full text search. It's `text[]` type for `text` type or `text[]` type `column`. It's `varchar[]` for `varchar` type `column`.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

The operator returns `true` when one or more queries in `queries` are matched against `column`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_full_text_search_ops_v2`: For `text`

  * `pgroonga.text_array_full_text_search_ops_v2`: For `text[]`

  * `pgroonga.varchar_full_text_search_ops_v2`: For `varchar`

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

You can perform full text search with queries by `&@~|` operator:

```sql
SELECT * FROM memos WHERE content &@~| ARRAY['Groonga engine', 'PostgreSQL -PGroonga'];
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   1 | PostgreSQL is a relational database management system.
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (2 rows)
```

`Groonga engine` query matches against a record that its `id` is `2`.

`PostgreSQL -PGroonga` query matches against a record that its `id` is `1`.

## See also

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [Groonga's query syntax][groonga-query-syntax]

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

[query-v2]:query-v2.html

[match-in-v2]:match-in-v2.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html
