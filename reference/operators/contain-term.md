---
title: "%% operator for varchar[]"
upper_level: ../
---

# `%%` operator for `varchar[]`

## Summary

This operator is deprecated since 1.2.1. Use [`&>` operator][contain-term-v2] instead.

`%%` operator checks whether a term is included in an array of terms.

## Syntax

```sql
column %% term
```

`column` is a column to be searched. It's `varchar[]` type.

`term` is a term to be found. It's `varchar` type.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga_varchar_array_term_search_ops_v2`: Default for `varchar[]`

  * `pgroonga_varchar_array_ops`: For `varchar[]`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE memos (
  id integer,
  tags varchar(255)[]
);

CREATE INDEX pgroonga_tags_index ON memos USING pgroonga (tags);
```

```sql
INSERT INTO memos VALUES (1, ARRAY['PostgreSQ']);
INSERT INTO memos VALUES (2, ARRAY['Groonga']);
INSERT INTO memos VALUES (3, ARRAY['PGroonga', 'PostgreSQL', 'Groonga']);
INSERT INTO memos VALUES (4, ARRAY['Groonga']);
```

You can find records that contain `'Groonga'` term in an array of terms by `%%` operator:

```sql
SELECT * FROM memos WHERE tags %% 'Groonga';
--  id |             tags              
-- ----+-------------------------------
--   2 | {Groonga}
--   3 | {PGroonga,PostgreSQL,Groonga}
--   4 | {Groonga}
-- (3 rows)
```

## See also

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

[contain-term-v2]:contain-term-v2.html
