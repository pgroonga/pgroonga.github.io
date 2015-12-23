---
title: "pgroonga.log_type"
layout: en
---

# `pgroonga.log_type` parameter

## Description

Change log output type. Effective type are File, Windows event log and  PostgreSQL log.

## Syntax

```sql
set pgroonga.log_type = type
```

`type` is logging type. Following parameters are available. Default value is `file`.

* file: File ouput
* windows_event_log: Windows event log
* postgresql: PostgreSQL logging. 

### About `windows_event_log`

Following command change log output to Windows event log. 

```
SET pgroonga.log_type = 'windows_event_log';
```

You can change log_type to windows event with only this command, But it record many warnings, 
so It is hard to check with Event viewer. 

If you create ``PGroonga`` event via command prompt, You can filter warning message. This is recommendation setting when you use Windows event logging. 

```
> regsvr32 /n /i:PGroonga ${PostgreSQL install folder}\lib\pgevent.dll
```

This is same step when you regsiter PostgreSQL event log on Windows. Note: [Registering Event Log on Windows](http://www.postgresql.org/docs/9.3/static/event-log-registration.html)

### postgresql.conf syntax

If you set this value log_type permanently, you can write postgresql.conf as follows.

```
pgroonga.log_type = 'windows_event_log';
```

You need reload PostgreSQL. 
