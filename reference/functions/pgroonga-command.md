---
title: pgroonga.command function
layout: en
---

# `pgroonga.command` function

`pgroonga.command` function executes a [Groonga command](http://groonga.org/docs/reference/command.html) and returns the result as `text` type value.

Here is `pgroonga.command` signature:

```text
pgroonga.command(command)
```

`command` is a `text` type value. `pgroonga.command` executes `command` as a Groonga command.

Groonga command returns result as JSON. `pgroonga.command` returns the JSON as `text` type value. You can use [JSON functions and operations provided by PostgreSQL](http://www.postgresql.org/docs/current/static/functions-json.html) by casting the result to `json` or `jsonb` type.

See also [examples in tutorial](../../tutorial/#groonga).
