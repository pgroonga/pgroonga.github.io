---
title: "&` operator"
---

# `` &` `` operator

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`` &` `` operator searches records with search condition written in [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html). Script syntax is a powerful syntax. You can use many operations such as full text search, prefix search, range search and so on.

## Syntax

```sql
column &` script
```

`column` is a column to be searched.

`script` is a script that specifies search conditions. It's `text` type.

Syntax in `script` is [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html).

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (id, content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

You can specify complex conditions by `` &` `` operator:

```sql
SELECT * FROM memos WHERE content &` 'id >= 2 && (content @ "engine" || content @ "rdbms")';
--  id |                                content                                 
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full text search engine that supports all languages.
-- (1 row)
```

The specified script `'id >= 2 && (content @ "engine" || content @ "rdbms")'` means:

  * `id` must be 2 or more larger (range search)

  * `content` must contain `"engine"` or `"rdbms"` (full text search)

You can also use [functions](http://groonga.org/docs/reference/function.html) in the script.

## Sequential scan

You can't use this operator with sequential scan.
