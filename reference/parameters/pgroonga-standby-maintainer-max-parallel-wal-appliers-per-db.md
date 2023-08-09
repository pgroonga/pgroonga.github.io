---
title: "pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db parameter"
upper_level: ../
---

# `pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db` parameter

Since 3.1.2.

## Summary

The `pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db` parameter controls parallel level of [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] execution by [the `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer].

If this value is 1 or larger, `pgroonga_wal_apply()` for each PGroonga index is executed in a new background worker process. If you have enough resource to run `pgroonga_wal_apply()` in parallel, you can reduce total WAL application time by specifying a large value such as 6.

Note that you may need to increase [`max_worker_processes`](postgresql-max-worker-processes) when you specify a large value to this parameter. If you specify a large value, you may need to use many worker processes at the same time.

Note that this parameter controls parallel level per database. If you have 2 databases that use PGroonga and specify 6 to this parameter, 12 background worker processes may be used for `pgroonga_wal_apply()` at the same time.

The default value is 0. It means that `pgroonga_wal_apply()` is executed sequentially. No new background worker processes aren't used.

## Syntax

In `postgresql.conf`:

```text
pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db = max
```

`max` is 0 or positive integer that controls parallel level.

The default is 0.

## Usage

Here is an example to use at most 6 background worker processes for parallel `pgroonga_wal_apply()` per database:

```text
pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db = 6
```

## See also

  * [The `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

  * [The `pgroonga_wal_apply()` function][pgroonga-wal-apply]

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.en }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html
