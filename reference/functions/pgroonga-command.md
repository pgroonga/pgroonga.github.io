---
title: pgroonga.command function
---

# `pgroonga.command` function

## Summary

`pgroonga.command` function executes a [Groonga command](http://groonga.org/docs/reference/command.html) and returns the result as `text` type value.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.command(command)
```

`command` is a `text` type value. `pgroonga.command` executes `command` as a Groonga command.

Groonga command returns result as JSON. `pgroonga.command` returns the JSON as `text` type value. You can use [JSON functions and operations provided by PostgreSQL](https://www.postgresql.org/docs/{{ site.postgresql_short_version }}/static/functions-json.html) by casting the result to `json` or `jsonb` type.

## Usage

See [examples in tutorial](../../tutorial/#groonga).

## Attention for `select` Groonga command {#attention}

You need to take care about invalid tuples when you use [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html).

See [`pgroonga_tuple_is_alive` Groonga function](../groonga-functions/pgroonga-tuple-is-alive.html) for details.

## See also

  * [Examples in tutorial](../../tutorial/#groonga)

  * [`pgroonga_tuple_is_alive` Groonga function](../groonga-functions/pgroonga-tuple-is-alive.html)
