---
title: "pgroonga.enable_crash_safe parameter"
upper_level: ../
---

# `pgroonga.enable_crash_safe` parameter

Since 2.3.3.

## Summary

`pgroonga.enable_crash_safe` parameter controls whether crash safe feature is enabled or not.

Note that you must add [`pgroonga_crash_safer` module][pgroonga-crash-safer] to [`shared_preload_libraries` parameter][postgresql-shared-preload-libraries] value when you set `on` to `pgroonga.enable_crash_safe` parameter.

See also: [Crash safe][crash-safe]

## Syntax

You must set `pgroonga.enable_crash_safe` in `postgresql.conf`:

```text
pgroonga.enable_crash_safe = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example configration to enable crash safe feature:

```sql
shared_preload_libraries = 'pgroonga_crash_safer'
pgroonga.enable_crash_safe = on
```

## See also

  * [Crash safe][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.en }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES
