---
title: "&? operator for jsonb type"
upper_level: ../
---

# `&?` operator for `jsonb` type

Since 1.2.1.

## Summary

`&?` operator performs full text search against all texts in `jsonb` with query.

Query's syntax is similar to syntax that is used in Web search engine. For example, you can use OR search by `KEYWORD1 OR KEYWORD2` in query.

## Syntax

```sql
column &? query
```

`column` is a column to be searched. It's `jsonb` type.

`query` is a query for full text search. It's `text` type.

[Groonga's query syntax][groonga-query-syntax] is used in `query`.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.jsonb_ops`: Default for `jsonb`

  * `pgroonga.jsonb_ops_v2`: For `jsonb`

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

You can perform full text search with multiple keywords by `&?` operator like `KEYWORD1 KEYWORD2`. You can also do OR search by `KEYWORD1 OR KEYWORD2`:

(It uses [`jsonb_pretty()` function][postgresql-jsonb-pretty] provided since PostgreSQL 9.5 for readability.)

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &? 'server OR mail';
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

## See also

  * [`jsonb` support][jsonb]

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

[jsonb]

[match-jsonb-v2]:match-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
