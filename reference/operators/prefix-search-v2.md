---
title: "&^ operator"
upper_level: ../
---

# `&^` operator

Since 1.2.1.

## Summary

`&^>` operator for `text[]` is deprecated since 1.2.1. Use `&^` operator instead.

`&^` operator performs prefix search.

Prefix search is useful for implementing input completion.

## Syntax

```sql
column &^ prefix
```

`column` is a column to be searched. It's `text` type or `text[]` type.

`prefix` is a prefix to be found. It's `text` type.

The operator returns `true` when the `column` value starts with `prefix`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_term_search_ops_v2`: For `text`

  * `pgroonga.text_array_term_search_ops_v2`: For `text[]`

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

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

[prefix-rk-search-v2]:prefix-rk-search-v2.html
