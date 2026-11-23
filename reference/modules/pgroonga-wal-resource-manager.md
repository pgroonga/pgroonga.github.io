---
title: pgroonga_wal_resource_manager module
upper_level: ../
---

# `pgroonga_wal_resource_manager` module

Since 3.2.1.

Available in PostgreSQL 15 or higher.

## Summary

The `pgroonga_wal_resource_manager` module automatically applies PGroonga's WAL using the PostgreSQL [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers].

If you enable WAL Resource Manager support, use PostgreSQL's [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers] feature. See [Streaming replication by WAL resource manager][streaming-replication-wal-resource-manager] for details.

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

* If you used this module without [crash-safer][pgroonga-crash-safer] in primary with PGroonga 4.1.0 or earlier, Groonga's WAL files remain in primary

  * See [Groonga's WAL files in primary without crash-safer](#groonga-wal-files-in-primary-without-crash-safer) for details

## Groonga's WAL files in primary without crash-safer {#groonga-wal-files-in-primary-without-crash-safer}

This section is only for primary that uses this module without [`pgroonga_crash_safer` module][pgroonga-crash-safer].

PGroonga 3.2.1 to 4.1.0 write Groonga's WAL (not PostgreSQL's WAL) in this configuration. Groonga's WAL is written to `pgrn*.wal` files in the database directory. Nobody uses or removes them without [`pgroonga_crash_safer` module][pgroonga-crash-safer]. So `pgrn*.wal` files keep growing. They aren't removed even when you restart PostgreSQL.

PGroonga 4.1.1 or later doesn't write Groonga's WAL in this configuration. But PGroonga 4.1.1 or later doesn't remove the `pgrn*.wal` files that were written by PGroonga 4.1.0 or earlier. You need to remove them manually after you upgrade PGroonga to 4.1.1 or later. If you remove them before you upgrade, PGroonga 4.1.0 or earlier writes them again. Here are the steps to remove them:

  1. Stop PostgreSQL normally

  2. Remove all `pgrn*.wal` files in all database directories that use PGroonga

  3. Start PostgreSQL

For example:

```bash
sudo -H systemctl stop postgresql
sudo -u postgres -H find /var/lib/postgresql/18/main/base -name 'pgrn*.wal' -delete
sudo -H systemctl start postgresql
```

This example assumes the default data directory of PostgreSQL 18 on Debian and Ubuntu. If you use tablespaces, you also need to remove `pgrn*.wal` files in the tablespace directories. They aren't in `base/`.

You must not remove `pgrn*.wal` files while PostgreSQL is running.

You must remove them before you enable [`pgroonga_crash_safer` module][pgroonga-crash-safer] in the primary. If they remain, [`pgroonga_crash_safer` module][pgroonga-crash-safer] tries recovering PGroonga indexes from them. They are old. So PGroonga indexes may lose data that were added after you upgraded PGroonga. If you have already enabled [`pgroonga_crash_safer` module][pgroonga-crash-safer] with them, you need to run [`REINDEX`][postgresql-reindex] for all PGroonga indexes.

## Parameters

  * [`pgroonga.enable_wal_resource_manager` parameter][enable-wal-resource-manager]

  * [`pgroonga_wal_resource_manager.log_level` parameter][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path` parameter][pgroonga-wal-resource-manager-log-path]

## See also

  * [`pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

  * [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers]

[enable-wal-resource-manager]:../parameters/enable-wal-resource-manager.html

[enable-wal]:../parameters/enable-wal.html

[pgroonga-crash-safer]:pgroonga-crash-safer.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.en }}/custom-rmgr.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.en }}/sql-reindex.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[streaming-replication-wal-resource-manager]:../streaming-replication-wal-resource-manager.html
