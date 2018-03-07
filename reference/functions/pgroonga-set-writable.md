---
title: pgroonga_set_writable function
upper_level: ../
---

# `pgroonga_set_writable` function

## Summary

`pgroonga_set_writable` function set whether you can change PGroonga data or not. Normally, you don't need to change it.

You can implement online backup with this function. You need to keep the following conditions to use this use case:

  * You must call `SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])` in the same session after you change your data.

  * You must disable [autovacuum][postgresql-autovacuum] for tables that use PGroonga index. You can use `autovacuum_enabled` storage parameter of [`CREATE TABLE`][postgresql-create-table] to disable autovacuum only for these tables. Note that you need to run `VACUUM` manually when you disable autovacuum.

  * You must enable PGroonga's WAL.

## Syntax

Here is the syntax of this function:

```text
bool pgroonga_set_writable(new_writable)
```

`new_writable` is a `bool` type value. `true` means writable and `false` is read-only.

It returns whether writable or not before changing the current state.

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

You can't change the PGroonga index after you pass `false` to `pgroonga_set_writable` function:

```sql
SELECT pgroonga_set_writable(false);
--  pgroonga_set_writable 
-- -----------------------
--  t
-- (1 row)
INSERT INTO memos VALUES ('Groonga is great!');
-- ERROR:  pgroonga: can't insert a record while pgroonga.writable is false
```

```sql
SELECT pgroonga_set_writable(true);
--  pgroonga_set_writable 
-- -----------------------
--  f
-- (1 row)
INSERT INTO memos VALUES ('Groonga is great!');
-- INSERT 0 1
```

## Online backup {#online-backup}

You can implement online backup with this function. You need to keep the following conditions to use this use case:

  * You must call `SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])` in the same session after you change your data.

  * You must disable [autovacuum][postgresql-autovacuum] for tables that use PGroonga index. You can use `autovacuum_enabled` storage parameter of [`CREATE TABLE`][postgresql-create-table] to disable auto vacuum only for these tables. Note that you need to run `VACUUM` manually when you disable auto vacuum.

  * You must enable PGroonga's WAL.

You must add the following configuration to your `postgresql.conf`:

```text
pgroonga.enable_wal = yes
```

You must disable autovacuum:

```sql
CREATE TABLE memos (
  content text
) WITH (autovacuum_enabled = false);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);
```

You must call `SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])` in the same session after you change your data:

```sql
INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

It's recommended that you run [`VACUUM`][postgresql-vacuum] manually before you create backup:

```sql
VACUUM ANALYZE memos;
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

You must make your PGroonga data read-only before you create backup:

```sql
SELECT pgroonga_set_writable(false);
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

Now, you can create backup without stopping PostgreSQL:

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

# Create backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${db_dir}/ ${backup_dir}/
```

It's recommended that your PGroonga's WAL is truncated. You can run [`pgroonga_wal_truncate` function][wal-truncate] in read-only mode:

```sql
SELECT pgroonga_wal_truncate();
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

If you truncate PGroonga's WAL, you must create backup again with the above shell script. The process will be fast because `rsync` copies only different data.

You must make your PGroonga data writable again:

```sql
SELECT pgroonga_set_writable(true);
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

## See also

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga_wal_truncate` function][wal-truncate]

[postgresql-autovacuum]:{{ site.postgresql_doc_base_url.en }}/routine-vacuuming.html#AUTOVACUUM

[postgresql-create-table]:{{ site.postgresql_doc_base_url.en }}/sql-createtable.html

[postgresql-vacuum]:{{ site.postgresql_doc_base_url.en }}/sql-vacuum.html

[enable-wal]:../parameters/enable-wal.html

[wal-truncate]:pgroonga-wal-truncate.html
