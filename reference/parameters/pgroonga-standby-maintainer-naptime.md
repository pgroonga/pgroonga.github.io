---
title: "pgroonga_standby_maintainer.naptime parameter"
upper_level: ../
---

# `pgroonga_standby_maintainer.naptime` parameter

Since 2.4.2.

## Summary

`pgroonga_standby_maintainer.naptime` parameter controls execution of [the `pgroonga_wal_apply()` function][pgroonga-wal-apply] and [the `pgroonga_vacuum()` function][pgroonga-vacuum] interval by [`pgroonga_standby_maintainer` module][pgroonga-standby-maintainer].

The larger value, more increasing not applicable PGroonga's WAL and more increasing internal unused Groonga tables, columns and records in a standby database.

The smaller value, the heavier IO load.

## Syntax

In `postgresql.conf`:

```text
pgroonga_standby_maintainer.naptime = internval
```

`interval`'s default unit is second. We can change unit to minutes by specify suffix `min` for minutes.

The default is 60 seconds.

## Usage

Here is an example to specify 10 minutes:

```text
pgroonga_standby_maintainer.naptime = 10min
```

## See also

  * [The `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]
  * [The `pgroonga_wal_apply()` function][pgroonga-wal-apply]
  * [The `pgroonga_vacuum()` function][pgroonga-vacuum]

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[pgroonga-vacuum]:../functions/pgroonga-vacuum.html
