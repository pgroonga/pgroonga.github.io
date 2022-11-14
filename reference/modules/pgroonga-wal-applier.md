---
title: pgroonga_wal_applier module
upper_level: ../
---

# `pgroonga_wal_applier` module

Since 2.3.3.

The `pgroonga_wal_applier` module is deprecated since 2.4.2. Use [the `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer] instead.

## Summary

`pgroonga_wal_applier` module applies pending WAL periodically by [`pgroonga_wal_apply` function][pgroonga-wal-apply].

You must use `pgroonga_wal_applier` module when you want to limit the max WAL size by setting [`pgroonga.max_wal_size` parameter][max-wal-size].

You don't need to use `pgroonga_wal_applier` module on primary server because there is no pending WAL. You need to use `pgroonga_wal_applier` module only on standby servers.

## Usage

You can use `pgroonga_wal_applier` module by adding `pgroonga_wal_applier` to [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries].

For example:

```text
shared_preload_libraries = 'pgroonga_wal_applier'
```

## Parameters

  * [`pgroonga_wal_applier.naptime` parameter][pgroonga-wal-applier-naptime]

## See also

  * [Streaming replication][streaming-replication]
  * [The `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[max-wal-size]:../parameters/max-wal-size.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[pgroonga-wal-applier-naptime]:../parameters/pgroonga-wal-applier-naptime.html

[streaming-replication]:../streaming-replication.html
