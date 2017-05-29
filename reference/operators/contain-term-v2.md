---
title: "&@ operator for varchar[]"
upper_level: ../
---

# `&@` operator for `varchar[]`

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&@` operator checks whether a term is included in an array of terms.

## Syntax

```sql
column &@ term
```

`column` is `varchar[]` type column to be searched.

`term` is a term to be found. It's `varchar` type.

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

You can find records that contain `'Groonga'` term in an array of terms by `&@` operator:

```sql
SELECT * FROM memos WHERE tags &@ 'Groonga';
--  id |             tags              
-- ----+-------------------------------
--   2 | {Groonga}
--   3 | {PGroonga,PostgreSQL,Groonga}
--   4 | {Groonga}
-- (3 rows)
```
