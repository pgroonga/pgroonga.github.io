---
title: "pgroonga_crash_safer.log_path parameter"
upper_level: ../
---

# `pgroonga_crash_safer.log_path` parameter

Since 2.3.3.

## Summary

`pgroonga_crash_safer.log_path` parameter controls log path. This is a [`pgroonga_crash_safer` module][pgroonga-crash-safer] version of [`pgroonga.log_path` parameter][log-path].

See [`pgroonga.log_path` parameter][log-path] for details.

## Syntax

In `postgresql.conf`:

```text
pgroonga_crash_safer.log_path = path
```

The default value is same as [`pgroonga.log_path` parameter][log-path]: `$PGDATA/pgroonga.log`

## Usage

Here is an example to output log to `/var/log/pgroonga.log`:

```text
pgroonga_crash_safer.log_path = '/var/log/pgroonga.log'
```

Here is an example to disable log:

```text
pgroonga_crash_safer.log_path = 'none'
```

## See also

  * [`pgroonga.log_path` parameter][log-path]

  * [`pgroonga_crash_safer.log_level` parameter][pgroonga-crash-safer-log-level]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[log-path]:log-path.html

[pgroonga-crash-safer-log-level]:pgroonga-crash-safer-log-level.html
