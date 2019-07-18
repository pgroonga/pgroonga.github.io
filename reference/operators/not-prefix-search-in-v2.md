---
title: "!&^| operator"
upper_level: ../
---

# `!&^|` operator

Since 2.2.1.

## Summary

`!&^|` operator performs NOT prefix search by an array of prefixes. If one or more prefixes are matched, the record is NOT matched.

## Syntax

```sql
column !&^| prefixes
```

`column` is a column to be searched. It's `text` type.

`prefixes` is an array of prefixes to be found. It's `text[]` type.

The operator returns `true` when the `column` value doesn't start with any prefixes in `prefixes`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * [`pgroonga_text_term_search_ops_v2`][text-term-search-ops-v2]: For `text`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY,
  alias text
);

CREATE INDEX pgroonga_tag_alias_index ON tags
  USING pgroonga (alias pgroonga_text_term_search_ops_v2);
```

```sql
INSERT INTO tags VALUES ('PostgreSQL', 'PG');
INSERT INTO tags VALUES ('Groonga',    'grn');
INSERT INTO tags VALUES ('PGroonga',   'pgrn');
INSERT INTO tags VALUES ('Mroonga',    'mrn');
```

You can perform NOT prefix search with prefixes by `!&^|` operator:

```sql
SELECT * FROM tags WHERE alias !&^| ARRAY['pg', 'mrn'];
--     name    | alias 
-- ------------+-------
--  Groonga | grn
-- (1 row)
```

## See also

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

[prefix-search-v2]:prefix-search-v2.html

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
