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
column &^ (prefix, NULL, index_name)::pgroonga_full_text_search_condition
```

The first signature is enough for most cases.

The second signature is for using custom normalizer even if PGroonga's index is used or not.
The second signature is available since 2.4.6.

Here is the description of the first signature.

```sql
column &^ prefix
```

`column` is a column to be searched. It's `text` type or `text[]` type.

`prefix` is a prefix to be found. It's `text` type.

The operator returns `true` when the `column` value starts with `prefix`.

Here is the description of the second signature.

```sql
column &^ (prefix, NULL, index_name)::pgroonga_full_text_search_condition
```

`column` is a column to be searched. It's `text` type or `varchar` type.

`prefix` is a prefix to be found. It's `text` type.

The second argument is set only NULL. Because this syntax is not for optimizing search score.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

It's for using the same search options specified in PGroonga index in sequential search.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga_text_term_search_ops_v2`: For `text`

  * `pgroonga_text_array_term_search_ops_v2`: For `text[]`

  * `pgroonga_varchar_term_search_ops_v2`: For `varchar`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2);
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

You can use custom normalizer in prefix search as below.

```sql
CREATE TABLE tags (
  name text
);

CREATE INDEX pgroonga_tag_name_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');
```

```sql
INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');
```

You can prefix search with custom normalizer even if PGroonga's index is not used.

```sql
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &^ ('-p_G', NULL, 'pgrn_index')::pgroonga_full_text_search_condition;
QUERY PLAN
Seq Scan on tags
  Filter: (name &^ '(-p_G,,pgrn_index)'::pgroonga_full_text_search_condition)
(2 rows)

SELECT name
  FROM tags
 WHERE name &^ ('-p_G', NULL, 'pgrn_index')::pgroonga_full_text_search_condition;
   name    
-----------
 PGroonga
 pglogical
(2 rows)
```

## See also

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`!&^|` operator][not-prefix-search-in-v2]: NOT prefix search by an array of prefixes

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

[prefix-rk-search-v2]:prefix-rk-search-v2.html

[prefix-search-in-v2]:prefix-search-in-v2.html

[not-prefix-search-in-v2]:not-prefix-search-in-v2.html

[prefix-rk-search-in-v2]:prefix-rk-search-in-v2.html
