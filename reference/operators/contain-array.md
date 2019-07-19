---
title: "@> operator"
upper_level: ../
---

# `@>` operator

## Summary

PGroonga supports fast index search by `@>` operator.

[`@>` operator is a built-in PostgreSQL operator][postgresql-array-operators]. `@>` operator returns `true` when the right hand side array type value is a subset of left hand side array type value.

## Syntax

Here is the syntax of this operator:

```sql
column @> query
```

`column` is a column to be searched. It's `text[]` type or `varchar[]`.

`query` is used as query. It must be the same type as `column`.

The operator returns `true` when `query` is a subset of `column` value, `false` otherwise.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * [`pgroonga_text_array_term_search_ops_v2`][text-array-term-search-ops-v2]: For `text[]`

  * [`pgroonga_varchar_array_term_search_ops_v2`][varchar-array-term-search-ops-v2]: For `varchar[]`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  tags text[]
);

CREATE INDEX pgroonga_memos_index
  ON memos
  USING pgroonga (tags pgroonga_text_array_term_search_ops_v2);

INSERT INTO memos VALUES (ARRAY['Groonga', 'PGroonga', 'PostgreSQL']);
INSERT INTO memos VALUES (ARRAY['Groonga', 'Mroonga', 'MySQL']);
```

Disable sequential scan:

```sql
SET enable_seqscan = off;
```

Here is an example for match case:

```sql
SELECT * FROM memos WHERE tags @> ARRAY['Groonga', 'PGroonga'];
--              tags              
-- -------------------------------
--  {Groonga,PGroonga,PostgreSQL}
-- (1 row)
```

Here is an example for not match case.

```sql
SELECT * FROM memos WHERE tags @> ARRAY['Mroonga', 'PGroonga'];
--  tags 
-- ------
-- (0 rows)
```

[postgresql-array-operators]:{{ site.postgresql_doc_base_url.en }}/functions-array.html#ARRAY-OPERATORS-TABLE

[text-array-term-search-ops-v2]:../#text-array-term-search-ops-v2

[varchar-array-term-search-ops-v2]:../#varchar-array-term-search-ops-v2
