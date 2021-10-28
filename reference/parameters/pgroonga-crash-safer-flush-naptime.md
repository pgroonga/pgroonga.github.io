---
title: "pgroonga_crash_safer.flush_naptime parameter"
upper_level: ../
---

# `pgroonga_crash_safer.flush_naptime` parameter

Since 2.3.3.

## Summary

`pgroonga_crash_safer.flush_naptime` parameter controls flush interval by [`pgroonga_crash_safer` module][pgroonga-crash-safer].

The larger value, the larger Groonga's WAL size.

The smaller value, the heavier IO load.

## Syntax

In `postgresql.conf`:

```text
pgroonga_crash_safer.flush_naptime = internval
```

`interval`'s default unit is second. You can change unit by specify suffix such as `min` for minutes.

The default is 60 seconds.

## Usage

Here is an example to specify 10 minutes:

```text
pgroonga_crash_safer.flush_naptime = 10min
```

## See also

  * [`pgroonga_crash_safer` module][pgroonga-crash-safer]

  * [Crash safe][crash-safe]

[pgroonga-crash-safer]:../modules/pgroonga-crash-safer.html

[crash-safe]:../crash-safe.html
