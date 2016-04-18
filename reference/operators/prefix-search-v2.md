---
title: "&^ operator"
layout: en
---

# `&^` operator

## Summary

This operator uses v2 operator class. It doesn't provide backward compatibility until PGroonga 2.0.0. Use it carefully.

`&^` operator performs prefix search.

Prefix search is useful for implementing input completion.

## Syntax

```sql
column &^ prefix
```

`column` is a column to be searched.

`prefix` is a prefix to be found. It's `text` type.

The operator returns `true` when the `column` value starts with `prefix`.

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga.text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');
```

You can perform prefix search with prefix by `&^` operator:

```sql
SELECT * FROM tags WHERE name &^ 'pg';
--    name    
-- -----------
--  PGroonga
--  pglogical
-- (2 rows)
```

## See also

  * [`&^?` operator](prefix-rk-search-v2.html)
