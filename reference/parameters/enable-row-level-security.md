---
title: "pgroonga.enable_row_level_security parameter"
upper_level: ../
---

# `pgroonga.enable_row_level_security` parameter

Since 3.1.6.

## Summary

`pgroonga.enable_row_level_security` parameter controls whether logs are output according to [`pgroonga.log_level` parameter][log-level] or only `critical` logs.

The default is `on`, so for tables with [Row Security Policies][postgresql-row-security-policies] set, PGroonga will only log `critical`.

**Note:**

If this parameter is set to `off`, information related to the target row may be included in logs and error messages when some conditions overlap.
In that case, there are security risks.

PostgreSQL [Row Security Policies][postgresql-row-security-policies] settings and the setting of this parameter are independent of each other.
Setting this parameter to `off` does not disable the PostgreSQL [Row Security Policies][postgresql-row-security-policies] setting.

## Syntax

In SQL:

```sql
SET pgroonga.enable_row_level_security = boolean;
```

In `postgresql.conf`:

```text
pgroonga.log_level = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example SQL of outputting PGroonga logs according to [`pgroonga.log_level` parameter][log-level], even for a table with [Row Security Policies][postgresql-row-security-policies] set:

```sql
SET pgroonga.enable_row_level_security = off;
```

Here is an example configuration of outputting PGroonga logs according to [`pgroonga.log_level` parameter][log-level], even for a table with [Row Security Policies][postgresql-row-security-policies] set:

```text
pgroonga.enable_row_level_security = off;
```

## See also

  * [Row Security Policies][postgresql-row-security-policies]

  * [`pgroonga.log_level` parameter][log-level]

[postgresql-row-security-policies]:{{ site.postgresql_doc_base_url.en }}/ddl-rowsecurity.html

[log-level]:log-level.html
