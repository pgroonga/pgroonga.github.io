---
title: "&= operator"
upper_level: ../
---

# `&=` operator

Since 2.4.6.

## Summary

`&=` operator performs exact match search.

## Syntax

```sql
column &= keyword
column &= (keyword, NULL, index_name)::pgroonga_full_text_search_condition
```

The first syntax does not use normally.

The second syntax is for using custom normalizer even if PGroonga's index is used or not.

Here is the description of the first signature.

```sql
column &= keyword
```

`column` is a column to be searched. It's `text` type or `varchar` type.

`keyword` is a keyword for exact match search . It's `text` type.

The operator returns `true` when the `column` exact match with `keyword`.

Here is the description of the second signature.

```sql
column &= (keyword, NULL, index_name)::pgroonga_full_text_search_condition
```

`column` is a column to be searched. It's `text` type or `varchar` type.

`keyword` is a keyword for exact match search . It's `text` type.

The second argument is set only NULL. Because this syntax is not for optimizing search score.

`index_name` is an index name of the corresponding PGroonga index. It's `text` type.

It's for using the same search options specified in PGroonga index in sequential search.

## Operator classes

We need to specify one of the following operator classes to use this operator:

  * `pgroonga_text_term_search_ops_v2`: For `text`

  * `pgroonga_varchar_term_search_ops_v2`: For `varchar`

## Usage

If PostgreSQL use PGroonga's index as below, `&=` operator can use custom normalizer.

Therefore, PostgreSQL returns 2 records(Groonga and groonga) by the search keyword like `gr-oonga` in the following example.

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
-- QUERY PLAN
-- Bitmap Heap Scan on tags
--    Recheck Cond: (name &= 'gr-oonga'::text)
--    ->  Bitmap Index Scan on pgrn_index
--          Index Cond: (name &= 'gr-oonga'::text)
-- (4 rows)

SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
--    name    
-- -----------
--  Groonga
--  groonga
-- (2 rows)
```

However, if PostgreSQL does not use PGroonga's index, `&=` operator can not use custom normalizer.

Therefore, PostgreSQL returns no record by the search keyword like `gr-oonga` in the following example.

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2)
  WITH (normalizers='NormalizerNFKC150("remove_symbol", true)');

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
-- QUERY PLAN
-- Seq Scan on tags
--   Filter: (name &= 'gr-oonga'::text)
-- (2 rows)

SELECT name
  FROM tags
 WHERE name &= 'gr-oonga';
--  name 
-- ------
-- (0 rows)
```

On the other hand, if we use the second syntax, we can exact match search with custom normalizer even if PGroonga's index is not used.

```sql
CREATE TABLE tags (
  id int,
  name text
);

CREATE INDEX pgrn_index ON tags
  USING pgroonga (name pgroonga_text_term_search_ops_v2);

INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'groonga');
INSERT INTO tags VALUES (4, 'PGroonga');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT name
  FROM tags
 WHERE name &= ('groonga', NULL, 'pgrn_index')::pgroonga_full_text_search_condition
 ORDER BY id;
-- QUERY PLAN
-- Sort
--   Sort Key: id
--   ->  Seq Scan on tags
--         Filter: (name &= '(groonga,,pgrn_index)'::pgroonga_full_text_search_condition)
-- (4 rows)

SELECT name
  FROM tags
 WHERE name &= ('groonga', NULL, 'pgrn_index')::pgroonga_full_text_search_condition
 ORDER BY id;
--   name   
-- ---------
--  Groonga
--  groonga
-- (2 rows)
```
