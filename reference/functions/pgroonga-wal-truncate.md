---
title: pgroonga_wal_truncate function
upper_level: ../
---

# `pgroonga_wal_truncate` function

## Summary

`pgroonga_wal_truncate` function truncates PGroonga's WAL. It's not PostgreSQL's WAL. PGroonga's WAL isn't deleted unless you call this function. You can delete PGroonga's WAL if you have backup.

Note that disk usage for PGroonga's WAL isn't reduced after you truncate PGroonga's WAL. The disk space already used is just reused for newly added WAL.

If you use PGroonga's WAL, you should consider about disk usage of PGroonga's WAL. If you do nothing, PGroonga's WAL keeps growing. You can choose one of them:

  1. You create backup and delete PGroonga's WAL periodically.

  2. You recreate PGroonga indexes periodically. PGroonga's WAL will be deleted at the next `VACUUM`.

## Syntax

Here is the syntax of this function:

```text
bigint pgroonga_wal_truncate(pgroonga_index_name)
```

`pgroonga_index_name` is a `text` type value. It's a PGroonga index name to be truncated.

It returns the number of truncated PostgreSQL data blocks. PGroonga's WAL is stored in PostgreSQL data blocks.

Here is another syntax of this function:

```text
bigint pgroonga_wal_truncate()
```

It truncates all WAL of all PGroonga indexes.

It returns the number of truncated PostgreSQL data blocks. PGroonga's WAL is stored in PostgreSQL data blocks.

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

Normally, you can recover the PGroonga index from PGroonga's WAL automatically. But you can't recover the PGroonga index automatically when PGroonga's WAL of the PGroonga's index is deleted (You can recover the PGroonga index by recreating the index explicitly):

```sql
SELECT pgroonga_wal_truncate('pgroonga_memos_index');
--  pgroonga_wal_truncate 
-- -----------------------
--                      2
-- (1 row)
SELECT * FROM memos WHERE content &@~ 'Groonga';
-- ERROR:  pgroonga: object isn't found: <Sources555045>
```

You can omit PGroonga index name. If you omit PGroonga index name, all WAL for all PGroonga indexes are truncated:

```sql
SELECT pgroonga_wal_truncate();
--  pgroonga_wal_truncate 
-- -----------------------
--                      2
-- (1 row)
```

## Backup and PGroonga's WAL truncation {#backup-and-pgroonga-wal-truncation}

PGroonga's data isn't crash safe. You just create backup only for PGroonga's data to reduce recover time from crash when you enable PGroonga's WAL. You don't need to create backup all PostgreSQL data. You can use [`rsync`][rsync] for backup.

Note that you must create PostgreSQL backup into other host for storage crash.

Here are sample shell script to create backup and restore from backup:

```shell
db_name="YOUR_DB_NAME"

# Detect database information
db_oid=$(psql \
  --dbname ${db_name} \
  --no-psqlrc \
  --no-align \
  --tuples-only \
  -c "SELECT datid FROM pg_stat_database WHERE datname = '${db_name}'")
data_dir=$(psql \
  --dbname ${db_name} \
  --no-psqlrc \
  --no-align \
  --tuples-only \
  -c "SHOW data_directory")

# Define directories
db_dir=${data_dir}/base/${db_oid}
backup_dir=${data_dir}/../../backup

# Create backup directory
mkdir -p ${backup_dir}

# Stop PostgreSQL
systemctl stop postgresql-10

# Create backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${db_dir}/ ${backup_dir}/

# Run PostgreSQL
systemctl start postgresql-10

# Remove PGroonga's WAL
#
# You must not change your data
# between creating backup and running pgroonga_wal_truncate
psql --dbname ${db_name} -c "SELECT pgroonga_wal_truncate()"

# ...PostgreSQL is crashed...

# Restore from backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${backup_dir}/ ${db_dir}/

# Run PostgreSQL again
systemctl restart postgresql-10
```

## See also

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga_wal_apply` function][wal-apply]

  * [`pgroonga_set_writable` function][set-writable]

[enable-wal]:../parameters/enable-wal.html

[wal-apply]:pgroonga-wal-apply.html

[set-writable]:pgroonga-set-writable.html

[rsync]:https://rsync.samba.org/
