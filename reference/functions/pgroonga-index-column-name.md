---
title: pgroonga_index_column_name function
upper_level: ../
---

# `pgroonga_index_column_name` function

Since 2.2.6.

## Summary

`pgroonga_index_column_name` function converts PGroonga's index name to Groonga's index column name. Groonga's index column name is useful to use [`object_inspect` Groonga command][groonga-object-inspect] by [`pgroonga_command` function][command]. `object_inspect` Groonga command against PGroonga's index column requires Groonga's index column name.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_index_column_name(pgroonga_index_name, column_name)
text pgroonga_index_column_name(pgroonga_index_name, column_index)
```

`pgroonga_index_name` is a `text` type value. It's an index name to be converted to Groonga's index column name. The index must be created with `USING pgroonga`.

`column_name` is a `text` type value. It's the target column name in the target PGroonga's index.

`column_index` is a `int4` type value. It's the target position in the target PGroonga's index. The position uses zero-based indexing.

## Usage

Here are sample schema:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);
CREATE INDEX pgroonga_index
          ON memos
       USING pgroonga (title, content, tag);
```

Here is a sample to use `column_index`:

```sql
SELECT pgroonga_index_column_name('pgroonga_index', 2);
--  pgroonga_index_column_name 
-- ----------------------------
--  Lexicon17780_2.index
-- (1 row)
```

Here is a sample to use `column_name`:

```sql
SELECT pgroonga_index_column_name('pgroonga_index', 'tag');
--  pgroonga_index_column_name 
-- ----------------------------
--  Lexicon17780_2.index
-- (1 row)
```

Here is a sample to use `pgroonga_index_column_name()` for [`object_inspect` Groonga command][groonga-object-inspect]:

```sql
SELECT jsonb_pretty(
  pgroonga_command('object_inspect',
                   ARRAY[
                     'name', pgroonga_index_column_name('pgroonga_index', 'tag')
                   ])::jsonb
);
                     jsonb_pretty                     
------------------------------------------------------
--  [                                                   +
--      [                                               +
--          0,                                          +
--          1593478420.606223,                          +
--          0.001304388046264648                        +
--      ],                                              +
--      {                                               +
--          "id": 272,                                  +
--          "name": "index",                            +
--          "type": {                                   +
--              "raw": {                                +
--                  "id": 72,                           +
--                  "name": "column:index"              +
--              },                                      +
--              "name": "index"                         +
--          },                                          +
--          "table": {                                  +
--              "id": 270,                              +
--              "key": {                                +
--                  "type": {                           +
--                      "id": 14,                       +
--                      "name": "ShortText",            +
--                      "size": 4096,                   +
--                      "type": {                       +
--                          "id": 32,                   +
--                          "name": "type"              +
--                      }                               +
--                  },                                  +
--                  "total_size": 0,                    +
--                  "max_total_size": 4294967294        +
--              },                                      +
--              "name": "Lexicon17780_2",               +
--              "type": {                               +
--                  "id": 49,                           +
--                  "name": "table:pat_key"             +
--              },                                      +
--              "value": {                              +
--                  "type": null                        +
--              },                                      +
--              "n_records": 0,                         +
--              "disk_usage": 4243456                   +
--          },                                          +
--          "value": {                                  +
--              "size": "normal",                       +
--              "type": {                               +
--                  "id": 263,                          +
--                  "name": "Sources17780",             +
--                  "size": 4,                          +
--                  "type": {                           +
--                      "id": 48,                       +
--                      "name": "table:hash_key"        +
--                  }                                   +
--              },                                      +
--              "weight": false,                        +
--              "section": false,                       +
--              "position": true,                       +
--              "statistics": {                         +
--                  "max_section_id": 0,                +
--                  "n_array_segments": 0,              +
--                  "n_garbage_chunks": [               +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0,                              +
--                      0                               +
--                  ],                                  +
--                  "total_chunk_size": 0,              +
--                  "n_buffer_segments": 0,             +
--                  "n_garbage_segments": 0,            +
--                  "max_in_use_chunk_id": 0,           +
--                  "max_array_segment_id": 0,          +
--                  "n_unmanaged_segments": 0,          +
--                  "max_buffer_segment_id": 0,         +
--                  "max_n_physical_segments": 131072,  +
--                  "next_physical_segment_id": 0,      +
--                  "max_in_use_physical_segment_id": 0 +
--              }                                       +
--          },                                          +
--          "sources": [                                +
--              {                                       +
--                  "id": 271,                          +
--                  "name": "tag",                      +
--                  "table": {                          +
--                      "id": 263,                      +
--                      "key": {                        +
--                          "type": {                   +
--                              "id": 11,               +
--                              "name": "UInt64",       +
--                              "size": 8,              +
--                              "type": {               +
--                                  "id": 32,           +
--                                  "name": "type"      +
--                              }                       +
--                          },                          +
--                          "total_size": 0,            +
--                          "max_total_size": 4294967295+
--                      },                              +
--                      "name": "Sources17780",         +
--                      "type": {                       +
--                          "id": 48,                   +
--                          "name": "table:hash_key"    +
--                      },                              +
--                      "value": {                      +
--                          "type": null                +
--                      },                              +
--                      "n_records": 0,                 +
--                      "disk_usage": 65536             +
--                  },                                  +
--                  "full_name": "Sources17780.tag"     +
--              }                                       +
--          ],                                          +
--          "full_name": "Lexicon17780_2.index",        +
--          "disk_usage": 565248                        +
--      }                                               +
--  ]
-- (1 row)
```

## See also

  * [`pgroonga_command` function][command]

[groonga-object-inspect]:https://groonga.org/docs/reference/commands/object_inspect.html

[command]:pgroonga-command.html
