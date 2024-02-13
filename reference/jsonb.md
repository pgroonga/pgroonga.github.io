---
title: jsonb support
---

# `jsonb` support

PGroonga also supports `jsonb` type. You can search JSON data by one or more keys and/or one or more values with PGroonga.

You can also search JSON data by full text search against all text values in JSON. It's an unique feature of PGroonga. Built-in PostgreSQL features and [JsQuery](https://github.com/postgrespro/jsquery) don't support it.

Think about the following JSON:

```json
{
  "message": "Server is started.",
  "host": "www.example.com",
  "tags": [
    "web",
  ]
}
```

You can find the JSON by full text search with `server`, `example` or `web` because all text values are full text search target.

## Operators

PGroonga provides the following two operators for searching against `jsonb`:

  * [`@>` operator](operators/jsonb-contain.html)
  * [`@@` operator](operators/jsonb-query.html)

`@>` operator is simpler than `@@` operator but you can't use complex condition such as range search.

`@@` operator is more complex than `@>` operator but you can use complex condition. You can also use full text search against all text values in JSON.

## Comparison with GIN

PostgreSQL provides built-in fast `jsonb` search feature by GIN.

Here are differences between PGroonga and GIN:

  * Index creation time: No difference
  * Search time: PGroonga is a bit faster
  * Features: PGroonga provides more search features
