---
title: pgroonga.command function
---

# `pgroonga.command` function

## Summary

`pgroonga.command` function executes a [Groonga command](http://groonga.org/docs/reference/command.html) and returns the result as `text` type value.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.command(command)
```

`command` is a `text` type value. `pgroonga.command` executes `command` as a Groonga command.

Here is another syntax of this function. It can be used since 1.1.9:

```text
text pgroonga.command(name,
                      ARRAY[argument_name1, argument_value1,
                            argument_name2, argument_value2,
                            ...])
```

The second syntax is recommended because it escapes argument values automatically. It prevents syntax error and Groonga command injection.

`name` is a `text` type value. It's a command name to be executed.

`argument_name` is a `text` type value. It's an argument name followed by the corresponded argument value.

`argument_value` is a `text` type value. It's an argument value of the preceding argument name.

`pgroonga.command` builds a Groonga command from `name` and `argument_name`s and `argument_value`s and executes the built Groonga command.

Groonga command returns result as JSON. `pgroonga.command` returns the JSON as `text` type value. You can use [JSON functions and operations provided by PostgreSQL]({{ site.postgresql_doc_base_url.en }}/functions-json.html) by casting the result to `json` or `jsonb` type.

## Usage

Here are sample schema and data:

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);

INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
```

Here is an example to run [`status` Groonga command](http://groonga.org/en/docs/reference/commands/status.html) that doesn't have any arguments:

```sql
SELECT jsonb_pretty(pgroonga.command('status')::jsonb);
--               jsonb_pretty               
-- -----------------------------------------
--  [                                      +
--      [                                  +
--          0,                             +
--          1480484730.607103,             +
--          0.0001363754272460938          +
--      ],                                 +
--      {                                  +
--          "uptime": 859,                 +
--          "version": "6.1.0-53-g460b5c9",+
--          "n_queries": 6,                +
--          "starttime": 1480483871,       +
--          "start_time": 1480483871,      +
--          "alloc_count": 14034,          +
--          "cache_hit_rate": 0.0,         +
--          "command_version": 1,          +
--          "max_command_version": 3,      +
--          "default_command_version": 1   +
--      }                                  +
--  ]
-- (1 row)
```

Here is an example to search inserted data. You can use [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html) for the purpose. You need to convert PGroonga index name to Groonga table name by [`pgroonga.table_name` function](pgroonga-table-name.html).

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select ' ||
    '--table ' || pgroonga.table_name('pgroonga_memos_index')
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480484984.533947,                                +
--          0.0005786418914794922                             +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

Here is an example that searches records that contains "PostgreSQL" and "Groonga". Note that you need to quote "PostgreSQL Groonga" to treat as one argument value:

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select ' ||
    '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
    '--match_columns content ' ||
    '--query "PostgreSQL Groonga"'
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480485153.923481,                                +
--          0.002448797225952148                              +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

If you use arguments array style, you don't need to care about quoting:

```sql
SELECT jsonb_pretty(
  pgroonga.command(
    'select',
    ARRAY[
      'table', pgroonga.table_name('pgroonga_memos_index'),
      'match_columns', 'content',
      'query', 'PostgreSQL Groonga'
    ]
  )::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480485246.841189,                                +
--          0.00008869171142578125                            +
--      ],                                                    +
--      [                                                     +
--          [                                                 +
--              [                                             +
--                  1                                         +
--              ],                                            +
--              [                                             +
--                  [                                         +
--                      "_id",                                +
--                      "UInt32"                              +
--                  ],                                        +
--                  [                                         +
--                      "content",                            +
--                      "LongText"                            +
--                  ],                                        +
--                  [                                         +
--                      "ctid",                               +
--                      "UInt64"                              +
--                  ]                                         +
--              ],                                            +
--              [                                             +
--                  1,                                        +
--                  "PGroonga (PostgreSQL+Groonga) is great!",+
--                  1                                         +
--              ]                                             +
--          ]                                                 +
--      ]                                                     +
--  ]
-- (1 row)
```

## Attention for `select` Groonga command {#attention}

You need to take care about invalid tuples when you use [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html).

See [`pgroonga_tuple_is_alive` Groonga function](../groonga-functions/pgroonga-tuple-is-alive.html) for details.

## See also

  * [Examples in tutorial](../../tutorial/#groonga)

  * [`pgroonga.table_name` function](pgroonga-table-name.html)

  * [`pgroonga_tuple_is_alive` Groonga function](../groonga-functions/pgroonga-tuple-is-alive.html)
