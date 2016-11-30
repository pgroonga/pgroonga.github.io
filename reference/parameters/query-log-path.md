---
title: "pgroonga.query_log_path parameter"
---

# `pgroonga.query_log_path` parameter

## Summary

`pgroonga.query_log_path` parameter controls the path of query log.

This parameter is meaningless when you don't use [`pgroonga.command` function](../functions/pgroonga-command.html). Because query can be executed only via `pgroonga.command` function.

If you specify relative path, the path is resolved from `$PGDATA`.

You can disable query log output by specifying `none` as path.

The default value is `none`. It means that query log is disabled by default.

## Syntax

In SQL:

```sql
SET pgroonga.query_log_path = path;
```

In `postgresql.conf`:

```text
pgroonga.query_log_path = path
```

`path` is a string value. It means that you need to quote `path` value such as `'pgroonga.query.log'`.

PGroonga outputs query log to `path`.

## Usage

Here is an example to output query log to `$PGDATA/pgroonga.query.log`:

```sql
SET pgroonga.query_log_path = 'pgroonga.query.log';
```

Here is an example to output query log to `/var/log/pgroonga.query.log`:

```sql
SET pgroonga.query_log_path = '/var/log/pgroonga.query.log';
```

Here is an example to disable query log:

```sql
SET pgroonga.query_log_path = 'none';
```

## See also

  * [Query log format](http://groonga.org/docs/reference/log.html#query-log)
