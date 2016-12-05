---
title: pgroonga.command_escape_value function
upper_level: ../
---

# `pgroonga.command_escape_value` function

Since 1.1.9.

## Summary

`pgroonga.command_escape_value` function escapes special characters in "value" part of Groonga command format.

Here is an example Groonga command format:

```text
select --table Logs --match_columns message --query Error
```

`select` is the command name. `--XXX YYY` is argument name and value. `XXX` is argument name. `YYY` is argument value. For example `table` is argument name and `Logs` is argument value in `--table Logs`.

`pgroonga.command_escape_value` function is useful to prevent Groonga command injection via [`pgroonga.command` function](pgroonga-command.html). See also [`pgroonga.query_escape` function](pgroonga-query-escape.html) and [`pgroonga.escape` function](pgroonga-escape.html) for preventing Groonga command injection.

If you use `pgroonga.command(command, ARRAY[arguments...])` style, you don't need to use this function. Because the style do the same thing of this function internally.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.command_escape_value(value)
```

`value` is a `text` type value. It's a "value" part of Groonga command format.

`pgroonga.command_escape_value` returns a `text` type value. All special characters in the text are escaped.

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

You get an error with the query "(PostgreSQL" because "(" is a special character:

```sql
SELECT jsonb_pretty(
  pgroonga.command('select ' ||
                   '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query (PostgreSQL')::jsonb
);
--                      jsonb_pretty                      
-- -------------------------------------------------------
--  [                                                    +
--      [                                                +
--          -22,                                         +
--          1480483949.578879,                           +
--          0.0002233982086181641,                       +
--          "[select][table] invalid name: <PostgreSQL>",+
--          [                                            +
--              [                                        +
--                  "grn_select",                        +
--                  "proc_select.c",                     +
--                  2973                                 +
--              ]                                        +
--          ]                                            +
--      ]                                                +
--  ]
-- (1 row)
```

`pgroonga.command_escape_value` function with [`pgroonga.query_escape` function](pgroonga-qurey-escape.html) can prevent the case:

```sql
SELECT jsonb_pretty(
  pgroonga.command('select ' ||
                   '--table ' || pgroonga.table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query ' || pgroonga.command_escape_value(pgroonga.query_escape('(PostgreSQL')))::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480432832.061276,                                +
--          0.0252687931060791                                +
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

You can also use arguments array style [`pgroonga.command` function](pgroonga-command.html):

```sql
SELECT jsonb_pretty(
  pgroonga.command('select',
                   ARRAY[
                     'table', pgroonga.table_name('pgroonga_memos_index'),
                     'match_columns', 'content',
                     'query', pgroonga.query_escape('(PostgreSQL')
                   ])::jsonb
);
--                         jsonb_pretty                        
-- ------------------------------------------------------------
--  [                                                         +
--      [                                                     +
--          0,                                                +
--          1480433038.482539,                                +
--          0.0001201629638671875                             +
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

## See also

  * [`pgroonga.command` function](pgroonga-command.html)

  * [`pgroonga.query_escape` function](pgroonga-query-escape.html)

  * [`pgroonga.escape` function](pgroonga-escape.html)
