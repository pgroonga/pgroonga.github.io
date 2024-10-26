---
title: "pgroonga.query_log_rotate_threshold_size parameter"
upper_level: ../
---

# `pgroonga.query_log_rotate_threshold_size` parameter

Since 3.2.3.

## Summary

`pgroonga.query_log_rotate_threshold_size` parameter controls the rotation of query log.

Specifies threshold for query log rotation. Query log file is rotated when query log file size is larger than or equals to the threshold.

The default is `0`. It means that that this does not rotate.

This parameter is meaningless if query logging is not enabled with the [`pgroonga.query_log_path` parameter][query-log-path].

## Syntax

In SQL:

```sql
SET pgroonga.query_log_rotate_threshold_size = size;
```

In `postgresql.conf`:

```text
pgroonga.query_log_rotate_threshold_size = size;
```

`size` is a size value. The default unit is bytes. You can change unit by specify suffix such as `MB` for MiB.

## Usage

Here is an example to specify 10 MiB:

```text
pgroonga.query_log_rotate_threshold_size = 10MB
```

## See also

* [`pgroonga.query_log_path` parameter][query-log-path]

* [Groonga's `--query-log-rotate-threshold-size` option][groonga-query-log-rotate-threshold-size]

[query-log-path]:../parameters/query-log-path.html

[groonga-query-log-rotate-threshold-size]:https://groonga.org/docs/reference/executables/groonga.html#cmdoption-groonga-query-log-rotate-threshold-size
