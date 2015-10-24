---
title: "@>演算子"
layout: ja
---

# `@>`演算子

## 概要

PGroongaは`@>`演算子の検索をインデックスを使って高速に実現できます。

[`@>` is a built-in PostgreSQL operator](http://www.postgresql.org/docs/current/static/functions-json.html#FUNCTIONS-JSONB-OP-TABLE). `@>` returns true when the right hand side `jsonb` is a subset of left hand side `jsonb`.

## 構文

Here is the syntax of this operator:

```sql
jsonb_column @> jsonb_query
```

`jsonb_column` is a column that its type is `jsonb`.

`jsonb_query` is a `jsonb` value used as query.

The operator returns `true` when `jsonb_query` is a sub set of `jsonb_column` value, `false` otherwise.

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

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

シーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

Here is an example for match case:

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数](http://www.postgresql.jp/document/current/html/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE)を使っています。）

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

If you use an array in the condition `jsonb` value, all elements must be included in the search target `jsonb` value. Position of element isn't cared. If there are one or more elements that are included in the condition `jsonb` value but aren't included in the search target `jsonb` value, record that have the search target `jsonb` value isn't matched.

In the following example, there are records that have only `"mail"` or `"web"` but there are no records that have both `"mail"` and `"web"`. So the following `SELECT` returns no record:

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"tags": ["mail", "web"]}'::jsonb;
--  jsonb_pretty 
-- --------------
-- (0 rows)
```

## 参考

  * [`jsonb` support](../jsonb.html)
  * [`@@` operator](jsonb-query.html)
