---
title: pgroonga_wal_set_applied_position function
upper_level: ../
---

# `pgroonga_wal_set_applied_position` function

Since 3.1.5.

## Summary

`pgroonga_wal_set_applied_position` function sets WAL position that is already applied. Normally, you don't need to use this function because WAL position that is already applied isn't invalid.

## Syntax

Here is the syntax of this function:

```text
bool pgroonga_wal_set_applied_position()
bool pgroonga_wal_set_applied_position(pgroonga_index_name)
bool pgroonga_wal_set_applied_position(block, offset)
bool pgroonga_wal_set_applied_position(pgroonga_index_name, block, offset)
```

`pgroonga_index_name` is a `text` type value. It's a PGroonga index name to be set WAL applied position. If this is omitted, all PGroonga indexes are targeted.

`block` and `offset` are `bigint` type values. They specify position by a block number and an offset in the block. If they are omitted, this function sets the last block and offset. It means that all existing WAL are applied. Normally, they are omitted because specifying valid block and offset is difficult.

Note that you can see the current WAL positions by [`pgroonga_wal_status` function][wal-status].

It returns `true` on success, `false` otherwise. But `false` will not be returned because an error is raised on error.

## Usage

Here are sample schema and data:

```sql
SET pgroonga.enable_wal = yes;

CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);

INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
```

Simulate a PGroonga index is removed but WAL is still alive situation:

```sql
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', 'Lexicon' ||
                                  'pgroonga_memos_index'::regclass::oid ||
                                  '_0'
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', pgroonga_table_name('pgroonga_memos_index')
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
```

In this situation, `SELECT` that uses the PGroonga index raises an error:

```sql
SET enable_seqscan = no;
SELECT * FROM memos WHERE content &@~ 'PGroonga';
--- ERROR:  pgroonga: object isn't found: <Sources17853>
```

We can re-create the removed index by re-applying existing WAL. To do this, we can set WAL applied position to the beginning (both of `block` and `offset` are `0`):

```sql
SELECT pgroonga_wal_set_applied_position('pgroonga_memos_index', 0, 0);
--  pgroonga_wal_set_applied_position 
-- -----------------------------------
--  t
-- (1 row)
```

The pending WAL are automatically applied when the PGroonga index is used:

```sql
SELECT * FROM memos WHERE content &@~ 'PGroonga';
--                  content                 
-- -----------------------------------------
--  PGroonga (PostgreSQL+Groonga) is great!
-- (1 row)
```

## See also

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga_wal_status` function][wal-status]

[enable-wal]:../parameters/enable-wal.html

[wal-status]:pgroonga-wal-status.html
