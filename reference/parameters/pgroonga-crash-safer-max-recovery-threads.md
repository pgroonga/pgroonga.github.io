---
title: "pgroonga_crash_safer.max_recovery_threads parameter"
upper_level: ../
---

# `pgroonga_crash_safer.max_recovery_threads` parameter

Since 3.1.9.

## Summary

`pgroonga_crash_safer.max_recovery_threads` parameter specifies the number of threads for recovery of broken Groonga indexes.

* The default is `0`, which means disabled
* Use all CPUs in the environment at `-1`
* Use CPU for that number if `1` or later is set

## Syntax

In `postgresql.conf`:

```text
pgroonga_crash_safer.max_recovery_threads = number_of_threads
```

## Usage

Here is an example to specify `-1`:

```text
pgroonga_crash_safer.max_recovery_threads = -1
```

## See also

  * [`pgroonga_crash_safer` module][pgroonga-crash-safer]

  * [Crash safe][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
