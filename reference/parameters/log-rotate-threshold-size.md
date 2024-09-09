---
title: "pgroonga.log_rotate_threshold_size parameter"
upper_level: ../
---

# `pgroonga.log_rotate_threshold_size` parameter

Since 3.2.3.

## Summary

`pgroonga.log_rotate_threshold_size` parameter controls the rotation of pgroonga.log.

Specifies threshold for pgroonga.log rotation. pgroonga.log file is rotated when log file size is larger than or equals to the threshold.

The default is `0`. It means that that this does not rotate.

This parameter is meaningless if you do not enable pgroonga.log with [`pgroonga.log_type = file`][log-type].

## Syntax

In SQL:

```sql
SET pgroonga.log_rotate_threshold_size = size;
```

In `postgresql.conf`:

```text
pgroonga.log_rotate_threshold_size = size;
```

`size` is a size value. The default unit is bytes. You can change unit by specify suffix such as `MB` for MiB.

## Usage

Here is an example to specify 10 MiB:

```text
pgroonga.log_rotate_threshold_size = 10MB
```

## See also

* [`pgroonga.log_type` parameter][log-type]

* [Groonga's `--log-rotate-threshold-size` option][groonga-log-rotate-threshold-size]

[log-type]:../parameters/log-type.html

[groonga-log-rotate-threshold-size]:https://groonga.org/docs/reference/executables/groonga.html#cmdoption-groonga-log-rotate-threshold-size

