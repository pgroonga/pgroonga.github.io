---
title: Reference manual
upper_level: ../
---

# Reference manual

This document describes about all features. [Tutorial](../tutorial/) focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial](../tutorial/) yet, read tutorial before read this document.

## `pgroonga` schema

`pgroonga` schema is deprecated since 2.0.0. Use `pgroonga_*` functions, operators and operator classes in the current schema for newly written code.

PGroonga defines functions, operators, operator classes and so on into `pgroonga` schema. Only superuser can use features in `pgroonga` schema by default. Superuser needs to grant `USAGE` privilege on `pgroonga` schema to normal users who want to use PGroonga.

  * [`GRANT USAGE ON SCHEMA pgroonga`](grant-usage-on-schema-pgroonga.html)

## `pgroonga` index

  * [`CREATE INDEX USING pgroonga` explained in detail](create-index-using-pgroonga.html)

  * [PGroonga versus GiST and GIN](pgroonga-versus-gist-and-gin.html)

  * [PGroonga versus textsearch and pg\_trgm](pgroonga-versus-textsearch-and-pg-trgm.html)

  * [PGroonga versus pg\_bigm](pgroonga-versus-pg-bigm.html)

  * [Replication](replication.html)

  * [Crash safe][crash-safe]

  * [`jsonb` support][jsonb]

## Operators

### Row level security support

Since 2.3.3.

All v2 operators supports PostgreSQL's [row level security][postgresql-row-level-security].

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

  * [`&=` operator][exact-match-search]: Exact match search

    * Since 2.4.6.

  * [`&^` operator][prefix-search-v2]: Prefix search

  * [`&^~` operator][prefix-rk-search-v2]: Prefix RK search

  * [`&^|` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

  * [`&^>` operator][prefix-search-in-v2]: Prefix search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^|` operator][prefix-search-in-v2] instead.

  * [`!&^|` operator][not-prefix-search-in-v2]: NOT prefix search by an array of prefixes

    * Since 2.2.1.

  * [`&^~|` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

  * [`&^~>` operator][prefix-rk-search-in-v2]: Prefix RK search by an array of prefixes

    * Deprecated since 1.2.1. Use [`&^~|` operator][prefix-rk-search-in-v2] instead.

#### `pgroonga_text_regexp_ops_v2` operator class {#text-regexp-ops-v2}

  * [`LIKE` operator][like]

  * `ILIKE` operator

  * [`&~` operator][regular-expression-v2]: Search by a regular expression

  * [`@~` operator][regular-expression]: Search by a regular expression

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`&~|` operator][regular-expression-in-v2]: Search by an array of regular expressions

    * Since 2.2.1.

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

  * [`@>` operator][contain-array]: Contained search by an array

    * Since 2.2.1.

  * [`&=~` operator][equal-query-v2]: Equal search by easy to use query language

    * Since 3.0.0.

### For `varchar`

#### `pgroonga_varchar_term_search_ops_v2` operator class (default) {#varchar-term-search-ops-v2}

  * `<`

  * `<=`

  * `=`

  * `>=`

  * `>`

  * [`&=` operator][exact-match-search]: Exact match search

    * Since 2.4.6.

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

  * [`&~|` operator][regular-expression-in-v2]: Search by an array of regular expressions

    * Since 2.2.1.

### For `varchar[]`

#### `pgroonga_varchar_array_term_search_ops_v2` operator class (default) {#varchar-array-term-search-ops-v2}

  * [`&>` operator][contain-term-v2]: Check whether a term is included in an array of terms

  * [`%%` operator][contain-term]: Check whether a term is included in an array of terms

    * Don't use this operator for newly written code. It's just for backward compatibility.

  * [`@>` operator][contain-array]: Contained search by an array

    * Since 2.2.1.

  * [`&=~` operator][equal-query-v2]: Equal search by easy to use query language

    * Since 3.0.0.

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

#### `pgroonga_jsonb_full_text_search_ops_v2` operator class {#jsonb-full-text-search-ops-v2}

  * [`&@` operator][match-jsonb-v2]: Full text search against all text data in `jsonb` by a keyword

  * [`&@~` operator][query-jsonb-v2]: Full text search against all text data in `jsonb` by easy to use query language

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

  * [`pgroonga_condition` function][condition]

  * [`pgroonga_escape` function][escape]

  * [`pgroonga_flush` function][flush]

  * [`pgroonga_database_remove` function][database-remove]

  * [`pgroonga_highlight_html` function][highlight-html]

  * [`pgroonga_index_column_name` function][index-column-name]

  * [`pgroonga_is_writable` function][is-writable]

  * [`pgroonga_match_positions_byte` function][match-positions-byte]

  * [`pgroonga_match_positions_character` function][match-positions-character]

  * [`pgroonga_normalize` function][normalize]

  * [`pgroonga_query_escape` function][query-escape]

  * [`pgroonga_query_expand` function][query-expand]

  * [`pgroonga_query_extract_keywords` function][query-extract-keywords]

  * [`pgroonga_result_to_jsonb_objects` function][result-to-jsonb-objects]

  * [`pgroonga_result_to_recordset` function][result-to-recordset]

  * [`pgroonga_set_writable` function][set-writable]

  * [`pgroonga_score` function][score]

  * [`pgroonga_snippet_html` function][snippet-html]

  * [`pgroonga_table_name` function][table-name]

  * [`pgroonga_tokenize` function][tokenize]

  * [`pgroonga_vacuum` function][vacuum]

  * [`pgroonga_wal_apply` function][wal-apply]

  * [`pgroonga_wal_set_applied_position` function][wal-set-applied-position]

  * [`pgroonga_wal_status` function][wal-status]

  * [`pgroonga_wal_truncate` function][wal-truncate]

## Parameters

  * [`pgroonga.enable_trace_log` parameter][enable-trace-log]

    * Since 3.0.8.

  * [`pgroonga.enable_wal` parameter][enable-wal]

  * [`pgroonga.force_match_escalation` parameter][force-match-escalation]

  * [`pgroonga.libgroonga_version` parameter][libgroonga-version]

  * [`pgroonga.lock_timeout` parameter][lock-timeout]

  * [`pgroonga.log_level` parameter][log-level]

  * [`pgroonga.log_path` parameter][log-path]

  * [`pgroonga.log_type` parameter][log-type]

  * [`pgroonga.match_escalation_threshold` parameter][match-escalation-threshold]

  * [`pgroonga.max_wal_size` parameter][max-wal-size]

    * Since 2.3.3.

  * [`pgroonga.query_log_path` parameter][query-log-path]

  * [`pgroonga_crash_safer.flush_naptime` parameter][pgroonga-crash-safer-flush-naptime]

    * Since 2.3.3.

  * [`pgroonga_crash_safer.log_level` parameter][pgroonga-crash-safer-log-level]

    * Since 2.3.3.

  * [`pgroonga_crash_safer.log_path` parameter][pgroonga-crash-safer-log-path]

    * Since 2.3.3.

  * [`pgroonga_standby_maintainer.max_parallel_wal_appliers_per_db` parameter][pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]

    * Since 3.1.2.

  * [`pgroonga_standby_maintainer.naptime` parameter][pgroonga-standby-maintainer-naptime]

    * Since 2.4.2.

## Modules

  * [`pgroonga_check` module][pgroonga-check]

    * Deprecated since 2.3.3. Use [`pgroonga_crash_safer` module][pgroonga-crash-safer] instead.

  * [`pgroonga_crash_safer` module][pgroonga-crash-safer]

    * Since 2.3.3.

  * [`pgroonga_database` module][pgroonga-database]

    * Deprecated since 2.3.3. Use [`pgroonga_crash_safer` module][pgroonga-crash-safer] instead.

  * [`pgroonga_wal_applier` module][pgroonga-wal-applier]

    * Since 2.3.3.

    * [`pgroonga_wal_applier` module][pgroonga-wal-applier] is deprecated since 2.4.2. We use [the `pgroonga_standby_maintainer` module][pgroonga-standby-maintainer] instead.

  * [`pgroonga_standby_maintainer` module][pgroonga-standby-maintainer]

    * Since 2.4.2.

## Groonga functions

You can use them with [`pgroonga_command` function](functions/pgroonga-command.html). You can't use them in `WHERE` clause.

  * [`pgroonga_tuple_is_alive` Groonga function][tuple-is-alive]

## Tuning

Normally, you don't need to tune PGroonga because PGroonga works well by default.

But you need to tune PGroonga in some cases such as a case that you need to handle a very large database. PGroonga uses Groonga as backend. It means that you can apply tuning knowledge for Groonga to PGroonga. See the following Groonga document to tune PGroonga:

  * [Tuning][groonga-tuning]

[crash-safe]:crash-safe.html

[jsonb]:jsonb.html

[postgresql-row-level-security]:{{ site.postgresql_doc_base_url.en }}/ddl-rowsecurity.html

[like]:operators/like.html

[match]:operators/match.html
[query]:operators/query.html
[regular-expression]:operators/regular-expression.html

[contain-array]:operators/contain-array.html
[contain-jsonb]:operators/contain-jsonb.html
[contain-term-v2]:operators/contain-term-v2.html
[contain-term]:operators/contain-term.html
[equal-query-v2]:operators/equal-query-v2.html
[exact-match-search]:operators/exact-match-search.html
[match-in-v2]:operators/match-in-v2.html
[match-jsonb-v2]:operators/match-jsonb-v2.html
[match-v2]:operators/match-v2.html
[not-prefix-search-in-v2]:operators/not-prefix-search-in-v2.html
[prefix-rk-search-in-v2]:operators/prefix-rk-search-in-v2.html
[prefix-rk-search-v2]:operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:operators/prefix-search-in-v2.html
[prefix-search-v2]:operators/prefix-search-v2.html
[query-in-v2]:operators/query-in-v2.html
[query-jsonb-v2]:operators/query-jsonb-v2.html
[query-v2]:operators/query-v2.html
[regular-expression-in-v2]:operators/regular-expression-in-v2.html
[regular-expression-v2]:operators/regular-expression-v2.html
[script-jsonb-v2]:operators/script-jsonb-v2.html
[script-jsonb]:operators/script-jsonb.html
[script-v2]:operators/script-v2.html
[similar-search-v2]:operators/similar-search-v2.html

[upgrade-incompatible]:../upgrade/#incompatible-case

[command]:functions/pgroonga-command.html
[condition]:functions/pgroonga-condition.html
[command-escape-value]:functions/pgroonga-command-escape-value.html
[escape]:functions/pgroonga-escape.html
[flush]:functions/pgroonga-flush.html
[database-remove]:functions/pgroonga-database-remove.html
[highlight-html]:functions/pgroonga-highlight-html.html
[index-column-name]:functions/pgroonga-index-column-name.html
[is-writable]:functions/pgroonga-is-writable.html
[match-positions-byte]:functions/pgroonga-match-positions-byte.html
[match-positions-character]:functions/pgroonga-match-positions-character.html
[normalize]:functions/pgroonga-normalize.html
[query-escape]:functions/pgroonga-query-escape.html
[query-expand]:functions/pgroonga-query-expand.html
[query-extract-keywords]:functions/pgroonga-query-extract-keywords.html
[result-to-jsonb-objects]:functions/pgroonga-result-to-jsonb-objects.html
[result-to-recordset]:functions/pgroonga-result-to-recordset.html
[set-writable]:functions/pgroonga-set-writable.html
[score]:functions/pgroonga-score.html
[snippet-html]:functions/pgroonga-snippet-html.html
[table-name]:functions/pgroonga-table-name.html
[tokenize]:functions/pgroonga-tokenize.html
[vacuum]:functions/pgroonga-vacuum.html
[wal-apply]:functions/pgroonga-wal-apply.html
[wal-set-applied-position]:functions/pgroonga-wal-set-applied-position.html
[wal-status]:functions/pgroonga-wal-status.html
[wal-truncate]:functions/pgroonga-wal-truncate.html

[tuple-is-alive]:groonga-functions/pgroonga-tuple-is-alive.html

[enable-trace-log]:parameters/enable-trace-log.html
[enable-wal]:parameters/enable-wal.html
[force-match-escalation]:parameters/force-match-escalation.html
[libgroonga-version]:parameters/libgroonga-version.html
[lock-timeout]:parameters/lock-timeout.html
[log-level]:parameters/log-level.html
[log-path]:parameters/log-path.html
[log-type]:parameters/log-type.html
[match-escalation-threshold]:parameters/match-escalation-threshold.html
[max-wal-size]:parameters/max-wal-size.html
[query-log-path]:parameters/query-log-path.html

[pgroonga-crash-safer-flush-naptime]:parameters/pgroonga-crash-safer-flush-naptime.html
[pgroonga-crash-safer-log-level]:parameters/pgroonga-crash-safer-log-level.html
[pgroonga-crash-safer-log-path]:parameters/pgroonga-crash-safer-log-path.html

[pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db]:parameters/pgroonga-standby-maintainer-max-parallel-wal-appliers-per-db.html
[pgroonga-standby-maintainer-naptime]:parameters/pgroonga-standby-maintainer-naptime.html

[pgroonga-check]:modules/pgroonga-check.html
[pgroonga-crash-safer]:modules/pgroonga-crash-safer.html
[pgroonga-database]:modules/pgroonga-database.html
[pgroonga-wal-applier]:modules/pgroonga-wal-applier.html
[pgroonga-standby-maintainer]:modules/pgroonga-standby-maintainer.html

[groonga-tuning]:https://groonga.org/docs/reference/tuning.html
