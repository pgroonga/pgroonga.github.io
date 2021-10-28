---
title: "pgroonga.max_wal_size parameter"
upper_level: ../
---

# `pgroonga.max_wal_size` parameter

Since 2.3.3.

## Summary

`pgroonga.max_wal_size` parameter controls the max PGroonga's WAL size.

You must use `pgroonga.max_wal_size` parameter with [`pgroonga_wal_applier` module][pgroonga-wal-applier]. You set `pgroonga_max_wal_size` parameter in primary server and enable [`pgroonga_wal_applier` module][pgroonga-wal-applier] in standby servers.

`pgroonga.max_wal_size` parameter value must be enough large for ensuring applying WAL on standby servers. If `pgroonga.max_wal_size` parameter value is small, data on standby servers are broken.

## Syntax

In SQL:

```sql
SET pgroonga.max_wal_size = size;
```

In `postgresql.conf`:

```text
pgroonga.max_wal_size = size
```

`size` is a size value. The default unit is KiB. You can change unit by specify suffix such as `MB` for MiB.

The default is `0`. It means that no size limit.

## Usage

Here is an example to specify 10 MiB:

```text
pgroonga.max_wal_size = 10MB
```

## See also

  * [`pgroonga_wal_applier` module][pgroonga-wal-applier]

  * [Streaming replication][streaming-replication]

[pgroonga-wal-applier]:../modules/pgroonga-wal-applier.html

[streaming-replication]:../streaming-replication.html
