---
title: "&` operator for jsonb type"
upper_level: ../
---

# `` &`` `` operator for `jsonb` type

Since 1.2.1.

## Summary

`` &` `` operator is a PGroonga original operator. You can use complex condition that can't be written by [`@>` operator][contain-jsonb] such as range search.

If you know [JsQuery][jsquery], you can understand like "PGroonga provides `jsonb` type related search features that are similar to JsQuery with different syntax".

## Syntax

Here is the syntax of this operator:

```sql
jsonb_column &` condition
```

`jsonb_column` is a column that its type is `jsonb`.

`condition` is a `text` value used as query. It uses [Groonga's script syntax][groonga-script-syntax].

The operator returns `true` when `condition` matches `jsonb_column` value, `false` otherwise.

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

Disable sequential scan:

```sql
SET enable_seqscan = off;
```

You need to understand how PGroonga creates index against `jsonb` type value to create search condition.

PGroonga splits a `jsonb` type value into values and then creates indexes against these values. In SQL, think about the following schema:

```sql
CREATE TABLE values (
  key text PRIMARY KEY,
  path text,
  paths text[],
  type text,
  boolean boolean,
  number double precision,
  string text,
  size numeric
);
```

Here are descriptions of column:

  * `key`: The ID of the value. If value has the same path and content, `key` is the same value. Key format is `'${PATH}|${TYPE}|${VALUE}'`. It's not used in search condition.

  * `path`: The path of the value from root. It uses [jq][jq] compatible format. Object is `["${ELEMENT_NAME}"]`, array is `[]`. For example, the path of `"web"` in `{"tags": ["web"]}` is `.["tags"][]`. If you know absolute path of the value, you can use this value in search condition.

  * `paths`: The paths of the value. It includes absolute path, sub paths, `.${ELEMENT_NAME1}.${ELEMENT_NAME2}` format paths and paths without array. This column is convenient for search condition because you can use one of them for search condition. Here are paths for `"x"` in `{"a": {"b": "c": ["x"]}}`:

     * `.a.b.c`
     * `.["a"]["b"]["c"]`
     * `.["a"]["b"]["c"][]`
     * `a.b.c`
     * `["a"]["b"]["c"]`
     * `["a"]["b"]["c"][]`
     * `b.c`
     * `["b"]["c"]`
     * `["b"]["c"][]`
     * `c`
     * `["c"]`
     * `["c"][]`
     * `[]`

  * `type`: The type of the value. This column value is one of them:

    * `"object"`: Object. No value.

    * `"array"`: Array. The number of elements is stored in `size` column.

    * `"boolean"`: Boolean. The value is stored in `boolean` column.

    * `"number"`: Number. The value is stored in `number` column.

    * `"string"`: String. The value is stored in `string` column.

  * `boolean`: The value if `type` column value is `"boolean"`, `false` otherwise.

  * `number`: The value if `type` column value is `"number"`, `0` otherwise.

  * `string`: The value if `type` column value is `"string"`, `""` otherwise.

  * `size`: The number of elements if `type` column value is `"array"`, `0` otherwise.

Here is a sample JSON:

```json
{
  "message": "GET /",
  "host":    "www.example.com",
  "code":    200,
  "tags": [
    "web",
    "example.com"
  ]
}
```

The JSON is split to the following values. (They are part of all split values.)

| key | path | paths | type | boolean | number | string | size |
| --- | ---- | ----- | ---- | ------- | ------ | ------ | ---- |
| `.|object` | `.` | `[.]` | `object` | | | | |
| `.["message"]|string|GET /` | `.["message"]` | `[.message, .["message"], message, ["message"]]` | `string` | | | `GET /` | |
| `.["tags"][]|string|web` | `.["tags"]` | `[.tags, .["tags"], .["tags"][], tags, ["tags"], ["tags"][], []]` | `string` | | | `web` | |

You specify condition that matches split value to `` &` `` operator. If there is one or more split values that match specified condition in `jsonb` type value, the `jsonb` type value is matched.

Here is a condition that searches `jsonb` type value that has `www.example.com` string:

(It uses [`jsonb_pretty()` function][postgresql-jsonb-pretty] provided since PostgreSQL 9.5 for readability.)

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'string == "www.example.com"';
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

Here is a condition that searches `jsonb` type value that has number between `200` to `299` as `code` column value. The condition uses `paths @ "..."` syntax to use simple path format (`.code`) to specify path.

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'paths @ ".code" && number >= 200 && number < 300';
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
```

Here is a condition for full text search from all text values in `jsonb` value type:

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'string @ "started"';
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
-- (1 row)
```

You can use [Groonga's query syntax][groonga-query-syntax] (`a OR b` can be used) for full text search by `query("string", "...")` syntax:

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'query("string", "send OR server")';
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

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

[jsonb]:../jsonb.html

[contain-jsonb]:contain-jsonb.html

[jsquery]:https://github.com/postgrespro/jsquery

[jq]:https://stedolan.github.io/jq/

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html

[groonga-script-syntax]:http://groonga.org/docs/reference/grn_expr/script_syntax.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
