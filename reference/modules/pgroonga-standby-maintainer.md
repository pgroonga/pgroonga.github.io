---
title: pgroonga_standby_maintainer module
upper_level: ../
---

# `pgroonga_standby_maintainer` module

Since 2.4.2.

## Notices

If PostgreSQL is 15 or higher, please use [the `pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager] instead of this module.

## Summary

The `pgroonga_standby_maintainer` module automatically executes [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] on a stadnby database.

Normally PGroonga's WAL doesn't t apply on a standby database.
If we use PGroonga with streaming replication.

Therefore, for example, a first \"SELECT\" on a primary database may become slower after we switch from a standby database. Because it takes time to apply PGroonga's WAL to the primary database.

In addition, we need to remove internal unused Groonga tables, columns and records periodically from the standby database with [the `pgroonga_vacuum()` function][pgroonga-vacuum]. Because `VACUUM` isn't run on the standby database.

In the former case, we can apply PGroonga's WAL into the standby database automatically with [the `pgroonga_wal_applier` module][pgroonga-wal-applier]. However, in the latter case, we can't execute automatically [the `pgroonga_vacuum()` funtion][pgroonga-vacuum] into the standby database.

We can execute automatically [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] into the standby database with the `pgroonga_standby_maintainer` module.

Therefore, if we use the `pgroonga_standby_maintainer` module, we don't need to use [the `pgroonga_wal_applier` module][pgroonga-wal-applier] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] on the standby database.

## Usage

We must configure the following parameters to use `pgroonga_standby_maintainer` module:

  * [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]

An example:

```text
shared_preload_libraries = 'pgroonga_standby_maintainer'
```

## Parameters

  * [`pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db` parameter][pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]

  * [`pgroonga_standby_maintainer.naptime` parameter][pgroonga-standby-maintainer-naptime]

## See also

  * [The `pgroonga_wal_applier` module][pgroonga-wal-applier]
  * [The `pgroonga_wal_apply()` function][pgroonga-wal-apply]
  * [The `pgroonga_vacuum()` function][pgroonga-vacuum]

  * [The `pgroonga_wal_resource_manager` module][pgroonga-wal-resource-manager]

[pgroonga-wal-applier]:./pgroonga-wal-applier.html
[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html
[pgroonga-vacuum]:../functions/pgroonga-vacuum.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.en }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]:../parameters/pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db.html
[pgroonga-standby-maintainer-naptime]:../parameters/pgroonga-standby-maintainer-naptime.html

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html
