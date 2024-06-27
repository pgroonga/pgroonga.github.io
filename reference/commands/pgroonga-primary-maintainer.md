---
title: pgroonga-primary-maintainer.sh command
upper_level: ../
---

# `pgroonga-primary-maintainer.sh` command

Since 3.2.1.

## Summary

`pgroonga-primary-maintainer.sh` command runs `REINDEX INDEX CONCURRENTLY` on indexes
for which PGroonga's WAL size exceeds the threshold.

The purpose is to suppress the size of the WAL on primary servers that have WAL enabled.

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

  * [PostgreSQL Environment Variables][environment-variables]

## Example

Here is an example of running it in Bash.

* Specify DB name in environment variable

  * `PGDATABASE=test_database`

* Specify a threshold of 10GB

  * `--threshold 10G`

### No WAL exceeds the threshold

No output.

```console
$ PGDATABASE=test_database \
  pgroonga-primary-maintainer.sh \
  --threshold 10G
```

### WAL exceeds the threshold

Output the SQL to be run, the start time, and the end time.

```console
$ PGDATABASE=test_database \
  pgroonga-primary-maintainer.sh \
  --threshold 10G
Run 'REINDEX INDEX CONCURRENTLY test_index'
Thu Jun 27 07:24:34 UTC 2024
REINDEX
Thu Jun 27 07:24:34 UTC 2024
```

If multiple indexes are targeted, `REINDEX` is run in sequential order,
with similar output each time.

## See also

  * [PostgreSQL Environment Variables][environment-variables]

  * [`pgroonga_wal_status` function][wal-status]

  * [`pgroonga.enable_wal` parameter][enable-wal]

[environment-variables]:{{ site.postgresql_doc_base_url.en }}/libpq-envars.html

[enable-wal]:../parameters/enable-wal.html

[wal-status]:pgroonga-wal-status.html
