---
title: pgroonga_index_column_name function
upper_level: ../
---

# `pgroonga_index_column_name` function

## Summary

The indexes of PGroonga have been managed as a database of Groonga that is running at the backend of PGroonga.
This function outputs the name of PGroonga's index on the database of Groonga.

It useful when we confirm the detail of the index by the `object_inspect` command.

Normally, first of all, we get lists of tables on the database of Groonga by the `table_list` command.

```sql
SELECT jsonb_pretty(pgroonga_command('table_list')::jsonb);
```

A table beginning with a `Lexicon` in this list is a table for the index.
We can get information about the index by executing `object_inslect` by the name of this table.

```sql
SELECT * FROM jsonb_each(((pgroonga_command('object_inspect Lexicon17072_0.index')::jsonb)->1->'value'));
```

However, it is difficult that specify a table that has a specific index on this procedure.
Especially, if the table have multiple Pgroonga's indexes, we specify a target index difficultly.

We can get the name of the table that stores information of specific the index simply by `pgroonga_index_column_name`.
Because `pgroonga_index_column_name` can specify the target index in an argument.
Therefoure, we don't execute `table_list` command, we don't need found target table from many tables.

## Syntax

Here is the syntax of this function:

```text
text pgroonga_index_column_name(pgroonga_index_name, column_name)
text pgroonga_index_column_name(pgroonga_index_name, column_index)
```

`pgroonga_index_name` is a `text` type value. We specify PGroonga's index name.

The second argument has two patterns as below.

* `column_name` is a `text` type value. We specify the column name of the target of PGroonga's index.

* `column_index` is a `int4` type value. We specify the position of the column of the target of PGroonga's index.
  This position starts with `0`.

## Usage

Here are sample schema and data when we specify index position:

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
SELECT pgroonga_index_column_name('pgroonga_index', 2);

 pgroonga_index_column_name 
----------------------------
 Lexicon17765_2.index
(1 row)
```

Here are sample schema and data when we specify index name:

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
SELECT pgroonga_index_column_name('pgroonga_index', 'tag');

 pgroonga_index_column_name 
----------------------------
 Lexicon17765_2.index
(1 row)
```

Here are sample schema and data when we get information of index by `pgroonga_index_column_name`:

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
SELECT * FROM jsonb_each(
                          (
                            (
                              pgroonga_command(
                                'object_inspect',
                                ARRAY[
                                  'name', pgroonga_index_column_name('pgroonga_index', 'tag')
                                ]
                              )::jsonb
                            )->1->'value'
                          )
                        );
    key     |    value
------------+----------------------------------------------------------------------------------------------
 size       | "normal"
 type       | {"id": 263, "name": "Sources21220", "size": 4, "type": {"id": 48, "name": "table:hash_key"}}
 weight     | false
 section    | false
 position   | true
 statistics | {"max_section_id": 0, "n_array_segments": 0, "n_garbage_chunks": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "total_chunk_size": 0, "n_buffer_segments": 0, "n_garbage_segments": 0, "max_in_use_chunk_id": 0, "max_array_segment_id": 0, "n_unmanaged_segments": 0, "max_buffer_segment_id": 0, "max_n_physical_segments": 131072, "next_physical_segment_id": 0, "max_in_use_physical_segment_id": 0}
(6 rows)
```
