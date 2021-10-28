---
title: "pgroonga_crash_safer.log_level parameter"
upper_level: ../
---

# `pgroonga_crash_safer.log_level` parameter

Since 2.3.3.

## Summary

`pgroonga_crash_safer.log_level` parameter controls which logs are recorded. This is a [`pgroonga_crash_safer` module][pgroonga-crash-safer] version of [`pgroonga.log_level` parameter][log-level].

See [`pgroonga.log_level` parameter][log-level] for details.

## Syntax

In `postgresql.conf`:

```text
pgroonga_crash_safer.log_level = level
```

See [`pgroonga.log_level` parameter][log-level] for available levels.

## Usage

Here is an example to disable log:

```text
pgroonga_crash_safer.log_level = none
```

Here is an example to enable almost log messages:

```sql
pgroonga_crash_safer.log_level = debug
```

## See also

  * [`pgroonga.log_level` parameter][log-level]

  * [`pgroonga_crash_safer.log_path` parameter][pgroonga-crash-safer-log-path]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[log-level]:log-level.html

[pgroonga-crash-safer-log-path]:pgroonga-crash-safer-log-path.html
