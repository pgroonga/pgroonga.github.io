---
title: "pgroonga.enable_wal parameter"
upper_level: ../
---

# `pgroonga.enable_wal` parameter

Since 1.1.6.

## Summary

`pgroonga.enable_wal` parameter controls whether [WAL]({{ site.postgresql_doc_base_url.en }}/runtime-config-wal.html) is enabled or not.

If you enable WAL support, you can use PostgreSQL's streaming replication feature. See [Replication](../replication.html) for details.

If you enable WAL support, update performance will be decreased because some extra disk writes are needed.

The default value is `off`. It means that PGroonga doesn't generate WAL.

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

Here is an example SQL to enable WAL support:

```sql
SET pgroonga.enable_wal = on;
```

Here is an example configration to enable WAL support:

```sql
pgroonga.enable_wal = on
```

## See also

  * [Replication](../replication.html)
