---
title: "&? operator for jsonb type"
upper_level: ../
---

# `$?` operator for `jsonb` type

## 概要

`$?` operator performs full text search against all texts in `jsonb` with query.

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column &? query
```

`column` is a column to be searched. It's `jsonb` type.

`query`は全文検索で使うクエリーです。`text`型です。

`query`では[Groongaのクエリー構文](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を使います。

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

`@?`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して全文検索できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数]({{ site.postgresql_doc_base_url.ja }}/functions-json.html#functions-json-processing-table)を使っています。）

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

## 参考

  * [`jsonb` support](../jsonb.html)

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

[match-jsonb-v2]:match-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html
