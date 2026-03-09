---
title: "pgroonga.enable_trace_log parameter"
upper_level: ../
---

# `pgroonga.enable_trace_log` parameter

Since 3.0.8.

## Summary

`pgroonga.enable_trace_log` parameter controls whether trace log is enabled or not.

If you enable trace log, PGroonga performance will be decreased.

Trace logs are logged as `notice` log level messages.

The default value is `off`. It means that trace logs aren't logged.

## Syntax

In SQL:

```sql
SET pgroonga.enable_trace_log = boolean;
```

In `postgresql.conf`:

```text
pgroonga.enable_trace_log = boolean
```

`boolean` is a boolean value. There are some literals for boolean value such as `on`, `off`, `true`, `false`, `yes` and `no`.

## Usage

Here is an example SQL to enable trace log:

```sql
SET pgroonga.enable_trace_log = on;
```

Here is an example configuration to enable trace log:

```sql
pgroonga.enable_trace_log = on
```

## See also

  * [`pgroonga.log_level` parameter][log-level]

[log-level]:log-level.html
