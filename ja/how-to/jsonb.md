---
title: How to use on jsonb type column
---

# How to do full-text-search on `jsonb` type column

`jsonb` type comes from PostgreSQL 9.4, this document will help you to try use PGroonga on `jsonb` type.

## Create table schema and index

Here is the sample to create a table with `jsonb` type:

```sql
CREATE TABLE jsonb_table (
  id serial,
  data jsonb,
  PRIMARY KEY (id)
);
```

Then create index on `jsonb`:

Note that `pgroonga_jsonb_ops_v2` only supports less than **4KiB**
string data in a `jsonb` column; if not certain about the length of
`jsonb` data `pgroonga_jsonb_full_text_search_ops_v2` should be used
as index method.

```sql
CREATE INDEX pgroonga_index_jsonb_table_data ON jsonb_table
   USING pgroonga ("data" pgroonga_jsonb_full_text_search_ops_v2);
```

Let us add some data for test:

```sql
INSERT INTO jsonb_table (data)
  VALUES ('{"category":"server"}');
INSERT INTO jsonb_table (data)
  VALUES ('{"category":"user"}');
INSERT INTO jsonb_table (data)
  VALUES ('{"category":"server"}');
INSERT INTO jsonb_table (data)
  VALUES ('{"category":"user", "message": "user is logged in"}');
```

Now you can use full text search by PGroonga on `data` column like below:

```sql
SELECT id
  FROM jsonb_table
 WHERE data &@ 'user';
--  id
-- ----
--   2
--   4
-- (2 rows)
```

## Score function on `jsonb` column

With `pgroonga_score(tableoid, ctid)` can get score of full `jsonb` column:

```sql
SELECT id,
       pgroonga_score(tableoid, ctid) AS score
  FROM jsonb_table
 WHERE data &@ 'user';
--  id | score
-- ----+-------
--   2 |     1
--   4 |     2
-- (2 rows)
```

If you want to score on specified JSON field, you must create index on that field:

```sql
CREATE INDEX pgroonga_index_jsonb_title ON jsonb_table
 USING pgroonga ((data->>'category'));
```

Note that `jsonb->>'field'` is `text` type and `jsonb->'field'` is `jsonb` type.

With this index, you can get score on `jsonb` field:

```sql
SELECT id,
       pgroonga_score(tableoid, ctid) AS score
  FROM jsonb_table
 WHERE data->>'category' &@ 'user';
--  id | score
-- ----+-------
--   2 |     1
--   4 |     1
-- (2 rows)
```
