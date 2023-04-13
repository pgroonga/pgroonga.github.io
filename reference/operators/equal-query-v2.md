---
title: "&=~ operator"
upper_level: ../
---

# `&=~` operator

Since 3.0.0.

## Summary

`&=~` operator performs equal search with query.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query, AND search by `KEYWORD1 KEYWORD2` in query and NOT search by `KEYWORD1 -KEYWORD2` in query.

## Syntax

There is one signature:

```sql
column &=~ query
```

`column` is a column to be searched. It's `text[]` type or `varchar[]` type.

`query` is a query for equal search. It's `text` type.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga_text_array_term_search_ops_v2`: Default for `text[]`

  * `pgroonga_varchar_array_term_search_ops_v2`: Default for `carchar[]`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  id integer,
  names text[]
);

CREATE INDEX pgroonga_tag_names_index ON tags
 USING pgroonga (names pgroonga_text_array_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES (1, ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES (2, ARRAY['Groonga', 'grn', 'groonga']);
INSERT INTO tags VALUES (3, ARRAY['PGroonga', 'pgrn', 'SQL']);
```

You can perform equal search with multiple keywords by `&=~` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

```sql
SELECT * FROM tags WHERE names &=~ 'grn OR sql';
--  id |         names         
-- ----+-----------------------
--   2 | {Groonga,grn,groonga}
--   3 | {PGroonga,pgrn,SQL}
-- (2 rows)
```

## See also

  * [`@>` operator][contain-array]: Contained search by an array

  * [Groonga's query syntax][groonga-query-syntax]

[contain-array]:contain-array.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html
