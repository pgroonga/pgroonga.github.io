---
title: "pgroonga.log_level parameter"
---

# `pgroonga.log_level` parameter

## Summary

`pgroonga.log_level` parameter controls which logs are recorded.

You can choose one the following log levels:

  * `none`
  * `emergency`
  * `alert`
  * `critical`
  * `error`
  * `warning`
  * `notice`
  * `info`
  * `debug`
  * `dump`

The log level list is sorted by less logs to more logs.

The default log level is `notice`.

## Syntax

In SQL:

```sql
SET pgroonga.log_level = level;
```

In `postgresql.conf`:

```text
pgroonga.log_level = level
```

`level` is an enum value. It means that you must choose one of them:

  * `none`
  * `emergency`
  * `alert`
  * `critical`
  * `error`
  * `warning`
  * `notice`
  * `info`
  * `debug`
  * `dump`

## Usage

Here is an example to disable log:

```sql
SET pgroonga.log_level = none;
```

Here is an example to enable almost log messages:

```sql
SET pgroonga.log_level = debug;
```
