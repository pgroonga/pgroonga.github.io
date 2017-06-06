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

### For `text`

#### `pgroonga.text_full_text_search_ops` operator class (default) {#text-full-text-search-ops}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&?` operator][query-v2]: Full text search by easy to use query language

  * [`@@` operator][query]: Full text search by easy to use query language

    * Deprecated since 1.2.0. Use [`&?` operator][query-v2] instead.

#### `pgroonga.text_regexp_ops` operator class {#text-regexp-ops}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by regular a expression

    * Deprecated since 1.2.1. Use [`&~` operator][regular-expression-v2] instead.

### For `text[]`

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&?` operator][query-v2]: Full text search by easy to use language

  * [`@@` operator][query]: Full text search by easy to use language

    * Deprecated since 1.2.0. Use [`&?` operator][query-v2] instead.

### For `varchar`

#### `pgroonga.varchar_ops` operator class (default) {#varchar-ops}

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

#### `pgroonga.varchar_full_text_search_ops` operator class {#varchar-full-text-search-ops}

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&?` operator][query-v2]: Full text search by easy to use language

  * [`@@` operator][query]: Full text search by easy to use language

    * Deprecated since 1.2.0. Use [`&?` operator][query-v2] instead.

#### `pgroonga.varchar_regexp_ops` operator class {#varchar-regexp-ops}

  * [`&~` operator][regular-expression-v2]: Search by regular expression

  * [`@~` operator][regular-expression]: Search by regular expression

    * Deprecated since 1.2.1. Use [`&~` operator][regular-expression-v2] instead.

### For `varchar[]`

#### `pgroonga.varchar_array_ops` operator class (default) {#varchar-array-ops}

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

  * [`%%` operator][contain-term]: Check whether a term is included in an array of terms

    * Deprecated since 1.2.1. Use [`&>` operator][contain-term-v2] instead.

### For boolean, numbers and timestamps

Supported types: `boolean`, `smallint`, `integer`, `bigint`, `real`, `double precision`, `timestamp` and `timestamp with time zone`

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

### For `jsonb`

#### `pgroonga.jsonb_ops` operator class (default) {#jsonb-ops}

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Deprecated since 1.2.1. Use [`` &` `` operator][script-jsonb-v2] instead.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

## Operators v2

PGroonga 1.Y.Z provides `pgroonga.XXX_v2` operator classes. They don't provide backward compatibility until PGroonga 2.0.0. But they include many improvements aggressively when new versions are released.

If you use them, you need to use [incompatible case steps](../upgrade/#incompatible-case) to upgrade PGroonga.

### For `text`

#### `pgroonga.text_full_text_search_ops_v2` operator class {#text-full-text-search-ops-v2}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator][query-v2]: Full text search by easy to use query language

  * [`@@` operator][query]: Full text search by easy to use query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&~?` operator][similar-search-v2]: Similar search

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][match-in-v2] instead.

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&?|` operator][query-in-v2] instead.

#### `pgroonga.text_term_search_ops_v2` operator class {#text-term-search-ops-v2}

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^>` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^|` operator][query-in-v2] instead.

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

  * [`&^~>` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^~|` operator][query-in-v2] instead.

#### `pgroonga.text_regexp_ops_v2` operator class {#text-regexp-ops-v2}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&~` operator][regular-expression-v2]: Search by regular expression

  * [`@~` operator][regular-expression]: Search by regular expression

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `text[]`

#### `pgroonga.text_array_full_text_search_ops_v2` operator class {#text-array-full-text-search-ops-v2}

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator][query-v2]: Full text search by easy to use language

  * [`@@` operator][query]: Full text search by easy to use language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&~?` operator][similar-search-v2]: Similar search

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][match-in-v2] instead.

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&?|` operator][query-in-v2] instead.

#### `pgroonga.text_array_term_search_ops_v2` operator class {#text-array-term-search-ops-v2}

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^>` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^|` operator][query-in-v2] instead.

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

  * [`&^~>` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^~|` operator][query-in-v2] instead.

### For `varchar`

#### `pgroonga.varchar_full_text_search_ops_v2` operator class {#varchar-full-text-search-ops-v2}

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&?` operator][query-v2]: Full text search by easy to use query language

  * [`@@` operator][query]: Full text search by easy to use query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`&~?` operator][similar-search-v2]: Similar search

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][query-in-v2] instead.

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&?|` operator][query-in-v2] instead.

#### `pgroonga.varchar_regexp_ops_v2` operator class {#varchar-regexp-ops-v2}

  * [`&~` operator][regular-expression-v2]: Search by regular expression

  * [`@~` operator][regular-expression]: Search by regular expression

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `varchar[]`

#### `pgroonga.varchar_array_term_search_ops_v2` operator class {#varchar-array-term-search-ops-v2}

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

  * [`%%` operator][contain-term]: Check whether a term is included in an array of terms

    * Don't use this operator class for newly written code. It's just for backward compatibility.

### For `jsonb`

#### `pgroonga.jsonb_ops_v2` operator class {#varchar-jsonb-ops-v2}

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Don't use this operator class for newly written code. It's just for backward compatibility.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

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

  * [`pgroonga.match_escalation_threshold` parameter](parameters/match-escalation-threshold.html)

## Modules

  * [`pgroonga_check` module](modules/pgroonga-check.html)

## Groonga functions

You can use them with [`pgroonga.command` function](functions/pgroonga-command.html). You can't use them in `WHERE` clause.

  * [`pgroonga_tuple_is_alive` Groonga function](groonga-functions/pgroonga-tuple-is-alive.html)

## Tuning

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See the following Groonga document to tune PGroonga:

  * [Tuning](http://groonga.org/docs/reference/tuning.html)

[like]:operators/like.html

[match]:operators/match.html
[query]:operators/query.html
[regular-expression]:operators/regular-expression.html

[match-v2]:operators/match-v2.html
[query-v2]:operators/query-v2.html
[match-in-v2]:operators/match-in-v2.html
[query-in-v2]:operators/query-in-v2.html
[regular-expression-v2]:operators/regular-expression-v2.html
[contain-term-v2]:operators/contain-term-v2.html
[contain-term]:operators/contain-term.html
[prefix-search-v2]:operators/prefix-search-v2.html
[prefix-rk-search-v2]:operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:operators/prefix-search-in-v2.html
[prefix-rk-search-in-v2]:operators/prefix-rk-search-in-v2.html
[similar-search-v2]:operators/similar-search-v2.html
[script-v2]:operators/script-v2.html
[match-jsonb-v2]:operators/match-jsonb-v2.html
[query-jsonb-v2]:operators/query-jsonb-v2.html
[script-jsonb-v2]:operators/script-jsonb-v2.html
[script-jsonb]:operators/script-jsonb.html
[contain-jsonb]:operators/contain-jsonb.html
