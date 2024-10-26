---
title: pgroonga-primary-maintainer.sh command
upper_level: ../
---

# `pgroonga-primary-maintainer.sh` command

Since 3.2.1.

## Notices

If PostgreSQL is 15 or higher, please use [the `pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager]. Using that module is a better way to suppress the size of the WAL.

## Summary

`pgroonga-primary-maintainer.sh` command runs `REINDEX INDEX CONCURRENTLY` on indexes for which PGroonga's WAL size exceeds the threshold.

The purpose is to suppress the size of the WAL on primary servers that have WAL enabled (set `pgroonga.enable_wal = yes`).

Notes:

* This command is assumes to run in primary, so do not run it in standby.

* This command assumes periodic execution, so please use [`pgroonga-generate-primary-maintainer-service.sh` command][generate-primary-maintainer-service] and [`pgroonga-generate-primary-maintainer-timer.sh` command][generate-primary-maintainer-timer]  to set up periodic execution.

## Usage

```
pgroonga-primary-maintainer.sh --threshold REINDEX_THRESHOLD_SIZE [--psql PSQL_COMMAND_PATH]

Options:
-t, --threshold:
  If the specified value is exceeded, `REINDEX INDEX CONCURRENTLY` is run.
  Specify by size.
  Example: --threshold 10M, -t 1G
-c, --psql:
  Specify the path to `psql` command.
-h, --help:
  Display help text and exit.

Connection information such as `dbname` should be set in environment variables.
See also: https://www.postgresql.org/docs/current/libpq-envars.html
```

* `--threshold` option

  * If the size of WAL exceeds the specified value,, `REINDEX INDEX CONCURRENTLY` is run

* `--psql` option

  * If `psql` command is installed in a custom path, specify the path for `psql` command

* Environment variable

  * Specify connection information to DB in environment variables

  * [PostgreSQL Environment Variables][postgresql-environment-variables]

## Example

Here is an example of configuring the systemd timer in [`pgroonga-generate-primary-maintainer-service.sh` command][generate-primary-maintainer-service] and [`pgroonga-generate-primary-maintainer-timer.sh` command][generate-primary-maintainer-timer] for use in a periodic execution.

See [`pgroonga-generate-primary-maintainer-service.sh` command][generate-primary-maintainer-service] and [`pgroonga-generate-primary-maintainer-timer.sh` command][generate-primary-maintainer-timer] for details on creating a configuration file.

In this example, it was specified with `--threshold 20K`. This is the size at which REINDEX will run if `last_block >= 2`.

### Execute query

```sql
CREATE TABLE notes (content text);
CREATE INDEX notes_index ON notes USING pgroonga (content);
INSERT INTO notes SELECT 'NOTES' FROM generate_series(1, 200);
DELETE FROM notes;
```

Check `pgroonga_wal_status()`:

```sql
SELECT name, last_block FROM pgroonga_wal_status();
    name     | last_block 
-------------+------------
 notes_index |          2
(1 row)
```

### Check logs

#### WAL exceeds the threshold

Output the SQL to be run, the start time, and the end time.

```console
$ grep pgroonga-primary-maintainer.sh /var/log/messages
...
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84272]: Run 'REINDEX INDEX CONCURRENTLY notes_index'
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84289]: Thu Jul  4 00:39:26 UTC 2024
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84290]: REINDEX
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84343]: Thu Jul  4 00:39:26 UTC 2024
...
```

If multiple indexes are targeted, `REINDEX` is run in sequential order,
with similar output each time.

Check `pgroonga_wal_status()`:

```sql
SELECT name, last_block FROM pgroonga_wal_status();
    name     | last_block 
-------------+------------
 notes_index |          1
(1 row)
```

#### No WAL exceeds the threshold

No output.

## See also

  * [`pgroonga-generate-primary-maintainer-service.sh` command][generate-primary-maintainer-service]

  * [`pgroonga-generate-primary-maintainer-timer.sh` command][generate-primary-maintainer-timer]

  * [PostgreSQL Environment Variables][postgresql-environment-variables]

  * [`pgroonga_wal_status` function][wal-status]

  * [`pgroonga.enable_wal` parameter][enable-wal]

[enable-wal]:../parameters/enable-wal.html

[generate-primary-maintainer-service]:pgroonga-generate-primary-maintainer-service.html

[generate-primary-maintainer-timer]:pgroonga-generate-primary-maintainer-timer.html

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[postgresql-environment-variables]:{{ site.postgresql_doc_base_url.en }}/libpq-envars.html

[wal-status]:../functions/pgroonga-wal-status.html
