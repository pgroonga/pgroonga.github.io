---
title: pgroonga_wal_resource_manager module
upper_level: ../
---

# `pgroonga_wal_resource_manager` module

Since 3.2.1.

Available in PostgreSQL 15 or higher.

## Summary

The `pgroonga_wal_resource_manager` module automatically applies PGroonga's WAL
using the PostgreSQL [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers].

## Usage

You must configure the following parameters to use `pgroonga_wal_resource_manager` module:

  * [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]

For example:

```text
shared_preload_libraries = 'pgroonga_wal_resource_manager'
```

## Parameters

  * [`pgroonga_wal_resource_manager.log_level` parameter][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path` parameter][pgroonga-wal-resource-manager-log-path]

## See also

  * [`pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

  * [`pgroonga_wal_apply()` function][pgroonga-wal-apply]

  * [`pgroonga_vacuum()` function][pgroonga-vacuum]

  * [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers]

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.en }}/custom-rmgr.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[pgroonga-vacuum]:../functions/pgroonga-vacuum.html
