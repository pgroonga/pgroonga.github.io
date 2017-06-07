---
title: "@> operator"
upper_level: ../
---

# `@>` operator

## Summary

PGroonga supports fast index search by `@>` operator.

[`@>` operator is a built-in PostgreSQL operator][postgresql-jsonb-operators]. `@>` operator returns `true` when the right hand side `jsonb` type value is a subset of left hand side `jsonb` type value.

## Syntax

Here is the syntax of this operator:

```sql
column @> query
```

`column` is a column to be searched. It's `jsonb` type.

`query` is a `jsonb` type value used as query.

The operator returns `true` when `query` is a subset of `column` value, `false` otherwise.

## Operator classes

You need to specify one of the following operator classes to use this operator:

  * `pgroonga.jsonb_ops`: Default for `jsonb`.

  * `pgroonga.jsonb_ops_v2`: For `jsonb`.

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

Disable sequential scan:

```sql
SET enable_seqscan = off;
```

Here is an example for match case:

(It uses [`jsonb_pretty()` function][postgresql-jsonb-pretty] provided since PostgreSQL 9.5 for readability.)

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"host": "www.example.com"}'::jsonb;
--             jsonb_pretty             
-- -------------------------------------
--  {                                  +
--      "host": "www.example.com",     +
--      "tags": [                      +
--          "web",                     +
--          "example.com"              +
--      ],                             +
--      "message": "Server is started."+
--  }
--  {                                  +
--      "code": 200,                   +
--      "host": "www.example.com",     +
--      "tags": [                      +
--          "web",                     +
--          "example.com"              +
--      ],                             +
--      "message": "GET /"             +
--  }
-- (2 rows)
```

Here is an example for not match case.

If you use an array in the search condition `jsonb` type value, all elements must be included in the search target `jsonb` type value. Position of element isn't cared. If there are one or more elements that are included in the search condition `jsonb` type value but aren't included in the search target `jsonb` type value, record that have the search target `jsonb` type value isn't matched.

In the following example, there are records that have only `"mail"` or `"web"` but there are no records that have both `"mail"` and `"web"`. So the following `SELECT` returns no record:

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"tags": ["mail", "web"]}'::jsonb;
--  jsonb_pretty 
-- --------------
-- (0 rows)
```

## See also

  * [`jsonb` support][jsonb]

  * [`&?` operator][query-jsonb-v2]

  * [`` &` `` operator][script-jsonb-v2]

[jsonb]:../jsonb.html

[query-jsonb-v2]:query-jsonb-v2.html

[script-jsonb-v2]:script-jsonb-v2.html

[postgresql-jsonb-operators]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSONB-OP-TABLE

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
