---
title: pgroonga_wal_resource_manager module
upper_level: ../
---

# `pgroonga_wal_resource_manager` module

Since 3.2.1.

Available in PostgreSQL 15 or higher.

## Summary

The `pgroonga_wal_resource_manager` module automatically applies PGroonga's WAL using the PostgreSQL [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers].

## Usage

You must configure on the primary and standby the following parameters to use `pgroonga_wal_resource_manager` module:

  * [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries]

For example:

```text
shared_preload_libraries = 'pgroonga_wal_resource_manager'
```

In primary, the [`pgroonga.enable_wal_resource_manager` parameter][enable-wal-resource-manager] must also be set.

For example:

```text
pgroonga.enable_wal_resource_manager = yes
```

## Notes

* Do not set [`pgroonga.enable_wal = yes`][enable-wal] together

  * The WAL size suppression effect, which is one of the advantages of this module, will no longer be available

* If you enable this module, do not enable [crash-safer][pgroonga-crash-safer] in standby

  * In standby, this module recovers

  * Primary does not recover, so if you want to make it crash-safe, you must enable [crash-safer][pgroonga-crash-safer]

## Parameters

  * [`pgroonga.enable_wal_resource_manager` parameter][enable-wal-resource-manager]

  * [`pgroonga_wal_resource_manager.log_level` parameter][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path` parameter][pgroonga-wal-resource-manager-log-path]

## See also

  * [`pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

  * [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers]

[enable-wal-resource-manager]:../parameters/enable-wal-resource-manager.html

[enable-wal]:../parameters/enable-wal.html

[pgroonga-crash-safer]:../reference/modules/pgroonga-crash-safer.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.en }}/custom-rmgr.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES
