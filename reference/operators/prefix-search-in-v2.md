---
title: "&^| operator"
upper_level: ../
---

# `&^|` operator

Since 1.2.1.

## Summary

`&^|` operator performs prefix search by an array of prefixes. If one or more prefixes are matched, the record is matched.

Prefix search is useful for implementing input completion.

## Syntax

```sql
column &^| prefixes
```

`column` is a column to be searched. It's `text` type or `text[]` type.

`prefixes` is an array of prefixes to be found. It's `text[]` type.

The operator returns `true` when the `column` value starts with one or more prefixes in `prefixes`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.text_term_search_ops_v2`: For `text`

  * `pgroonga.text_array_term_search_ops_v2`: For `text[]`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  alias text
);

CREATE INDEX pgroonga_tag_alias_index ON tags
  USING pgroonga (alias pgroonga.text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL', 'PG');
INSERT INTO tags VALUES ('Groonga',    'grn');
INSERT INTO tags VALUES ('PGroonga',   'pgrn');
INSERT INTO tags VALUES ('Mroonga',    'mrn');
```

You can perform prefix search with prefixes by `&^|` operator:

```sql
SELECT * FROM tags WHERE alias &^| ARRAY['pg', 'mrn'];
--     name    | alias 
-- ------------+-------
--  PostgreSQL | PG
--  PGroonga   | pgrn
--  Mroonga    | mrn
-- (3 rows)
```

## See also

  * [`&^` operator][prefix-search-v2]

  * [`&^~` operator][prefix-rk-search-v2]

  * [`&^~|` operator][prefix-rk-search-in-v2]

[prefix-search-v2]:prefix-search-v2.html

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
