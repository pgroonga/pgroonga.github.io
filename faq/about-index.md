---
title: FAQ: About Indexes
---

# About PGroonga Indexes Gotchas

The article introduces points to check when a search is executed using a sequential scan, even though a PGroonga index is set up.

PGroonga is an extension for PostgreSQL designed for fast full-text search. However, there can be instances where searches do not speed up despite having a PGroonga index.

One common scenario is that PostgreSQL opts for a sequential scan instead of using the PGroonga index.

The article explains why a sequential scan might be chosen and how to ensure that searches utilize the PGroonga index.

It first describes how to check if a search is being executed via a sequential scan. Then, it lists four possible reasons for this issue and their solutions.

## To confirm whether a sequential search is being executed

Let's first determine if the query in question is using a sequential search. This can be confirmed using `EXPLAIN ANALYZE`.

We use a following table structure as an example. To ensure the search is definitely sequential in this example, no indexes or primary keys have been set.

```sql
CREATE TABLE memos (
  title text,
  content text
);

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is an RDBMS.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a super-fast full-text search engine.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension that brings super-fast full-text search to PostgreSQL.');
```

The query we are examining is as follows:

```sql
SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
```

Now, let's confirm whether the query is using a sequential search. As mentioned earlier, we'll use `EXPLAIN ANALYZE` to check.

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                              QUERY PLAN                                              
-- -----------------------------------------------------------------------------------------------------
--  Seq Scan on memos  (cost=0.00..678.80 rows=1 width=64) (actual time=2.803..4.664 rows=2 loops=1)
--    Filter: (content &@~ 'PostgreSQL'::text)
--    Rows Removed by Filter: 1
--  Planning Time: 0.113 ms
--  Execution Time: 4.731 ms
-- (5 rows)
```

The result is as shown above. In the case of a sequential search, "Seq Scan" will be displayed. Our goal here is to transform this "Seq Scan" into "Index Scan using #{PGroonga index name}" as shown below.

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                                           QUERY PLAN                                                          
-- ------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgrn_content_index on memos  (cost=0.00..4.02 rows=1 width=64) (actual time=0.778..0.782 rows=2 loops=1)
--    Index Cond: (content &@~ 'PostgreSQL'::text)
--  Planning Time: 0.835 ms
--  Execution Time: 1.002 ms
-- (4 rows)
```

Now that we know how to check whether a sequential search is being used, let's solve the specific issue at hand.

## Case 1: "Forgetting to Set the PGroonga Index"

Let's start with the simplest case first.

Obviously, you cannot perform searches using a PGroonga index if it isn't set up.

Many might think, "Would anyone really overlook such a simple thing?" but consider a database with a very large number of tables and indexes. In cases where there are tens or hundreds of tables, columns, and indexes, it's possible to accidentally forget to set up an index.

This case is very easy to check and can be done quickly, so it’s suitable as the first point to verify.

**Checkpoint: Check Table Configuration Information**

The checkpoint for this case is to confirm the configuration information of the table. Specifically, you can verify it as follows:

1. Connect to the relevant DB with `psql`.
2. Check the table definition.
3. Confirm whether a PGroonga index exists in step 2.

Step 1 is not particularly difficult, so details are omitted. For step 2, you can use `\d #{table_name}`. Replace `#{table_name}` with the name of the table containing the column you wish to search using the PGroonga index. In step 3, check the content from step 2. Here’s what to specifically look for.

First, assume that an index is set on the `content` column of the `memos` table.

```sql
CREATE TABLE memos (
  title text PRIMARY KEY,
  content text
);
CREATE INDEX pgrn_content_index ON memos USING pgroonga (content);
```

Next, verify whether an index is set on the `content` column of the `memos` table using the `\d` command. The result will look like this:

``` 
\d memos
--              Table "public.memos"
--  Column  | Type | Collation | Nullable | Default
-- ---------+------+-----------+----------+---------
--  title   | text |           | not null |
--  content | text |           |          |
-- Indexes:
--     "memos_pkey" PRIMARY KEY, btree (title)
--     "pgrn_content_index" pgroonga (content)
```

Focus on the "Indexes" section. This displays all indexes set on the `memos` table in the format `#{index_name} #{index_type} (#{column_name})`. Here, verify whether a PGroonga index is set on the `content` column.

In this example, since the `pgrn_content_index` is set on the `content` column, check to see if `Indexes` shows `"pgrn_content_index" pgroonga (content)`. As mentioned earlier, indexes appear in the format `#{index_name} #{index_type} (#{column_name})`, so this indicates that a PGroonga index is set on the `content` column.

If you forgot to set `pgrn_content_index`, it will not appear in the `Indexes` as shown below.

```
\d memos
--              Table "public.memos"
--  Column  | Type | Collation | Nullable | Default
-- ---------+------+-----------+----------+---------
--  title   | text |           | not null |
--  content | text |           |          |
-- Indexes:
--     "memos_pkey" PRIMARY KEY, btree (title)
```

In this way, use the `\d` command to check for forgotten index settings. Once you confirm that the index is properly set, the check is complete at this stage. If the index is correctly set but the search does not utilize the index, proceed to the next case.

## "Case 2: Searching a column with a type not supported by the operator"

We'll discuss a case where the type of the column being searched does not match the type supported by the operator used for the search.

Let's consider the following table, index, and query as a concrete example.

```sql
CREATE TABLE memos (
  title text PRIMARY KEY,
  content text,
  tags text[]
);
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is an RDBMS.', ARRAY['PostgreSQL']);
INSERT INTO memos VALUES ('Groonga', 'Groonga is an ultra-fast full-text search engine.', ARRAY['Groonga']);
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension that realizes ultra-fast full-text search in PostgreSQL.', ARRAY['PGroonga', 'PostgreSQL']);

CREATE INDEX pgrn_tags_index ON memos USING pgroonga (tags);

SET enable_seqscan = off;
EXPLAIN ANALYZE VERBOSE SELECT * FROM memos WHERE tags &> 'PostgreSQL';
--                                                            QUERY PLAN                                                           
-- --------------------------------------------------------------------------------------------------------------------------------
--  Seq Scan on public.memos  (cost=10000000000.00..10000000003.28 rows=1 width=96) (actual time=23.095..23.098 rows=2 loops=1)
--    Output: title, content, tags
--    Filter: ((memos.tags)::character varying[] &> 'PostgreSQL'::character varying)
--    Rows Removed by Filter: 1
--  Planning Time: 0.084 ms
--  JIT:
--    Functions: 2
--    Options: Inlining true, Optimization true, Expressions true, Deforming true
--    Timing: Generation 0.330 ms, Inlining 9.505 ms, Optimization 8.461 ms, Emission 5.106 ms, Total 23.403 ms
--  Execution Time: 23.473 ms
-- (10 rows)
```

When you execute the above example, it runs a sequential search instead of using the index. We will change this to use index-based search.

**Checkpoint: Confirm the supported data types for the operator**

First, let's confirm the contents of the example above. The column being searched is `tags` of type `text[]`. The operator used for the search is `&>`, which checks if the specified keyword is included in the array-type column being searched.

Next, we check whether the `&>` operator supports the `text[]` type. The types supported by each operator are listed in the reference manual of PGroonga's official documentation. Searching for `&>` in the "PGroonga Official Documentation Reference Manual" shows that `&>` is listed in the "for varchar[]" section. This means that `&>` supports `varchar[]` type columns but not other types.

Looking again at the example above, the `tags` column being searched is of type `text[]`, which `&>` does not support. When the type of the column being searched is not supported by the operator used for searching, the index will not be used.

In this case, indexing and searching with `tags` cast to `varchar[]` will allow the index to be used. Let’s see how it works.

```sql
DROP INDEX pgrn_tags_index;
CREATE INDEX pgrn_tags_index ON memos USING pgroonga ((tags::varchar[]));

EXPLAIN ANALYZE VERBOSE SELECT * FROM memos WHERE tags::varchar[] &> 'PostgreSQL';
--                                                             QUERY PLAN                                                            
-- ----------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgrn_tags_index on public.memos  (cost=0.00..4.01 rows=1 width=96) (actual time=0.195..0.195 rows=0 loops=1)
--    Output: title, content, tags
--    Index Cond: ((memos.tags)::character varying[] &> 'PostgreSQL'::character varying)
--  Planning Time: 0.047 ms
--  Execution Time: 0.221 ms
-- (5 rows)
```

Successfully, the search now uses the index.

If the index-based search works at this stage, the check is complete here. If the index is not used for searching even when searching for columns of types supported by the operator, proceed to the next case.


## Case 3: "The operator class specification is incorrect or not specified."

Let's consider the case where the operator class corresponding to the type of the column being searched is not specified. Describing operator classes can be lengthy, so it will be omitted here. Even if you're not familiar with operator classes, you can still verify this.

Let's explain with a concrete example. Consider the following table, index, and query:

```sql
CREATE TABLE memos (
  title text PRIMARY KEY,
  content text
);
INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is an RDBMS.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a super-fast full-text search engine.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension that provides super-fast full-text search in PostgreSQL.');

CREATE INDEX pgrn_tags_index ON memos USING pgroonga (content);

SET enable_seqscan = off;
EXPLAIN ANALYZE VERBOSE SELECT * FROM memos WHERE content &^ 'Postgre';
```

--                                                            QUERY PLAN                                                           
-- --------------------------------------------------------------------------------------------------------------------------------
--  Seq Scan on public.memos  (cost=10000000000.00..10000000003.28 rows=1 width=64) (actual time=17.357..17.361 rows=1 loops=1)
--    Output: title, content
--    Filter: (memos.content &^ 'Postgre'::text)
--    Rows Removed by Filter: 2
--  Planning Time: 0.198 ms
--  JIT:
--    Functions: 2
--    Options: Inlining true, Optimization true, Expressions true, Deforming true
--    Timing: Generation 0.290 ms, Inlining 7.746 ms, Optimization 5.999 ms, Emission 3.593 ms, Total 17.628 ms
--  Execution Time: 17.705 ms
-- (10 rows)

In this example, the search is done using a sequential scan rather than an index. We will modify it to use the index.

Checkpoint: Verify the specified operator class

First, let's review the content of the example above. The column being searched is `content`, which is of text type. The operator used for the search is `&^`, which performs a prefix search.

Refer to the PGroonga official documentation reference manual. Look for `&^` in the "text" section of the "PGroonga official documentation reference manual." You should find it under the "pgroonga_text_term_search_ops_v2 operator class."

This indicates that when using `&^` with a text-type column, you need to specify the `pgroonga_text_term_search_ops_v2` operator class. That is, do it as follows:

```sql
DROP INDEX pgrn_tags_index;
CREATE INDEX pgrn_tags_index ON memos USING pgroonga (content pgroonga_text_term_search_ops_v2);

EXPLAIN ANALYZE VERBOSE SELECT * FROM memos WHERE content &^ 'Postgre';
```

--                                                             QUERY PLAN                                                            
-- ----------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgrn_tags_index on public.memos  (cost=0.00..4.01 rows=1 width=64) (actual time=0.633..0.636 rows=1 loops=1)
--    Output: title, content
--    Index Cond: (memos.content &^ 'Postgre'::text)
--  Planning Time: 0.798 ms
--  Execution Time: 0.830 ms
-- (5 rows)

The key point is the part in `CREATE INDEX` that specifies USING pgroonga (content pgroonga_text_term_search_ops_v2). For a combination where an operator class needs to be specified, do it as in the example above: pgroonga (column to set index operator class).

Successfully, the search using the index is now possible.

At this stage, if the search using the index works, the check is complete. If the search doesn't use the index despite the correct operator class specification, proceed to the next case.


## Case 4: "The order of columns specified in the PGroonga index differs from the order of columns in the search query."

This case highlights points to check when searching multiple columns using `ARRAY[]` to search them all at once. Specifically, the following case demonstrates searching records where the `title` or `content` column includes "Groonga" or "PostgreSQL."

```sql
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
    ON memos
 USING pgroonga ((ARRAY[title, content]));

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a fast full-text search engine supporting Japanese.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension for using Groonga as an index.');
INSERT INTO memos VALUES ('Command Line', 'There is a groonga command.');

SET enable_seqscan = off;
EXPLAIN ANALYZE VERBOSE
SELECT *
  FROM memos
 WHERE ARRAY[content, title] &@~ 'Groonga OR PostgreSQL';
```

In the above example, the search is performed as a sequential scan instead of using the index.

**Checkpoints: Verify the order of columns**

There are two points to check:

1. `ARRAY[title, content]` specified in `CREATE INDEX`
2. `WHERE` clause `ARRAY[content, title]`

As shown, the column order in `ARRAY[]` differs between `CREATE INDEX` and the `WHERE` clause. If the column order in `ARRAY[]` is different between `CREATE INDEX` and the `WHERE` clause, the index is not used.

Therefore, if you align the order, the search will use the index for searching. Let’s take a look:

```sql
EXPLAIN ANALYZE VERBOSE
SELECT *
  FROM memos
 WHERE ARRAY[title, content] &@~ 'Groonga OR PostgreSQL';
```

Note the `ARRAY[]` in `CREATE INDEX` and the `WHERE` clause. In this example, both use `ARRAY[title, content]` and have the same column order within `ARRAY[]`.

As shown above, if the column order in `ARRAY[]` is the same, the search uses the index.

If the search uses the index at this stage, the check is complete. If the search does not use the index despite the correct column order, it might be an issue with PGroonga. In such cases, please report it on PGroonga Issues or Discussions (you can report in Japanese).


## Conclusiton

In this article, we introduced some relatively simple checkpoints to consider when PostgreSQL doesn't use the PGroonga index.

Of course, there may be other causes not mentioned here, so if following this article doesn't resolve your issue, please report it to [PGroonga Issues](https://github.com/pgroonga/pgroonga/issues) or [Discussions](https://github.com/pgroonga/pgroonga/discussions).


