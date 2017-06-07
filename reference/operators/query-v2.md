---
title: "&? operator for non jsonb types"
upper_level: ../
---

# `&?` operator for non `jsonb` types

Since 1.2.0.

## Summary

`&?` operator performs full text search with query.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query.

## Syntax

```sql
column &? query
```

`column` is a column to be searched. It's `text` type, `text[]` type or `varchar` type.

`query` is a query for full text search. It's `text` type for `text` type or `text[]` type `column`. It's `varchar` type for `varchar` type `column`.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_full_text_search_ops`: Default for `text`.

  * `pgroonga.text_array_full_text_search_ops`: Default for `text[]`.

  * `pgroonga.varchar_full_text_search_ops`: For `varchar`.

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

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can perform full text search with multiple keywords by `&?` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

```sql
SELECT * FROM memos WHERE content &? 'PGroonga OR PostgreSQL';
--  id |                            content                             
-- ----+----------------------------------------------------------------
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   1 | PostgreSQL is a relational database management system.
-- (2 rows)
```

See [Groonga document][groonga-query-syntax] for query syntax details.

Note that you can't use syntax that starts with `COLUMN_NAME:` like `COLUMN_NAME:@KEYWORD`. It's disabled in PGroonga.

You can't use `COLUMN_NAME:^VALUE` for prefix search. You need to use `VALUE*` for prefix search.

## See also

  * [`&@` operator][match-v2]

  * [Groonga's query syntax][groonga-query-syntax]

[match-v2]:match-v2.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html
