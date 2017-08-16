---
title: "pgroonga.lock_timeout parameter"
upper_level: ../
---

# `pgroonga.lock_timeout` parameter

## Summary

`pgroonga.lock_timeout` parameter controls lock timeout.

PGroonga tries to acquire a lock the specified timeout times at 1 millisecond interval until PGroonga acquires a lock.

The default value is `10000000`. It means that PGroonga tries to acquire a lock for about 2.7 hours until PGroonga acquires a lock by default.

## Syntax

In SQL:

```sql
SET pgroonga.lock_timeout = timeout;
```

In `postgresql.conf`:

```text
pgroonga.lock_timeout = timeout
```

`timeout` is a number value.

## Usage

Here is an example to change PGroonga gives up acquiring a lock when PGroonga can't acquire a lock for 1 minute (`1 millisecond * 60000 = 60000 milliseconds = 60 seconds = 1 minute`):

```sql
SET pgroonga.lock_timeout = 60000;
```
