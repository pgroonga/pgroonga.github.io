---
title: pgroonga_database_remove function
upper_level: ../
---

# `pgroonga_database_remove` function

Since 2.1.8.

## Summary

`pgroonga_database_remove` function removes all PGroonga related files (`pgrn*` files) from PostgreSQL database directories.

You need to install [`pgroonga_database` module][pgroonga-database] to use this function.

Note that this is a dangerous function. You should not enable this function until you need this function.

Normally, you don't need to remove PGroonga related files. If your PGroonga indexes are broken, you can recover these indexes by [`REINDEX`][postgresql-reindex]. But you can't recover by `REINDEX` when internal PGroonga database is broken.

If your internal PGroonga database is broken, you need to follow the following steps to recover your internal PGroonga database:

  1. Disconnect all PostgreSQL connections

  2. Remove all `pgrn*` files in PostgreSQL data directories

     If you use tablespace, you need to remove `pgrn*` files in tablespace directories.

     You need to log in to the host that runs PostgreSQL.

  3. Connect PostgreSQL

  4. Run `REINDEX` against all PGroonga indexes

     This creates internal PGroonga database and rebuilds all PGroonga indexes from data in PostgreSQL.

`pgroonga_database_remove` function removes all `pgrn*` files. It also supports tablespace.

If you use `pgroonga_database_remove` function, you don't need to log in to the host that runs PostgreSQL. Here are steps to recover with `pgroonga_database_remove` function:

  1. Disconnect all PostgreSQL connections

  2. Connect PostgreSQL

  3. Run `SELECT pgroonga_database_remove()`

  4. Run `REINDEX` against all PGroonga indexes

     This creates internal PGroonga database and rebuilds all PGroonga indexes from data in PostgreSQL.

## Syntax

Here is the syntax of this function:

```text
bool pgroonga_database_remove()
```

It always returns `true` because if there is an error, it raises an error instead of returning `false`.

## Usage

Here are steps how to recover from broken internal PGroonga database.

First, disconnect all connections. If there are any connections that still use internal PGroonga database, these connections will be crashed.

Then, connect to PostgreSQL again and run `pgroonga_database_remove()` function:

```sql
SELECT pgroonga_database_remove();
```

Then, disconnect the connection.

Note that you can't use any PGroonga features except features provided `pgroonga_database` module in the connection. If you use one of them, the connection tries to open internal PGroonga database. It may cause a crash.

Then, connect to PostgreSQL again and recreate all PGroonga indexes:

```sql
REINDEX INDEX pgroonga_index1;
REINDEX INDEX pgroonga_index2;
-- ...
```

Now, your system is recovered. You don't need to log in the host that runs PostgreSQL.

## See also

 * [`pgroonga_database` module][pgroonga-database]

[pgroonga-database]:../modules/pgroonga-database.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.en }}/sql-reindex.html
