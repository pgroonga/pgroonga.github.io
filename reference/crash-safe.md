---
title: Crash safe
---

# Crash safe

PGroonga supports crash safe feature since 2.3.3.

This is still an experimental feature. If you find a problem, please report it to https://github.com/pgroonga/pgrgoonga/issues .

This document describes the followings:

  * How to configure crash safe feature for PGroonga

  * How crash safe feature for PGroonga works

## Summary

Crash safe feature for PGroonga is based on Groonga's crash safe feature. It doesn't use PostgreSQL's crash safe feature based on PostgreSQL's WAL.

Pros:

  * PGroonga's indexes are recovered automatically when a PostgreSQL process is crashed

    * You don't need to execute [`REINDEX`][postgresql-reindex] manually

Cons:

  * Write performance penalty

## How to configure crash safe feature

This section describes how to configure crash safe feature.

You must specify the following parameters in `postgresql.conf`:

```text
shared_preload_libraries = 'pgroonga_crash_safer'
pgroonga.enable_crash_safe = on
```

[`pgroonga_crash_safer` module][pgroonga-crash-safer] uses worker processes. You may need to increase [`max_worker_processes` parameter][postgresql-max-worker-processes] value. See [`pgroonga_crash_safer` module][pgroonga-crash-safer] for details.

## How crash safe feature works

This section describes how crash safe feature works.

PGroonga's crash safe feature is based on Groonga's crash safe feature.

Groonga's crash safe feature requires one process that opens Groonga's database before other processes and closes Groonga' database after other processes. The process is called as "primary process". Primary process must flush changes in memory to storage periodically.

[`pgroonga_crash_safer` module][pgroonga-crash-safer] runs one primary process per PostgreSQL's database. If an connection uses any PGroonga's feature, the process for the connection asks [`pgroonga_crash_safer` module][pgroonga-crash-safer] to run a primary process for the PostgreSQL's database and waits for opening Groonga's database by the primary process.

A process for an connection uses any PGroonga's feature is called as "secondary process". The number of primary processes must be one but the number of secondary processes can be zero or more.

A secondary process writes Groonga's WAL (not PostgreSQL's WAL) when PGroonga's indexes are updated. It ensure flushing WAL to storage. This causes write performance penalty.

A primary process flushes all changes in memory to storage and remove all Groonga's WAL files on shutdown. It means that no WAL file is expected state for normal shutdown. If there are any WAL files on startup, a primary process recovers the database automatically. A primary process tries recovering from Groonga's WAL. If it's failed, a primary process removes all existing Groonga's database, creates a new Groonga's database and executes [`REINDEX`][postgresql-reindex]. It rebuild all PGroonga's indexes from data in PostgreSQL.

Groonga's WAL files are moved when periodical flush by primary process. So Groonga's WAL size isn't increased forever. You can configure flush interval by [`pgroonga_crash_safer.flush_naptime` parameter][pgroonga-crash-safer-flush-naptime].


[postgresql-reindex]:{{ site.postgresql_doc_base_url.en }}/sql-reindex.html

[pgroonga-crash-safer]:modules/pgroonga-crash-safer.html

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.en }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-crash-safer-flush-naptime]:parameters/pgroonga-crash-safer-flush-naptime.html
