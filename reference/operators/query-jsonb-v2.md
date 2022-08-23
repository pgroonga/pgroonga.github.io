---
title: "&@~ operator for jsonb type"
upper_level: ../
---

# `&@~` operator for `jsonb` type

Since 1.2.1.

`&?` operator is deprecated since 1.2.2. Use `&@~` operator instead.

## Summary

`&@~` operator performs full text search against all texts in `jsonb` with query.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query.

## Syntax

```sql
column &@~ query
```

`column` is a column to be searched. It's `jsonb` type.

`query` is a query for full text search. It's `text` type.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga_jsonb_ops_v2`: Default for `jsonb`

  * `pgroonga_jsonb_ops`: For `jsonb`

## Usage

Here are sample schema and data for examples:

```sql
CREATE TABLE logs (
  record jsonb
);

CREATE INDEX pgroonga_logs_index ON logs USING pgroonga (record);

INSERT INTO logs
     VALUES ('{
                "message": "Server is started.",
                "host":    "www.example.com",
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "GET /",
                "host":    "www.example.com",
                "code":    200,
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "Send to <info@example.com>.",
                "host":    "mail.example.net",
                "tags": [
                  "mail",
                  "example.net"
                ]
              }');
```

You can perform full text search with multiple keywords by `&@~` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

(It uses [`jsonb_pretty()` function][postgresql-jsonb-pretty] provided since PostgreSQL 9.5 for readability.)

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'server OR mail';
--                  jsonb_pretty                 
-- ----------------------------------------------
--  {                                           +
--      "host": "www.example.com",              +
--      "tags": [                               +
--          "web",                              +
--          "example.com"                       +
--      ],                                      +
--      "message": "Server is started."         +
--  }
--  {                                           +
--      "host": "mail.example.net",             +
--      "tags": [                               +
--          "mail",                             +
--          "example.net"                       +
--      ],                                      +
--      "message": "Send to <info@example.com>."+
--  }
-- (2 rows)
```

## Important note for better pgroonga performance: If you want to search on specific key values in your jsonb column, you need to create indexes on all of your json keys that you want to search

When you use `&@~` operator to search through specific key values in your jsonb column, not just the entire jsonb column like the previous examples, then you need to index each of these keys. Without creating these indexes, `&@~` operator only uses sequential search and the query performance will be slow.

Here is a demo, using previous “logs” table example:

```sql
-- This query uses pgroonga index so that performance is great
SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'get';
--           jsonb_pretty          
-- --------------------------------
--  {                             +
--      "code": 200,              +
--      "host": "www.example.com",+
--      "tags": [                 +
--          "web",                +
--          "example.com"         +
--      ],                        +
--      "message": "GET /"        +
--  }
-- (1 row)


-- This query does not use pgroonga index, just sequential search (slow)
SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
--           jsonb_pretty          
-- --------------------------------
--  {                             +
--      "code": 200,              +
--      "host": "www.example.com",+
--      "tags": [                 +
--          "web",                +
--          "example.com"         +
--      ],                        +
--      "message": "GET /"        +
--  }
-- (1 row)

-- Just run EXPLAIN ANALYZE on these queries and see it for yourself.
-- Searching on entire jsonb record column uses Index.
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'get';
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on public.logs  (cost=0.00..21.03 rows=1 width=32) (actual time=1.577..1.578 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Recheck Cond: (logs.record &@~ 'get'::text)
--    Heap Blocks: exact=1
--    ->  Bitmap Index Scan on pgroonga_logs_index  (cost=0.00..0.00 rows=14 width=0) (actual time=1.566..1.566 rows=1 loops=1)
--          Index Cond: (logs.record &@~ 'get'::text)
--  Planning Time: 0.680 ms
--  Execution Time: 1.631 ms
-- (8 rows)


-- But when you search on specific key value in jsonb column, it DOES NOT USE Index 
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
--                                                QUERY PLAN                                                
-- ---------------------------------------------------------------------------------------------------------
--  Seq Scan on public.logs  (cost=0.00..1047.00 rows=1 width=32) (actual time=0.422..0.566 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Filter: ((logs.record -> 'message'::text) &@~ 'get'::text)
--    Rows Removed by Filter: 2
--  Planning Time: 0.035 ms
--  Execution Time: 0.576 ms
-- (6 rows)
```

Now let's create an index of “message” key value in your record jsonb column: 

```sql
-- Create "message" key value index for your record jsonb column
CREATE INDEX pgroonga_message_index ON logs USING pgroonga ((record->'message'));

-- Before you execute EXPLAIN ANALYZE, you need to set sequential scan off
-- to make sure it uses pgroonga index.
-- Note: Do not set enable_seqscan = off on production environment
SET enable_seqscan = off;

-- Analyze the query: Now it uses pgroonga index
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
--                                                               QUERY PLAN                                                               
-- ---------------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgroonga_message_index on public.logs  (cost=0.00..4.01 rows=1 width=32) (actual time=2.389..2.393 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Index Cond: ((logs.record -> 'message'::text) &@~ 'get'::text)
--  Planning Time: 0.201 ms
--  Execution Time: 2.496 ms
-- (5 rows)

```


## If you don’t know which jsonb key value should be indexed beforehand, then you should use `` &` `` operator instead

Because of the nature of unstructured data, like json/jsonb data in this case, it is sometimes difficult to specify which key values to be indexed beforehand. (Say you need to store some user’s input which you don’t know what kind of data structure they use, and later user requests you to implement a search feature for that data.)
In that case, you should use  `` &` ``  operator that can still use “pgroonga_jsonb_ops_v2 “ index without specifying which key values should be indexed.

Let’s see an example:

```sql
CREATE TABLE logs (
  record jsonb
);

-- Create index on your jsonb field (not any of its key values)
CREATE INDEX pgroonga_logs_index ON logs USING pgroonga (record);

INSERT INTO logs
     VALUES ('{
                "message": "Server is started.",
                "host":    "www.example.com",
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "GET /",
                "host":    "www.example.com",
                "code":    200,
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "Send to <info@example.com>.",
                "host":    "mail.example.net",
                "tags": [
                  "mail",
                  "example.net"
                ]
              }');

-- Now without creating any key values indexes, you can still use pgroonga index with &` operator to fully enjoy pgroonga performance
EXPLAIN ANALYZE VERBOSE SELECT * FROM logs WHERE record &` '(paths @ "message") && query("string", "get")';
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on public.logs  (cost=0.00..21.03 rows=1 width=32) (actual time=1.020..1.022 rows=1 loops=1)
--    Output: record
--    Recheck Cond: (logs.record &` '(paths @ "message") && query("string","get")'::text)
--    Heap Blocks: exact=1
--    ->  Bitmap Index Scan on pgroonga_logs_index  (cost=0.00..0.00 rows=14 width=0) (actual time=1.012..1.013 rows=1 loops=1)
--          Index Cond: (logs.record &` '(paths @ "message") && query("string","get")'::text)
--  Planning Time: 0.379 ms
--  Execution Time: 1.077 ms
-- (8 rows)
```

Hope all these examples help you to create some great applications 😄

## See also

  * [`jsonb` support][jsonb]

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

  * [Groonga's query syntax][groonga-query-syntax]

[jsonb]:../jsonb.html

[match-jsonb-v2]:match-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
