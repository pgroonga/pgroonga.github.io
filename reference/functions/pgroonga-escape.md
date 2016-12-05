---
title: pgroonga.escape function
upper_level: ../
---

# `pgroonga.escape` function

Since 1.1.9.

## Summary

`pgroonga.escape` function converts the given value to a literal for [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html). The literal is safely used in script syntax. Script syntax is used by [jsonb `@@` operator](../operators/jsonb-query.html) and so on.

`pgroonga.escape` function is useful to prevent Groonga command injection via [`pgroonga.command` function](pgroonga-command.html). See also [`pgroonga.command_escape_value` function](pgroonga-command-escape-value.html) and [`pgroonga.query_escape` function](pgroonga-query-escape.html) for preventing Groonga command injection.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.escape(value)
```

`value` type is one of the following types:

  * `text`

  * `boolean`

  * `int2`

  * `int4`

  * `int8`

  * `float4`

  * `float8`

  * `timestamp`

  * `timestamptz`

`value` is a literal to be used in [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html).

`pgroonga.query_escape` returns a `text` type value. The value can be used as a literal in script syntax safely.

If `value` is a `text` type value, you can specify characters to be escaped like the following:

```text
text pgroonga.escape(value, special_characters)
```

`special_characters` is a `text` type value. It contains all characters to be escaped. If you want to escape "(" and ")", you should specify `'()'`.

## Usage

Here are sample schema and data:

```sql
CREATE TABLE logs (
  message jsonb
);

CREATE INDEX pgroonga_logs_index
          ON logs
       USING pgroonga (message);

INSERT INTO logs VALUES ('{"body": "\"index.html\" not found"}');
```

If you want to search `"index.html" not found`, you need to escape `"` as `\"` like the following:

```sql
SELECT * FROM logs
 WHERE message @@ 'string @ "\"index.html\" not found"';
--                message                
-- --------------------------------------
--  {"body": "\"index.html\" not found"}
-- (1 row)
```

You can use `pgroonga.escape` function for it:

```sql
SELECT * FROM logs
 WHERE message @@ ('string @ ' || pgroonga.escape('"index.html" not found'));
--                message                
-- --------------------------------------
--  {"body": "\"index.html\" not found"}
-- (1 row)
```

`pgroonga.escape` function is also useful with [`pgroonga.command` function](pgroonga-command.html):

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_logs_index'),
                     'output_columns', 'message.string',
                     'filter', 'message.string @ ' || pgroonga.escape('"index.html" not found')
                   ])::jsonb
);
--                   jsonb_pretty                  
-- ------------------------------------------------
--  [                                             +
--      [                                         +
--          0,                                    +
--          1480435379.074671,                    +
--          0.0004425048828125                    +
--      ],                                        +
--      [                                         +
--          [                                     +
--              [                                 +
--                  1                             +
--              ],                                +
--              [                                 +
--                  [                             +
--                      "message.string",         +
--                      "LongText"                +
--                  ]                             +
--              ],                                +
--              [                                 +
--                  [                             +
--                      "",                       +
--                      "\"index.html\" not found"+
--                  ]                             +
--              ]                                 +
--          ]                                     +
--      ]                                         +
--  ]
-- (1 row)
```

You can use `pgroonga.escape` function for non `text` type value such as integer:

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_logs_index'),
                     'output_columns', '_id',
                     'filter', '_id == ' || pgroonga.escape(1)
                   ])::jsonb
);
--           jsonb_pretty          
-- --------------------------------
--  [                             +
--      [                         +
--          0,                    +
--          1480435504.153011,    +
--          0.00009799003601074219+
--      ],                        +
--      [                         +
--          [                     +
--              [                 +
--                  1             +
--              ],                +
--              [                 +
--                  [             +
--                      "_id",    +
--                      "UInt32"  +
--                  ]             +
--              ],                +
--              [                 +
--                  1             +
--              ]                 +
--          ]                     +
--      ]                         +
--  ]
-- (1 row)
```

## See also

  * [`pgroonga.command` function](pgroonga-command.html)

  * [`pgroonga.command_escape_value` function](pgroonga-command-escape-value.html)

  * [`pgroonga.query_escape` function](pgroonga-query-escape.html)
