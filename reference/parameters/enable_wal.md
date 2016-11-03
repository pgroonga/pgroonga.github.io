---
title: "pgroonga.enable_wal parameter"
---

# `pgroonga.enable_wal` parameter

Since 1.1.6.

It's still an experimental feature. If you find a problem, please [report it](https://github.com/pgroonga/pgroonga/issues/new).

## Summary

`pgroonga.enable_wal` parameter controls whether [WAL](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/runtime-config-wal.html) is enabled or not.

PGroonga supports WAL with PostgreSQL 9.6 or later. `pgroonga.enable_wal` parameter is meaningless with PostgreSQL 9.5 or earlier.

If you enable WAL support, you can use PostgreSQL's streaming replication feature. See [Replication](../replication.html) for details.

If you enable WAL support, update performance will be decreased because some extra disk writes are needed.

The default value is `off`. It means that PGroonga doesn't generate WAL even when you're using PostgreSQL 9.6 or later. It'll be `on` by default when this feature is marked as stable.

## Syntax

In SQL:

```sql
SET pgroonga.enable_wal = boolean;
```

In `postgresql.conf`:

```text
pgroonga.enable_wal = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example to enable WAL support:

```sql
SET pgroonga.enable_wal = on;
```

## See also

  * [Replication](../replication.html)
