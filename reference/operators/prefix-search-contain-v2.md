---
title: "&^> operator"
upper_level: ../
---

# `&^>` operator

Since 1.0.9.

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&^>` operator performs prefix search.

Prefix search is useful for implementing input completion.

## Syntax

```sql
column &^> prefix
```

`column` is a column to be searched. It's `text[]` type.

`prefix` is a prefix to be found. It's `text` type.

The operator returns `true` when one of the `column` values start with `prefix`.

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  aliases text[]
);

CREATE INDEX pgroonga_tag_aliases_index ON tags
  USING pgroonga (aliases pgroonga.text_array_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL', ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES ('Groonga',    ARRAY['Groonga', 'grn']);
INSERT INTO tags VALUES ('PGroonga',   ARRAY['PGroonga', 'pgrn']);
```

You can perform prefix search with prefix by `&^>` operator:

```sql
SELECT * FROM tags WHERE aliases &^> 'pg';
--     name    |     aliases     
-- ------------+-----------------
--  PostgreSQL | {PostgreSQL,PG}
--  PGroonga   | {PGroonga,pgrn}
-- (2 rows)
```

## See also

  * [`&^` operator](prefix-search-v2.html)

  * [`&^~` operator](prefix-rk-search-v2.html)

  * [`&^~>` operator](prefix-rk-search-contain-v2.html)
