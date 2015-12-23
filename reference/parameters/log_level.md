---
title: "pgroonga.log_level"
layout: en
---

# `pgroonga.log_level` parameter.

## Description

Change logging level.

## Syntax

```sql
set pgroonga.log_level = level
```

`level` is logging level. Following levels are available. Log levels follow are listed in the order of increasing severity. Default log_level is `notice`.

* none
* emergency
* alert
* critical
* error
* warning
* notice
* info
* debug
* dump
