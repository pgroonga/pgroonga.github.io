---
title: "pgroonga.max_bulk_insert_wal_record_size parameter"
upper_level: ../
---

# `pgroonga.max_bulk_insert_wal_record_size` parameter

Since 3.2.5.

## Summary

`pgroonga.max_bulk_insert_wal_record_size` parameter controls the max custom WAL record size for PGroonga's bulk insert.

This is used only when [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager] is used.

This is a soft limit. So some WAL records may use more size than this size.

## Syntax

In SQL:

```sql
SET pgroonga.max_bulk_insert_wal_record_size = size;
```

In `postgresql.conf`:

```text
pgroonga.max_bulk_insert_wal_record_size = size
```

`size` is a size value. The default unit is KiB. You can change unit by specify suffix such as `MB` for MiB.

The default is `16MiB`.

You can disable this soft limit by specifying `0`.

## Usage

Here is an example to specify 256 MiB:

```text
pgroonga.max_bulk_insert_wal_record_size = 256MB
```

## See also

  * [`pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager]

  * [Streaming replication][streaming-replication]

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[streaming-replication]:../streaming-replication.html
