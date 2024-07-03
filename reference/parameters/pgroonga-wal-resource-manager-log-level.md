---
title: "pgroonga_wal_resource_manager.log_level parameter"
upper_level: ../
---

# `pgroonga_wal_resource_manager.log_level` parameter

Since 3.2.1.

## Summary

`pgroonga_wal_resource_manager.log_level` parameter controls which logs are recorded.
This is a [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager]
version of [`pgroonga.log_level` parameter][log-level].

See [`pgroonga.log_level` parameter][log-level] for details.

## Syntax

In `postgresql.conf`:

```text
pgroonga_wal_resource_manager.log_level = level
```

See [`pgroonga.log_level` parameter][log-level] for available levels.

## Usage

Here is an example to disable log:

```text
pgroonga_wal_resource_manager.log_level = none
```

Here is an example to enable almost log messages:

```text
pgroonga_wal_resource_manager.log_level = debug
```

## See also

  * [`pgroonga.log_level` parameter][log-level]

  * [`pgroonga_wal_resource_manager.log_path` parameter][pgroonga-wal-resource-manager-log-path]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[log-level]:log-level.html

[pgroonga-wal-resource-manager-log-path]:pgroonga-wal-resource-manager-log-path.html
