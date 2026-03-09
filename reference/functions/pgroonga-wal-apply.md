---
title: pgroonga_wal_apply function
upper_level: ../
---

# `pgroonga_wal_apply` function

## Summary

`pgroonga_wal_apply` function applies pending WAL. Normally, you don't need to use this function because PGroonga applies pending WAL automatically when `INSERT`, `DELETE`, `UPDATE`, `SELECT` and so on are executed.

## Syntax

Here is the syntax of this function:

```text
bigint pgroonga_wal_apply(pgroonga_index_name)
```

`pgroonga_index_name` is a `text` type value. It's a PGroonga index name to be applied pending WAL.

It returns the number of applied operations.

Here is another syntax of this function:

```text
bigint pgroonga_wal_apply()
```

It applies pending WAL of all PGroonga indexes.

It returns the number of applied operations.

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

Simulate PGroonga database is destroyed situation:

```sql
SELECT pgroonga_command('delete',
                        ARRAY[
                          'table', 'IndexStatuses',
                          'key', 'pgroonga_memos_index'::regclass::oid::text
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
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

Now, there are pending WAL. You can apply the pending WAL explicitly:

```sql
SELECT pgroonga_wal_apply('pgroonga_memos_index');
--  pgroonga_wal_apply 
-- --------------------
--                   7
-- (1 row)
```

You can omit PGroonga index name. If you omit PGroonga index name, all pending WAL for all PGroonga indexes are applied explicitly:

```sql
SELECT pgroonga_wal_apply();
--  pgroonga_wal_apply 
-- --------------------
--                   7
-- (1 row)
```

## See also

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga_wal_truncate` function][wal-truncate]

[enable-wal]:../parameters/enable-wal.html

[wal-truncate]:pgroonga-wal-truncate.html
