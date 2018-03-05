---
title: Reference manual
---

# Reference manual

This document describes about all features. [Tutorial](../tutorial/) focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial](../tutorial/) yet, read tutorial before read this document.

## `pgroonga` schema

`pgroonga` schema is deprecated since 2.0.0. Use `pgroonga_*` functions, operators and operator classes in the current schema for newly written code.

PGroonga defines functions, operators, operator classes and so on into `pgroonga` schema. Only superuser can use features in `pgroonga` schema by default. Superuser needs to grant `USAGE` privilege on `pgroonga` schema to normal users who want to use PGroonga.

  * [`GRANT USAGE ON SCHEMA pgroonga`](grant-usage-on-schema-pgroonga.html)

## `pgroonga` index

  * [`CREATE INDEX USING pgroonga`](create-index-using-pgroonga.html)

  * [PGroonga versus GiST and GIN](pgroonga-versus-gist-and-gin.html)

  * [PGroonga versus textsearch and pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga versus pg\_bigm](pgroonga-versus-pg-bigm.html)

  * [Replication](replication.html)

  * [`jsonb` support][jsonb]

## Operators

### For `text`

#### `pgroonga_text_full_text_search_ops_v2` operator class (default) {#text-full-text-search-ops-v2}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@*` operator][similar-search-v2]: Similar search

  * [`&~?` operator][similar-search-v2]: Similar search

    * Deprecated since 1.2.2. Use [`&@*` operator][similar-search-v2] instead.

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][match-in-v2] instead.

  * [`&@~|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.2. Use [`&@~|` operator][query-in-v2] instead.

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&@~|` operator][query-in-v2] instead.

#### `pgroonga_text_term_search_ops_v2` operator class {#text-term-search-ops-v2}

  * `<`

    * Since 1.2.2.

  * `<=`

    * Since 1.2.2.

  * `=`

    * Since 1.2.2.

  * `>=`

    * Since 1.2.2.

  * `>`

    * Since 1.2.2.

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^>` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^|` operator][prefix-search-in-v2] instead.

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

  * [`&^~>` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^~|` operator][prefix-rk-search-in-v2] instead.

#### `pgroonga_text_regexp_ops_v2` operator class {#text-regexp-ops-v2}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by a regular expression

    * Don't use this operator for newly written code. It's just for backward compatibility.

### For `text[]`

#### `pgroonga_text_array_full_text_search_ops_v2` operator class (default) {#text-array-full-text-search-ops-v2}

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@*` operator][similar-search-v2]: Similar search

  * [`&~?` operator][similar-search-v2]: Similar search

    * Deprecated since 1.2.2. Use [`&@*` operator][similar-search-v2] instead.

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][match-in-v2] instead.

  * [`&@~|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.2. Use [`&@~|` operator][query-in-v2] instead.

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&@~|` operator][query-in-v2] instead.

#### `pgroonga_text_array_term_search_ops_v2` operator class {#text-array-term-search-ops-v2}

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^>` operator][prefix-search-v2]: Prefix search

    * Deprecated since 1.2.1. Use [`&^` operator][prefix-search-v2] instead.

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^~>` operator][prefix-rk-search-v2]: Prefix RK search

    * Deprecated since 1.2.1. Use [`&^~` operator][prefix-rk-search-v2] instead.

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

### For `varchar`

#### `pgroonga_varchar_term_search_ops_v2` operator class (default) {#varchar-term-search-ops-v2}

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

#### `pgroonga_varchar_full_text_search_ops_v2` operator class {#varchar-full-text-search-ops-v2}

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&@*` operator][similar-search-v2]: Similar search

  * [`&~?` operator][similar-search-v2]: Similar search

    * Deprecated since 1.2.2. Use [`&@*` operator][similar-search-v2] instead.

  * [`` &` `` operator][script-v2]: Advanced search by ECMAScript like query language 

  * [`&@|` operator][match-in-v2]: Full text search by an array of keywords

  * [`&@>` operator][match-in-v2]: Full text search by an array of keywords

    * Deprecated since 1.2.1. Use [`&@|` operator][query-in-v2] instead.

  * [`&@~|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

  * [`&?|` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.2. Use [`&@~|` operator][query-in-v2] instead.

  * [`&?>` operator][query-in-v2]: Full text search by an array of queries in easy to use query language

    * Deprecated since 1.2.1. Use [`&@~|` operator][query-in-v2] instead.

#### `pgroonga_varchar_regexp_ops_v2` operator class {#varchar-regexp-ops-v2}

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by a regular expression

    * Don't use this operator for newly written code. It's just for backward compatibility.

### For `varchar[]`

#### `pgroonga_varchar_array_term_search_ops_v2` operator class (default) {#varchar-array-term-search-ops-v2}

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

  * [`%%` operator][contain-term]: Check whether a term is included in an array of terms

    * Don't use this operator for newly written code. It's just for backward compatibility.

### For boolean, numbers and timestamps

Supported types: `boolean`, `smallint`, `integer`, `bigint`, `real`, `double precision`, `timestamp` and `timestamp with time zone`

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

### For `jsonb`

#### `pgroonga_jsonb_ops_v2` operator class (default) {#jsonb-ops-v2}

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&@~` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-jsonb-v2] instead.

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

## Old operators

### For `text`

#### `pgroonga_text_full_text_search_ops` operator class (default) {#text-full-text-search-ops}

Deprecated since 2.0.0.

Use [`pgroonga_text_full_text_search_ops_v2` operator class](#text-full-text-search-ops-v2) instead.

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Deprecated since 1.2.0. Use [`&@~` operator][query-v2] instead.

#### `pgroonga_text_regexp_ops` operator class {#text-regexp-ops}

Deprecated since 2.0.0.

Use [`pgroonga_text_regexp_ops_v2` operator class](#text-regexp-ops-v2) instead.

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by a regular expression

    * Deprecated since 1.2.1. Use [`&~` operator][regular-expression-v2] instead.

### For `text[]`

#### `pgroonga_text_array_full_text_search_ops` operator class {#text-array-full-text-search-ops}

Deprecated since 2.0.0.

Use [`pgroonga_text_array_full_text_search_ops_v2` operator class](#text-array-full-text-search-ops-v2) instead.

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Deprecated since 1.2.0. Use [`&@~` operator][query-v2] instead.

### For `varchar`

#### `pgroonga_varchar_ops` operator class {#varchar-ops}

Deprecated since 2.0.0.

Use [`pgroonga_varchar_term_search_ops_v2` operator class](#text-varchar-term-search-ops-v2) instead.

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

#### `pgroonga_varchar_full_text_search_ops` operator class {#varchar-full-text-search-ops}

Deprecated since 2.0.0.

Use [`pgroonga_varchar_full_text_search_ops_v2` operator class](#text-varchar-full-text-search-ops-v2) instead.

  * [`&@` operator][match-v2]: Full text search by a keyword

  * [`%%` operator][match]: Full text search by a keyword

    * Deprecated since 1.2.0. Use [`&@` operator][match-v2] instead.

  * [`&@~` operator][query-v2]: Full text search by easy to use query language

  * [`&?` operator][query-v2]: Full text search by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-v2] instead.

  * [`@@` operator][query]: Full text search by easy to use query language

    * Deprecated since 1.2.0. Use [`&@~` operator][query-v2] instead.

#### `pgroonga_varchar_regexp_ops` operator class {#varchar-regexp-ops}

Deprecated since 2.0.0.

Use [`pgroonga_varchar_regexp_ops_v2` operator class](#text-varchar-regexp-ops-v2) instead.

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by a regular expression

    * Deprecated since 1.2.1. Use [`&~` operator][regular-expression-v2] instead.

### For `varchar[]`

#### `pgroonga_varchar_array_ops` operator class {#varchar-array-ops}

Deprecated since 2.0.0.

Use [`pgroonga_varchar_array_term_search_ops_v2` operator class](#text-varchar-array-term-search-ops-v2) instead.

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

  * [`%%` operator][contain-term]: Check whether a term is included in an array of terms

    * Deprecated since 1.2.1. Use [`&>` operator][contain-term-v2] instead.

### For `jsonb`

#### `pgroonga_jsonb_ops` operator class {#jsonb-ops}

Deprecated since 2.0.0.

Use [`pgroonga_jsonb_ops_v2` operator class](#text-jsonb-ops-v2) instead.

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&@~` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

  * [`&?` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

    * Deprecated since 1.2.2. Use [`&@~` operator][query-jsonb-v2] instead.

  * [`` &` `` operator][script-jsonb-v2]: Advanced search by ECMAScript like query language

  * [`@@` operator][script-jsonb]: Advanced search by ECMAScript like query language

    * Deprecated since 1.2.1. Use [`` &` `` operator][script-jsonb-v2] instead.

  * [`@>` operator][contain-jsonb]: Search by a `jsonb` data

## Functions

  * [`pgroonga_command` function][command]

  * [`pgroonga_command_escape_value` function][command-escape-value]

  * [`pgroonga_escape` function][escape]

  * [`pgroonga_flush` function][flush]

  * [`pgroonga_highlight_html` function][highlight-html]

  * [`pgroonga_match_positions_byte` function][match-positions-byte]

  * [`pgroonga_match_positions_character` function][match-positions-character]

  * [`pgroonga_normalize` function][normalize]

  * [`pgroonga_query_escape` function][query-escape]

  * [`pgroonga_query_extract_keywords` function][query-extract-keywords]

  * [`pgroonga_score` function][score]

  * [`pgroonga_snippet_html` function][snippet-html]

  * [`pgroonga_table_name` function][table-name]

  * [`pgroonga_query_expand` function][query-expand]

## Parameters

  * [`pgoronga.enable_wal` parameter][enable-wal]

  * [`pgoronga.lock_timeout` parameter][lock-timeout]

  * [`pgoronga.log_level` parameter][log-level]

  * [`pgoronga.log_path` parameter][log-path]

  * [`pgoronga.log_type` parameter][log-type]

  * [`pgoronga.query_log_path` parameter][query-log-path]

  * [`pgoronga.match_escalation_threshold` parameter][match-escalation-threshold]

## Modules

  * [`pgroonga_check` module](modules/pgroonga-check.html)

## Groonga functions

You can use them with [`pgroonga_command` function](functions/pgroonga-command.html). You can't use them in `WHERE` clause.

  * [`pgroonga_tuple_is_alive` Groonga function][tuple-is-alive]

## Tuning

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See the following Groonga document to tune PGroonga:

  * [Tuning](http://groonga.org/docs/reference/tuning.html)

[jsonb]:jsonb.html

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

[upgrade-incompatible]:../upgrade/#incompatible-case

[command]:functions/pgroonga-command.html
[command-escape-value]:functions/pgroonga-command-escape-value.html)
[escape]:functions/pgroonga-escape.html
[flush]:functions/pgroonga-flush.html
[highlight-html]:functions/pgroonga-highlight-html.html
[match-positions-byte]:functions/pgroonga-match-positions-byte.html
[match-positions-character]:functions/pgroonga-match-positions-character.html
[normalize]:functions/pgroonga-normalize.html
[query-escape]:functions/pgroonga-query-escape.html
[query-extract-keywords]:functions/pgroonga-query-extract-keywords.html
[score]:functions/pgroonga-score.html
[snippet-html]:functions/pgroonga-snippet-html.html
[table-name]:functions/pgroonga-table-name.html
[query-expand]:functions/pgroonga-query-expand.html

[tuple-is-alive]:groonga-functions/pgroonga-tuple-is-alive.html

[enable-wal]:parameters/enable-wal.html
[lock-timeout]:parameters/lock-timeout.html
[log-level]:parameters/log-level.html
[log-path]:parameters/log-path.html
[log-type]:parameters/log-type.html
[query-log-path]:parameters/query-log-path.html
[match-escalation-threshold]:parameters/match-escalation-threshold.html
