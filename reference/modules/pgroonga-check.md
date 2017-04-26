---
title: pgroonga_check module
upper_level: ../
---

# `pgroonga_check` module

Since 1.2.0.

## Summary

`pgroonga_check` module checkes PGroonga database consistency on startup. If PGroonga database is broken, it tries to recover the database.

## Configuration

You need to add `pgroonga_check` to [`shared_preload_libraries`]({{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES) in `postgresql.conf`:

```text
shared_preload_libraries = 'pgroonga_check'
```

You need to restart your PostgreSQL to apply the change.

## Usage

You don't do anything. `pgroonga_check` module checks all PGroonga databases on PostgreSQL startup. If `pgroonga_check` module finds any broken PGroonga databases, it tries to recover them automatically.

If it can't recover, it removes all unrecoverable PGroonga databases automatically. There are no unrecoverable data in PGroonga databases. You can recover PGroonga databases by running [`REINDEX`]({{ site.postgresql_doc_base_url.en }}/sql-reindex.html) manually.
