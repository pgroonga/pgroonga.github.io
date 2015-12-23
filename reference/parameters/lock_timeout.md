---
title: "pgroonga.lock_timeout"
layout: en
---

# `pgroonga.lock_timeout` parameter.

## Description

Set lock timeout value. A query will wait for ``timeout`` value  until another query to release the lock.

## Syntax

```sql
set pgroonga.lock_timeout = timeout
```

`timeout` is lock timeout value。Unit is milliseconds。Default value is `10000000`.
