---
title: Reference manual
---

# Reference manual

This document describes about all features. [Tutorial](../tutorial/) focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial](../tutorial/) yet, read tutorial before read this document.

## `pgroonga` schema

PGroonga defines functions, operators, operator classes and so on into `pgroonga` schema. Only superuser can use features in `pgroonga` schema by default. Superuser needs to grant `USAGE` privilege on `pgroonga` schema to normal users who want to use PGroonga.

  * [`GRANT USAGE ON SCHEMA pgroonga`](grant-usage-on-schema-pgroonga.html)

## `pgroonga` index

  * [`CREATE INDEX USING pgroonga`](create-index-using-pgroonga.html)

  * [PGroonga versus GiST and GIN](pgroonga-versus-gist-and-gin.html)

  * [PGroonga versus textsearch and pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga versus pg\_bigm](pgroonga-versus-pg-bigm.html)

  * [Replication](replication.html)

  * [`jsonb` support](jsonb.html)

## Operators

  * [`LIKE` operator](operators/like.html)

  * `ILIKE` operator

  * [`%%` operator](operators/match.html)

  * [`@@` operator](operators/query.html) for non `jsonb` types

  * [`@@` operator](operators/jsonb-query.html) for `jsonb` type

  * [`@>` operator](operators/jsonb-contain.html)

  * [`@~` operator](operators/regular-expression.html)

### v2 operators

PGroonga 1.Y.Z provides `pgroonga.XXX_v2` operator classes. They don't provide backward compatibility until PGroonga 2.0.0. But they include many improvements aggressively when new versions are released.

If you use them, you need to use [incompatible case steps](../upgrade/#incompatible-case) to upgrade PGroonga.

  * `pgroonga.text_full_text_search_ops_v2` operator class

    * `LIKE` operator

    * `ILIKE` operator

    * [`&@` operator](operators/match-v2.html)

    * [`&?` operator](operators/query-v2.html) for non `jsonb` types

    * [`&~?` operator](operators/similar-search-v2.html)

    * [`` &` `` operator](operators/script-v2.html)

    * [`&@>` operator](operators/match-contain-v2.html)

    * [`&?>` operator](operators/query-contain-v2.html) for non `jsonb` types

  * `pgroonga.text_term_search_ops_v2` operator class

    * [`&^` operator](operators/prefix-search-v2.html)

    * [`&^~` operator](operators/prefix-rk-search-v2.html)

  * `pgroonga.text_array_term_search_ops_v2` operator class

    * [`&^>` operator](operators/prefix-search-contain-v2.html)

    * [`&^~>` operator](operators/prefix-rk-search-contain-v2.html)

## Functions

  * [`pgroonga.command` function](functions/pgroonga-command.html)

  * [`pgroonga.command_escape_value` function](functions/pgroonga-command-escape-value.html)

  * [`pgroonga.escape` function](functions/pgroonga-escape.html)

  * [`pgroonga.flush` function](functions/pgroonga-flush.html)

  * [`pgroonga.highlight_html` function](functions/pgroonga-highlight-html.html)

  * [`pgroonga.match_positions_byte` function](functions/pgroonga-match-positions-byte.html)

  * [`pgroonga.match_positions_character` function](functions/pgroonga-match-positions-character.html)

  * [`pgroonga.query_escape` function](functions/pgroonga-query-escape.html)

  * [`pgroonga.query_extract_keywords` function](functions/pgroonga-query-extract-keywords.html)

  * [`pgroonga.score` function](functions/pgroonga-score.html)

  * [`pgroonga.snippet_html` function](functions/pgroonga-snippet-html.html)

  * [`pgroonga.table_name` function](functions/pgroonga-table-name.html)

## Parameters

  * [`pgroonga.enable_wal` parameter](parameters/enable-wal.html)

  * [`pgroonga.lock_timeout` parameter](parameters/lock-timeout.html)

  * [`pgroonga.log_level` parameter](parameters/log-level.html)

  * [`pgroonga.log_path` parameter](parameters/log-path.html)

  * [`pgroonga.log_type` parameter](parameters/log-type.html)

  * [`pgroonga.query_log_path` parameter](parameters/query-log-path.html)

## Groonga functions

You can use them with [`pgroonga.command` function](functions/pgroonga-command.html). You can't use them in `WHERE` clause.

  * [`pgroonga_tuple_is_alive` Groonga function](groonga-functions/pgroonga-tuple-is-alive.html)

## Tuning

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See the following Groonga document to tune PGroonga:

  * [Tuning](http://groonga.org/docs/reference/tuning.html)
