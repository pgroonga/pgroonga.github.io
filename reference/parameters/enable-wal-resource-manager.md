---
title: "pgroonga.enable_wal_resource_manager parameter"
upper_level: ../
---

# `pgroonga.enable_wal_resource_manager` parameter

Since 3.2.1.

Available in PostgreSQL 15 or higher.

## Summary

`pgroonga.enable_wal_resource_manager` parameter controls whether WAL Resource Manager is enabled or not.

If you enable WAL Resource Manager support, WAL for PGroonga WAL Resource Manager is generated when updating PGroonga index. See [Streaming replication by WAL resource manager][streaming-replication-wal-resource-manager] for details.

If you enable WAL Resource Manager support, update performance will be decreased because some extra disk writes are needed.

The default value is `off`. It means that PGroonga doesn't generate WAL.

It is used with [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager].

## Syntax

In SQL:

```sql
SET pgroonga.enable_wal_resource_manager = boolean;
```

In `postgresql.conf`:

```text
pgroonga.enable_wal_resource_manager = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example SQL to enable WAL Resource Manager support:

```sql
SET pgroonga.enable_wal_resource_manager = on;
```

Here is an example configration to enable WAL Resource Manager support:

```text
pgroonga.enable_wal_resource_manager = on
```

## See also

  * [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager]

  * [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.en }}/custom-rmgr.html

[streaming-replication-wal-resource-manager]:../streaming-replication-wal-resource-manager.html
