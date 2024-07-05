---
title: "pgroonga_wal_resource_manager.log_path parameter"
upper_level: ../
---

# `pgroonga_wal_resource_manager.log_path` parameter

Since 3.2.1.

## Summary

`pgroonga_wal_resource_manager.log_path` parameter controls log path. This is a [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager] version of [`pgroonga.log_path` parameter][log-path].

See [`pgroonga.log_path` parameter][log-path] for details.

## Syntax

In `postgresql.conf`:

```text
pgroonga_wal_resource_manager.log_path = path
```

The default value is same as [`pgroonga.log_path` parameter][log-path]: `$PGDATA/pgroonga.log`

## Usage

Here is an example to output log to `/var/log/pgroonga.log`:

```text
pgroonga_wal_resource_manager.log_path = '/var/log/pgroonga.log'
```

Here is an example to disable log:

```text
pgroonga_wal_resource_manager.log_path = 'none'
```

## See also

  * [`pgroonga.log_path` parameter][log-path]

  * [`pgroonga_wal_resource_manager.log_level` parameter][pgroonga-wal-resource-manager-log-level]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[log-path]:log-path.html

[pgroonga-wal-resource-manager-log-level]:pgroonga-wal-resource-manager-log-level.html
