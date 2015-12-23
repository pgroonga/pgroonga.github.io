---
title: "pgroonga.log_path"
layout: en
---

# `pgroonga.log_path` parameter

## Summary

`pgroonga.log_path` parameter controls log path.

This parameter is only effective when [`pgroonga.log_type`](log_type.html) is `file`.

The default value is `$PGDATA/pgroonga.log`.

You can disable log output by specifying `none` as path.

## Syntax

In SQL:

```sql
SET pgroonga.log_path = path;
```

In `postgresql.conf`:

```text
pgroonga.log_path = path
```

`path` is a string value. It means that you need to quote `path` value such as `'/var/log/pgroonga.log'`.

PGroonga outputs log to `path`.

## Usage

Here is an example to output log to `/var/log/pgroonga.log`:

```sql
SET pgroonga.log_path = '/var/log/pgroonga.log';
```

Here is an example to disable log:

```sql
SET pgroonga.log_path = 'none';
```

## See also

  * [`pgroonga.log_type`](log_type.html)
