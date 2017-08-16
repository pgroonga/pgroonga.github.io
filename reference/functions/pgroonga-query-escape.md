---
title: pgroonga_query_escape function
upper_level: ../
---

# `pgroonga_query_escape` function

Since 1.1.9.

## Summary

`pgroonga_query_escape` function escapes special characters in [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html). Query syntax is used by [`&@~` operator][query-v2], [`&@~|` operator][query-in-v2] and so on.

`pgroonga_query_escape` function is useful to prevent Groonga command injection via [`pgroonga_command` function](pgroonga-command.html). See also [`pgroonga_command_escape_value` function](pgroonga-command-escape-value.html) and [`pgroonga_escape` function](pgroonga-escape.html) for preventing Groonga command injection.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_query_escape(query)
```

`query` is a `text` type value. It uses [query syntax](http://groonga.org/docs/reference/grn_expr/query_syntax.html).

`pgroonga_query_escape` returns a `text` type value. All special characters in the value are escaped.

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

You get an error with the query "(PostgreSQL" because closed parenthesis doesn't exist:

```sql
SELECT * FROM memos WHERE content @@ '(PostgreSQL';
-- ERROR:  pgroonga: failed to parse expression: Syntax error: <(PostgreSQL||>
```

You can use the query "(PostgreSQL" as is ("(" isn't treated as a special character) by `pgroonga_query_escape` function:

```sql
SELECT * FROM memos WHERE content @@ pgroonga_query_escape('(PostgreSQL');
--                  content                 
-- -----------------------------------------
--  PGroonga (PostgreSQL+Groonga) is great!
-- (1 row)
```

The same thing is occurred with [`pgroonga_command` function](pgroonga-command.html):

```sql
SELECT jsonb_pretty(
  pgroonga_command('select ' ||
                   '--table ' || pgroonga_table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query "(PostgreSQL"')::jsonb
);
--                jsonb_pretty               
-- ------------------------------------------
--  [                                       +
--      [                                   +
--          -63,                            +
--          1480432652.751489,              +
--          0.0007565021514892578,          +
--          "Syntax error: <(PostgreSQL||>" +
--      ]                                   +
--  ]
-- (1 row)
```

`pgroonga_query_escape` function with [`pgroonga_command_escape_value` function](pgroonga-command-escape-value.html) can prevent the case:

```sql
SELECT jsonb_pretty(
  pgroonga_command('select ' ||
                   '--table ' || pgroonga_table_name('pgroonga_memos_index') || ' ' ||
                   '--match_columns content ' ||
                   '--query ' || pgroonga_command_escape_value(pgroonga_query_escape('(PostgreSQL')))::jsonb
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

You can also use arguments array style [`pgroonga_command` function](pgroonga-command.html):

```sql
SELECT jsonb_pretty(
  pgroonga_command('select',
                   ARRAY[
                     'table', pgroonga_table_name('pgroonga_memos_index'),
                     'match_columns', 'content',
                     'query', pgroonga_query_escape('(PostgreSQL')
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

  * [`pgroonga_command` function][command]

  * [`pgroonga_command_escape_value` function][command-escape-value]

  * [`pgroonga_escape` function][escape]

[query-v2]:../operators/query-v2.html

[query-in-v2]:../operators/query-in-v2.html

[command]:pgroonga-command.html
[command-escape-value]:pgroonga-command-escape-value.html
[escape]:pgroonga-escape.html
