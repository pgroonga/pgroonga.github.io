---
title: "pgroonga.enable_wal parameter"
upper_level: ../
---

# `pgroonga.enable_wal` parameter

Since 1.1.6.

## Notices

If PostgreSQL is 15 or higher, please use [the `pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager] instead of this module.

It has the following advantages.

* Apply WAL in real time on standby

* On standby, it prevents unstable during recovery

  * Connection will not be available during recovery

  * When using [crash-safer][pgroonga-crash-safer], there was a status where we connected but could not execute a query

* When used with [Replication Slots][postgresql-replication-slots], it prevents the WAL size from continuing to increase

## Summary

`pgroonga.enable_wal` parameter controls whether [WAL]({{ site.postgresql_doc_base_url.en }}/runtime-config-wal.html) is enabled or not.

If you enable WAL support, you can use PostgreSQL's streaming replication feature. See [Replication](../replication.html) for details.

If you enable WAL support, update performance will be decreased because some extra disk writes are needed.

The default value is `off`. It means that PGroonga doesn't generate WAL.

## Syntax

In SQL:

```sql
SET pgroonga.enable_wal = boolean;
```

In `postgresql.conf`:

```text
pgroonga.enable_wal = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example SQL to enable WAL support:

```sql
SET pgroonga.enable_wal = on;
```

Here is an example configration to enable WAL support:

```sql
pgroonga.enable_wal = on
```

## See also

  * [Replication](../replication.html)

[postgresql-replication-slots]:{{ site.postgresql_doc_base_url.en }}/warm-standby.html#STREAMING-REPLICATION-SLOTS

[pgroonga-crash-safer]:../reference/modules/pgroonga-crash-safer.html

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html
