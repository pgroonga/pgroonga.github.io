---
title: pgroonga_vacuum function
upper_level: ../
---

# `pgroonga_vacuum` function

## Summary

`pgroonga_vacuum` function removes internal unused Groonga tables, columns and records. Note that it's not for PGroonga. It's for Groonga. Normally, you don't need to call this function because PGroonga does the same process on `VACUUM`.

You need to call this function one of the following situations:

  * You remove all PGroonga indexes. If you don't have any PGroonga index, PGroonga can't run the same process on `VACUUM`.

  * You use streaming replication. You need to call this function only on slaves because `VACUUM` isn't run on slaves.

## Syntax

Here is the syntax of this function:

```text
bool pgroonga_vacuum()
```

It always returns `true`. If there is a problem in processing, an error is raised.

## Usage

Here are sample schema:

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_index ON memos USING PGroonga (content);
```

You keep the current internal Groonga table name. `\gset` and `\echo` are `psql`'s meta commands:

```sql
SELECT pgroonga_table_name('pgroonga_index')
\gset old_
\echo :old_pgroonga_table_name
-- Sources17058
```

The current internal Groonga table is changed after `REINDEX`:

```sql
REINDEX INDEX pgroonga_index;
SELECT pgroonga_table_name('pgroonga_index');
--  pgroonga_table_name 
-- ---------------------
--  Sources17059
-- (1 row)
```

The old internal Groonga table exists until `VACUUM`:

```sql
SELECT pgroonga_command('object_exist',
                        ARRAY[
                          'name', :'old_pgroonga_table_name'
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
```

You can remove the old internal Groonga table by `pgroonga_vacuum()`:

```sql
SELECT pgroonga_vacuum();
--  pgroonga_vacuum 
-- -----------------
--  t
-- (1 row)
SELECT pgroonga_command('object_exist',
                        ARRAY[
                          'name', :'old_pgroonga_table_name'
                        ])::json->>1;
--  ?column? 
-- ----------
--  false
-- (1 row)
```
