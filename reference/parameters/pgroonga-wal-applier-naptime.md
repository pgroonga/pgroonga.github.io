---
title: "pgroonga_wal_applier.naptime parameter"
upper_level: ../
---

# `pgroonga_wal_applier.naptime` parameter

Since 2.3.3.

## Summary

`pgroonga_wal_applier.naptime` parameter controls application interval by [`pgroonga_wal_applier` module][pgroonga-wal-applier].

The larger value, the larger [`pgroonga.max_wal_size` parameter][max-wal-size] value is required.

The smaller value, the more needless CPU load.

## Syntax

In `postgresql.conf`:

```text
pgroonga_wal_applier.naptime = internval
```

`interval`'s default unit is second. You can change unit by specify suffix such as `min` for minutes.

The default is 60 seconds.

## Usage

Here is an example to specify 10 minutes:

```text
pgroonga_wal_applier.naptime = 10min
```

## See also

  * [`pgroonga_wal_applier` module][pgroonga-wal-applier]

  * [Streaming replication][streaming-replication]

[pgroonga-wal-applier]:../modules/pgroonga-wal-applier.html

[streaming-replication]:../streaming-replication.html
