---
title: pgroonga_list_broken_indexes function
upper_level: ../
---

# `pgroonga_list_broken_indexes` function

## Summary

`pgroonga_list_broken_indexes` function displays potentially broken PGroonga indexes.

If a crash occurs while updating data, it is highly probable that PGroonga's indexes are broken.
Also, in such cases, the following two conditions are often observed.
Therefore, those conditions are considered as broken and detected.

1. The lock remains

2. Some needed files don't exist

Note that this is a simple check and may not detect broken indexes.

## Syntax

Here is the syntax of this function:

```text
SETOF text pgroonga_list_broken_indexes()
```

It get indexes that may be broken in PGroonga indexes.

It returns the following records:

```sql
 pgroonga_list_broken_indexes 
------------------------------
 pgrn_memos_index
```

## Usage

```sql
SELECT pgroonga_list_broken_indexes();
```

## Example

Here are sample schema:

```sql
CREATE TABLE memos (
  content text
);
CREATE INDEX pgrn_memos_index ON memos USING PGroonga (content);
```

No possibility of broken:

```sql
SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes
------------------------------
(0 rows)
```

Possible broken (Locks remain):

```sql
SELECT pgroonga_command(
  'lock_acquire',
  ARRAY['target_name', pgroonga_table_name('pgrn_memos_index')]
);
                 pgroonga_command
---------------------------------------------------
 [[0,1716796614.02342,6.723403930664062e-05],true]
(1 row)

SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes 
------------------------------
 pgrn_memos_index
(1 row)
```

No possibility of broken (Lock already released):

```sql
SELECT pgroonga_command(
  'lock_release',
  ARRAY['target_name', pgroonga_table_name('pgrn_memos_index')]
);
                  pgroonga_command
----------------------------------------------------
 [[0,1716796558.739785,4.720687866210938e-05],true]
(1 row)

SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes 
------------------------------
(0 rows)
```

## See also

  * [`pgroonga_command` function][command]

  * [`pgroonga_table_name` function][table-name]

[command]:pgroonga-command.html

[table-name]:pgroonga-table-name.html
