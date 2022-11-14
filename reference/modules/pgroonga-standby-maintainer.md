---
title: pgroonga_standby_maintainer module
upper_level: ../
---

# `pgroonga_standby_maintainer` module

Since 2.4.2.

This is still an experimental feature.

## Summary

The `pgroonga_standby_maintainer` module provides executing [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] automatically on stadnby database.

Normally, if we use PGroonga with streaming replication, PGroonga's WAL doesn't apply on a standby database.
Therefore, for example, a first "SELECT" after we switch standby database to primary database may become slow.
Because a time for applying not applicable PGroonga's WAL exist.

In addition, we need to remove internal unused Groonga tables, columns and records with [the `pgroonga_vacuum()` function][pgroonga-vacuum] periodically on a standby database. Because `VACUUM` isn't run in a standby database.

In the formaer case, we can apply PGroonga's WAL into a standby database automatically with [the `pgroonga_wal_applier` module][pgroonga-wal-applier]. However, in the latter case, we can't execute [the `pgroonga_vacuum()` funtion][pgroonga-vacuum] automatically into a standby database.

We can execute [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] automatically into a standby database with the `pgroonga_standby_maintainer` module.

Therefore, if we use the `pgroonga_standby_maintainer` module, we don't need to use [the `pgroonga_wal_applier` module][pgroonga-wal-applier] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] on a standby database.

## Usage

We must configure the following parameters to use `pgroonga_standby_maintainer` module:

  * [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]

For example:

```text
shared_preload_libraries = 'pgroonga_standby_maintainer'
```

We may need to increase [`max_worker_processes` parameter][postgresql-max-worker-processes] value. `pgroonga_standby_maintainer` module always runs 1 worker process. And `pgroonga_standby_maintainer` module runs 1 worker processes per database that uses PGroonga. For example, if we have 3 databases that use PGroonga, `pgroonga_standby_maintainer` module runs up to 3 worker processes:

```text
max_worker_processes = 11 # 8 (the default) + 3 (for pgroonga_standby_maintainer)
```

## Parameters

  * [`pgroonga_standby_maintainer.naptime` parameter][pgroonga-standby-maintainer-naptime]

## See also

  * [The `pgroonga_wal_applier` module][pgroonga-wal-applier]
  * [The `pgroonga-wal-apply()` function][pgroonga-wal-apply]
  * [The `pgroonga-vacuum()` function][pgroonga-vacuum]


[pgroonga-wal-applier]:./pgroonga-wal-applier.html
[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html
[pgroonga-vacuum]:../functions/pgroonga-vacuum.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.en }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-standby-maintainer-naptime]:../parameters/pgroonga-standby-maintainer-naptime.html
