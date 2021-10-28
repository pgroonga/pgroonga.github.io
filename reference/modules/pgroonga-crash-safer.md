---
title: pgroonga_crash_safer module
upper_level: ../
---

# `pgroonga_crash_safer` module

Since 2.3.3.

This is still an experimental feature.

## Summary

`pgroonga_crash_safer` module provides crash safe features:

  * It recovers internal broken Groonga database by Groonga's WAL automatically.

  * It recovers internal broken Groonga database by `REINDEX` automatically.

`pgroonga_crash_safer` module starts the auto recovery process when any PGroonga feature is used for the first time after PostgreSQL's crash. Note that it's not started on PostgreSQL startup. If you want to run the auto recovery process on PostgreSQL startup, you can execute simple SQL that uses PGroonga feature such as `SELECT pgroonga_command('status')` immediately after PostgreSQL started.

Note that you need to set [`pgroonga.enable_crash_safe` parameter][enable-crash-safe] to `on` to use `pgroonga_crash_safer` module.

## Usage

You must configure the following parameters to use `pgroonga_crash_safer` module:

  * [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]

  * [`pgroonga.enable_crash_safe` parameter][enable-crash-safe]

For example:

```text
shared_preload_libraries = 'pgroonga_crash_safer'
pgroonga.enable_crash_safer = on
```

You may need to increase [`max_worker_processes` parameter][postgresql-max-worker-processes] value. `pgroonga_crash_safer` module always runs 1 worker process. And `pgroonga_crash_safer` module runs 1 or 2 worker processes per database that uses PGroonga. For example, if you have 3 databases that use PGroonga, `pgroonga_crash_safer` module runs up to 7 worker processes:

```text
max_worker_processes = 15 # 8 (the default) + 7 (for pgroonga_crash_safer)
```

## Parameters

  * [`pgroonga_crash_safer.flush_naptime` parameter][pgroonga-crash-safer-flush-naptime]

  * [`pgroonga_crash_safer.log_level` parameter][pgroonga-crash-safer-log-level]

  * [`pgroonga_crash_safer.log_path` parameter][pgroonga-crash-safer-log-path]

## See also

  * [Crash safe][crash-safe]

[enable-crash-safe]:../parameters/enable-crash-safe.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.en }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-crash-safer-flush-naptime]:../parameters/pgroonga-crash-safer-flush-naptime.html
[pgroonga-crash-safer-log-level]:../parameters/pgroonga-crash-safer-log-level.html
[pgroonga-crash-safer-log-path]:../parameters/pgroonga-crash-safer-log-path.html

[crash-safe]:../crash-safe.html
