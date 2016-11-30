---
title: "pgroonga.log_type parameter"
---

# `pgroonga.log_type` parameter

## Summary

`pgroonga.log_type` parameter controls how to log.

You can choose one log type from the followings:

  * Log to a file

  * Log by Windows event log

  * Log by log system in PostgreSQL

PGroonga logs to a file by default. File path is specified by [`pgroonga.log_path` parameter](log-path.html).

## Syntax

In SQL:

```sql
SET pgroonga.log_type = type;
```

In `postgresql.conf`:

```text
pgroonga.log_type = type
```

`type` is an enum value. It means that you must choose one of them:

  * `file`: PGroonga logs to a file

  * `windows_event_log`: PGroonga logs by Windows event log

  * `postgresql`: PGroonga logs by log system in PostgreSQL

## Usage

Here is an example to use log system in PostgreSQL:

```sql
SET pgroonga.log_type = postgresql;
```

Here is an example to use Windows event log:

```sql
SET pgroonga.log_type = windows_event_log;
```

You can confirm logs from PGroonga by [Event Viewer](http://windows.microsoft.com/en-us/windows/open-event-viewer). But it may not be easy to read because Event Viewer shows PGroonga logs with warnings.

You can suppress the warnings from Event Viewer by registering `PGroonga` event source to Windows:

```text
> regsvr32 /n /i:PGroonga ${PostgreSQL install folder}\lib\pgevent.dll
```

See also [Registering Event Log on Windows]({{ site.postgresql_doc_base_url.en }}/event-log-registration.html).

## See also

  * [`pgroonga.log_path` parameter](log-path.html)
