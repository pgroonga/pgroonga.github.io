---
title: おしらせ
upper_level: ../
---

# おしらせ

## 2.3.1: 2021-08-05 {#version-2-3-1}

### 改良

  * [[Ubuntu][ubuntu]] Added packages for PostgreSQL 11 packages provided by PostgreSQL Global Developer Group.[GitHub:#184][Reported by Tim Abbott]

  * [[`pgroonga_normalize` function][normalize]] Add support for "normalizers-mapping" index option.

    * This requires Groonga 11.0.5 (not released yet) or later.

  * [[`pgroonga_normalize` function][normalize]] Added support for substituting '${table:INDEX_NAME}'.

  * [[`pgroonga_result_to_recordset` function][result-to-recordset]] Added support for term indexed column.

  * [[`pgroonga_result_to_jsonb_objects` function][result-to-jsonb-objects]] Added support for term indexed column.

  * [[Ubuntu][ubuntu]] Dropped support Ubuntu 20.10.

### 感謝

  * Tim Abbott

## 2.3.0: 2021-05-14 {#version-2-3-0}

### 改良

  * [[Debian][debian]] Added support for Debian GNU/Linux bullseye.

  * [[Windows][windows]] Upgraded bundled Groonga to 11.0.2.

  * [[`pgroonga_result_to_recordset` function][result-to-recordset]] Added.

  * [[`pgroonga_result_to_jsonb_objects` function][result-to-jsonb-objects]]
    Added.

### 修正

  * Fixed a bug that `NULL` `jsonb` data with partial index may not
    return records of `NULL` value. [GitHub:#181][Reported by Artem]

### 感謝

  * Artem

## 2.2.9: 2021-04-04 {#version-2-2-9}

### 改良

  * [[Debian][debian]] Dropped support for Debian GNU/Linux buster i386.

  * [[Debian][debian]] Added support for arm64.

  * [[Windows][windows]] Upgraded bundled Groonga to 11.0.1.

  * Avoided `COUNT(*)` with large value.
    [GitHub:clear-code/redmine_full_text_search#96][Reported by ryouma-nagare]

### 感謝

  * ryouma-nagare

## 2.2.8: 2020-12-27 {#version-2-2-8}

### 改良

  * [[Ubuntu][ubuntu]], [[Debian][debian]] Added packages for
    PostgreSQL packages provided by PostgreSQL Global Developer Group.

  * [[Debian][debian]] Dropped support for Debian GNU/Linux stretch.

  * [[Ubuntu][ubuntu]] Added support for Ubuntu 20.10.

  * [[CentOS][centos]] Dropped support for CentOS 6.

  * [[`pgroonga.force_match_escalation` parameter][force-match-escalation]]
    Added. [GitHub#157][Reported by Hung Nguyen V.]

  * Similar search functions: Increased cost to ensure using index
    scan. [GitHub#163][Reported by oyhan]

  * [[Windows][windows]] Upgraded bundled Groonga to 10.1.0

  * [[`pgroonga_match_positions_byte` function][match-positions-byte]]
    Added support for custom normalizer.

  * [[`pgroonga_match_positions_character` function][match-positions-character]]
    Added support for custom normalizer.

### 修正

  * [[`pgroonga_wal_truncate` function][wal-truncate]] Fixed a bug
    that calling this after large update is failed. This bug was
    introduced in 2.2.6. [GitHub#150][Reported by BiscuitsColonel]

### 感謝

  * Hung Nguyen V.

  * oyhan

  * BiscuitsColonel

## 2.2.7: 2020-11-10 {#version-2-2-7}

### 改良

  * Provided the packages for PostgreSQL 13.

  * [[Windows][windows]] Upgraded bundled Groonga to 10.0.8

  * Added support for using system xxHash by HAVE_XXHASH

### 修正

  * Fixed a bug that PGroonga might crash when PostgreSQL wrote WAL.

  * [[Ubuntu][ubuntu]], [[Debian][debian]] Fixed a bug that WAL
    support was disabled. [GitHub#144][Reported by DeoLeung and
    zyp-rgb]

### 感謝

  * Zhanzhao (Deo) Liang

  * zyp-rgb

## 2.2.6: 2020-07-01 {#version-2-2-6}

NOTE: If you have PGroonga index for `jsonb`, you need to reindex all
your PGroonga indexes for `jsonb` after you upgrade to this
version. This version has a fix for `jsonb`.

### 改良

  * [[Ubuntu][ubuntu]] Added support for Ubuntu 20.04.

  * [[Ubuntu][ubuntu]] Dropped support for Ubuntu 16.04.

  * Added support for PostgreSQL 13.

  * Dropped support for PostgreSQL 9.5.

  * Added support for Postgres-XL.
    [GitHub#140][Reported by nateekarn-e]

  * [[Windows][windows]] Upgraded bundled Groonga to 10.0.4.

  * Suppressed assertions reported by debug build PostgreSQL.
    [GitHub#135][Reported by Malt]

  * [[`pgroonga_index_name` function][index-column-name]] Added.

### 修正

  * [`jsonb`] Fixed a bug that wrong paths are generated for nested
    objects/array. You need to reindex all PGroonga indexes for
    `jsonb` to apply this fix after you upgrade to PGroonga 2.2.6.
    [GitHub#137][Reported by Zhanzhao (Deo) Liang]

### 感謝

  * Malt

  * Zhanzhao (Deo) Liang

  * nateekarn-e

## 2.2.5: 2020-03-12 {#version-2-2-5}

### 修正

  * Fixed a bug that failed update to version 2.2.4.

  * [`jsonb`] Added a workaround for `SELECT COUNT(*)`.

## 2.2.4: 2020-03-12 {#version-2-2-4}

### 修正

  * [[Debian][debian]] Fixed wrong PostgreSQL package name.

  * [[Ubuntu][ubuntu]] Fixed wrong PostgreSQL package name.
    [GitHub#128][Reported by Volo Zyko] [Reported by punchagan]

### 感謝

  * Volo Zyko

  * punchagan

## 2.2.3: 2020-03-11 {#version-2-2-3}

### 改良

  * Added support for `CREATE TABLE`, `CREATE INDEX` and `TRUNCATE` in
    the same transaction.
    [GitHub#123][Reported by Alex Rudenko]

  * Reduced the number of estimated size when too much estimated case.

  * Increased operator cost to 300 from 200.

  * [`jsonb`] Added support for `SELECT COUNT(*)`.

### 修正

  * Fixed a bug that PGroonga occurred error on sequential search
    when we set PGroonga's index with libgroonga 10.0.0 or later.

### 感謝

  * Alex Rudenko

## 2.2.2: 2019-11-14 {#version-2-2-2}

### 改良

  * Added support for PostgreSQL 12.

  * Dropped support for PostgreSQL 9.4.

  * Dropped support for Greenplum.

  * [[Windows][windows]] Upgraded bundled Groonga to 9.0.9.

  * Upgrade bundled xxHash to 0.7.2 from 0.6.2.

  * [[Debian][debian]] Added support for Debian GNU/Linux buster.

  * [[Ubuntu][ubuntu]] Added support for Ubuntu 19.10.

  * [[Ubuntu][ubuntu]] Dropped support for Ubuntu 18.10.

  * [[CentOS][centos]] Added support for CentOS 8 but WAL isn't enabled.

  * Removed needless copyright holders.

### 修正

  * Fix a build failure on CentOS 6.

## 2.2.1: 2019-07-19 {#version-2-2-1}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 9.0.4.

  * [[`&~|` operator][regular-expression-in-v2]] Added.

  * [[`!&^|` operator][not-prefix-search-in-v2]] Added.

  * Added support for [`@>` operator][contain-array] to the following
    operator classes.

    * [`pgroonga_text_array_term_search_ops_v2` operator class][text-array-term-search-ops-v2]

    * [`pgroonga_varchar_array_term_search_ops_v2` operator class][varchar-array-term-search-ops-v2]

  * [[`pgroonga_query_expand` function][query-expand]] Added support
    for synonyms only data.

### 修正

  * Fix a bug that index only scan is used for nullable column.

## 2.2.0: 2019-06-05 {#version-2-2-0}

### 改良

  * Added support for Groonga 9.0.3.

  * [[Windows][windows]] Upgraded bundled Groonga to 9.0.3.

  * Added operator class for `int4[]`. Normally, this isn't
    useful. It's useful only when you want to access `int4[]` data by
    [`pgroonga_command` function][command].

## 2.1.9: 2019-05-08 {#version-2-1-9}

### 改良

  * Added support for Groonga 9.0.2.

  * [[Windows][windows]] Upgraded bundled Groonga to 9.0.2.

  * [[Ubuntu][ubuntu]] Added support for Ubuntu 18.10.

  * [[Ubuntu][ubuntu]] Added support for Ubuntu 19.04.

  * [[Ubuntu][ubuntu]] Dropped support for Ubuntu 14.04.

## 2.1.8: 2019-01-11 {#version-2-1-8}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.1.0.

  * [[`pgroonga_database`][pgroonga-database]]: Added. It provides
    functions that manage PGroonga database. For now,
    [`pgroonga_database_remove` function][database-remove] is only
    provided.

## 2.1.7: 2018-12-25 {#version-2-1-7}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.9.

  * Added support for PostgreSQL 11.

  * [[`pgroonga_tokenize` function][tokenize]] Added a new function
    that tokenizes the given text.

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]]
    Added support for token filter options.

  * [[`pgroonga_normalize` function][normalize]] Added support for
    normalizer options.

  * [[`pgroonga_vacuum` function][vacuum]] Added a new function that
    removes garbage in Groonga explicitly.

### 修正

  * Fixed a crash bug on error in `SELECT`.

  * Fixed a bug that needless records in `IndexStatuses` internal
    Groonga table on `VACUUM`.
    [Gitter#5c10aad7e4787d16e3833ffe][Reported by kwata]

  * Fixed a bug that wrong ctid may be returned in `SELECT`.
    [GitHub#89][Reported by Daisuke Ando]

  * [[`pgroonga_escape` function][escape]] Fixed a bug that
    `pgroonga_escape(float4)` returns wrong result.

### 感謝

  * kwata

  * Daisuke Ando

## 2.1.6: 2018-10-18 {#version-2-1-6}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.7.

  * Reduces memory usage on multiple sub-selects.

  * Reduces memory usage on index only scan.
    [groonga-dev,04684][Reported by Kawakami]

### 修正

  * Fixed a bug that streaming replication doesn't work.
    [GitHub#84][Reported by tongsama]

### 感謝

  * tongsama

  * Kawakami

## 2.1.4: 2018-09-18 {#version-2-1-4}

### 改良

  * Use resource release mechanism to release internal data in scan.
    [GitHub#82][Reported by dodaisuke]

### 感謝

  * dodaisuke

## 2.1.3: 2018-09-11 {#version-2-1-3}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.6.

  * Added debug logs.

  * Added a workaround for error by `SELECT FOR UPDATE NOWAIT`.
    It's a PostgreSQL problem.
    [GitHub#80][Reported by dodaisuke]

  * [`&@~` operator][query-v2] Added valid index check.

  * Improved PGroonga index detection for PGroonga < 9.6.

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]]
    Added `query_allow_column` option to use `column:...` syntax in
    `&@~`.

### 修正

  * Fixed a crash bug that is occurred when executing `&@~` by
    sequential search with multiple indexes.

### 感謝

  * dodaisuke

## 2.1.2: 2018-08-23 {#version-2-1-2}

### 改良

  * Added support for PostgreSQL 11.

  * [[`pgroonga_score` function][score]] Added missing error checks.

  * Added more debug logs on insert and delete.

### 修正

  * [[`pgroonga_score` function][score]] Fixed a bug that score is 0 when
    HOT redirection is occurred.

## 2.1.1: 2018-08-08 {#version-2-1-1}

### 修正

  * Fixed packages.

## 2.1.0: 2018-08-08 {#version-2-1-0}

### 改良

  * Improved cost estimation.

  * [[Travis CI][travis-ci]] Added support for WAL with `PGROONGA_MASTER=yes`.
    [GitHub#71][Reported by Jason Truesdell]

  * Added support for closing unused files after recreating indexes.
    [GitHub#72][Reported by Jason Truesdell]

  * Added support for index only scan availability check for vector
    column.

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.5.

  * Required Groonga 8.0.5 or later.

  * [[`pgroonga_score` function][score]] Added debug logs.

  * [[Debian][debian]] Dropped Debian GNU/Linux Jessie support.

  * [[Ubuntu][ubuntu]] Dropped Ubuntu 17.10 support.

### 修正

  * [WAL] Fixed a bug that WAL may be broken when multiple updates are
    occurred at once.
    [GitHub#70][Reported by Eiji Ito]

### 感謝

  * Jason Truesdell

  * Eiji Ito

## 2.0.9: 2018-07-04 {#version-2-0-9}

### 修正

  * Fixed a bug that sequential full text search against array data uses wrong configuration.

## 2.0.8: 2018-07-03 {#version-2-0-8}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.4.

  * Improved index cost estimation.

## 2.0.7: 2018-06-07 {#version-2-0-7}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.3.

  * Changed to require Groonga 8.0.3 or later.

  * Added index options support on sequential scan in the following operators:

    * [`&@` operator][match-v2]

    * [`&@~` operator][query-v2]

    * [`` &` `` operator][script-v2]

  * [[`pgroonga_highlight_html` function][highlight-html]] Added support for index based highlight.

  * Increased sequential scan cost of full text search related operators. They aren't so lightweight.

### 修正

  * Fixed a bug in 2.0.5 to 2.0.6 upgrade SQL.

  * Fixed a bug that `text[] &@~` has different behavior between index scan and sequential scan.

## 2.0.6: 2018-05-14 {#version-2-0-6}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.2.

  * Changed to require Groonga 8.0.2 or later.

  * Added scorer support in the following operators:

    * [`&@` operator][match-v2]

    * [`&@~` operator][query-v2]

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]] Added tokenizer options support.

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]] Added normalizer options support.

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]] Added new options.

    * `lexicon_type`

  * [[Ubuntu][ubuntu]] Added Ubuntu 18.04 (Bionic Beaver) support.

  * [[Ubuntu][ubuntu]] Dropped Ubuntu 17.04 (Zesty Zapus) support.

  * [[Debian][debian]] Added package for PostgreSQL 10 on Debian GNU/Linux Strecth.

### 修正

  * Fixed a bug that wrong search result may be returned when `ARRAY` has one or more `NULL`.
    [GitHub#64][Reported by peter-schmitz]

  * Fixed a bug that `timestamp (without time zone)` value is stored with long offset.

    * You need to recreate PGroonga indexes that use `timestamp (without time zone)` after you upgrade PGroonga.

### 感謝

  * peter-schmitz

## 2.0.5: 2018-04-04 {#version-2-0-5}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.1.

### 修正

  * Fixed a bug that large index update may fail with WAL related error after [[`pgroonga_wal_truncate` function][wal-truncate]] is used.

  * Fixed required Groonga version. PGroonga will always depend on the latest Groonga to prevent this problem.

## 2.0.4: 2018-03-22 {#version-2-0-4}

### 改良

  * [[`pgroonga_score` function][score]] Improved performance.

    * `pgroonga_score(tableoid, ctid)` version is faster than existing `pgroonga_score(record)` version.

  * Added parallel query support.
    [GitHub#59][Reported by tedypranolo]

  * Added summer time support.

  * Added weight support in the following operators:

    * [`&@` operator][match-v2]

    * [`&@~` operator][query-v2]

### 感謝

  * tedypranolo

## 2.0.3: 2018-03-08 {#version-2-0-3}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 8.0.0.

  * Improved performance for sub `SELECT`.
    [GitHub#55][Reported by tedypranolo]

  * Improved `text[]` load performance.
    [groonga-dev,04533][Reported by Toshio Uchiyama]

  * [[`pgroonga_jsonb_full_text_search_ops_v2` operator class][jsonb-full-text-search-ops-v2]] Added.

  * [[`CREATE INDEX USING PGroonga`][create-index-using-pgroonga]] Added new options.

    * `full_text_search_normalizer`

    * `regexp_search_normalizer`

    * `prefix_search_normalizer`

  * Made query parsing loose. No syntax error is occurred.
    [GitHub:zulip/zulip#8457][Reported by burek967]

  * [[`pgroonga_wal_apply` function][wal-apply]] Added.

  * [[`pgroonga_wal_truncate` function][wal-truncate]] Added.

  * [[`pgroonga_set_writable` function][set-writable]] Added.

  * [[`pgroonga_is_writable` function][is-writable]] Added.

  * Added vector column comparison support.

    * It requires Groonga 8.0.1.

  * [[`pgroonga.libgroonga_version` parameter][libgroonga-version]] Added.

  * [WAL] Added record deletion on `VACUUM`.

  * Changed location to store `ctid` to source table key from a column.

    * It requires Groonga 8.0.1.

    * It doesn't break backward compatibility. Only newly created indexes uses this style. Old style indexes are still supported.

  * [[`pgroonga_normalize` function][normalize]] Added.
    [GitHub#13][Patch by Fujimoto Seiji]

### 修正

  * Fixed a bug that `timestamp (without time zone)` value is stored as local time.

    * You need to recreate PGroonga indexes that use `timestamp (without time zone)` after you upgrade PGroonga.

  * Fixed a bug that `jsonb` WAL was broken since 2.0.2.

  * Fixed a bug that wrong table may be removed on `VACUUM`.

  * [[`pgroonga_text_array_full_text_search_ops_v2` operator class][text-array-full-text-search-ops-v2]] Fixed a bug that it may return wrong result.

    * You need to recreate PGroonga indexes that use [`pgroonga_text_array_full_text_search_ops_v2` operator class][text-array-full-text-search-ops-v2] after you upgrade PGroonga.

  * [[`pgroonga_varchar_full_text_search_ops_v2` operator class][varchar-full-text-search-ops-v2]] Fixed a bug that needless 4KiB check is done.
    [Reported by Rising Sun]

### 感謝

  * tedypranolo

  * Toshio Uchiyama

  * Rising Sun

  * Fujimoto Seiji

## 2.0.2: 2017-10-10 {#version-2-0-2}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.7.

  * [[Ubuntu][ubuntu]] Added Ubuntu 17.10 (Artful Aardvark) support.

  * Added `INTEGER_COLUMN = ANY(ARRAY[]::integer[])` support.
    [GitHub#53][Reported by tedypranolo]

  * [[`pgroonga_query_expand` function][query-expand]] Added `text` type for synonym column.

  * Improved index search estimation with `IMMUTABLE` or `STABLE` function call.

  * Added missing empty array check for the following functions:

    * [`pgroonga_snippet_html` function][snippet-html]

    * [`pgroonga_highlight_html` function][highlight-html]

    * [`pgroonga_command` function][command]

  * Added PostgreSQL 10 packages.

### 修正

  * Fixed build error on Windows.

  * Fixed a bug that creating index may be removed by `VACUUM` including `AUTO VACUUM`.

### 感謝

  * tedypranolo

## 2.0.1: 2017-08-17 {#version-2-0-1}

### 修正

  * Fixed upgrading failure on PostgreSQL 9.5 or earlier.

## 2.0.0: 2017-08-17 {#version-2-0-0}

This is the second major release! It's upgradable from 1.X! 2.X is backward compatible with 1.X!

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.5.

  * Added PostgreSQL 10 support.

  * Added logical replication support.

  * Changed to install functions, operators and operator classes to the current schema with `pgroonga_` prefix from `pgroonga` schema without `pgroonga_` prefix. `pgroonga` schema is still used for backward compatibility. But `pgroonga` schema is deprecated.

  * Changed to the default operator classes to `_v2` operator classes.

### 修正

  * Fixed a crash bug when primary key column isn't the first indexed column.
    [GitHub#50][Reported by tedypranolo]

  * Fixed upgrade failure from 1.2.0 on PostgreSQL 9.6 or later.

### 感謝

  * tedypranolo

## 1.2.3: 2017-07-03 {#version-1-2-3}

### 修正

  * [[Ubuntu][ubuntu]] Fixed invalid package.

  * [[Debian][debian]] Supported Debian GNU/Linux Stretch.

## 1.2.2: 2017-07-03 {#version-1-2-2}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.4.

  * Improved performance against empty array.

  * [[`pgroonga.text_term_search_ops_v2` operator class][text-term-search-ops-v2]] Ignored tokenizer option.

  * Supported `NULL` value for `jsonb` column.
    [groonga-dev,04382][Reported by Hirokazu Matsuo]

  * [[`pgroonga.query_expand` function][query-expand]]: Added

  * [[`pgroonga.text_term_search_ops_v2` operator class][text-term-search-ops-v2]] Supported comparison operators.

  * Stopped to use `?` for operator name:
    [GitHub#45][Reported by YUKI "Piro" Hiroshi]

    * [[`&@~` operator][query-v2]]: Added. Deprecated `&?` operator.

    * [[`&@~|` operator][query-in-v2]]: Added. Deprecated `&?|` operator.

    * [[`&@*` operator][similar-search-v2]]: Added. Deprecated `&~?` operator.

### 感謝

  * Hirokazu Matsuo

  * YUKI "Piro" Hiroshi

## 1.2.1: 2017-06-08 {#version-1-2-1}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.3.

  * [[`pgroonga.text_full_text_search_ops_v2` operator class][text-full-text-search-ops-v2]] Supported `@@` and `%%` for backward compatibility.

  * [[`pgroonga.text_array_full_text_search_ops_v2` operator class][text-array-full-text-search-ops-v2]] Added.

  * [[`pgroonga.text_array_full_text_search_ops` operator class][text-array-full-text-search-ops]] Added the following v2 operators for forward compatibility:

    * [`&@` operator][match-v2]

    * [`&?` operator][query-v2]

  * [[`pgroonga.varchar_full_text_search_ops_v2` operator class][varchar-full-text-search-ops-v2]] Added.

  * [[`pgroonga.varchar_full_text_search_ops` operator class][varchar-full-text-search-ops]] Added the following v2 operators for forward compatibility:

    * [`&@` operator][match-v2]

    * [`&?` operator][query-v2]

  * [[`pgroonga.text_term_search_ops_v2` operator class][text-term-search-ops-v2]] Added the following operators:

    * [`&^|` operator][prefix-search-in-v2]

    * [`&^~|` operator][prefix-rk-search-in-v2]

  * [[`pgroonga.text_array_term_search_ops_v2` operator class][text-array-term-search-ops-v2]] Added the following operators:

    * [`&^` operator][prefix-search-v2]

    * [`&^~` operator][prefix-rk-search-v2]

  * [[`pgroonga.text_array_term_search_ops_v2` operator class][text-array-term-search-ops-v2]] Added the following operators:

    * [`&^|` operator][prefix-search-in-v2]

    * [`&^~|` operator][prefix-rk-search-in-v2]

  * [[`pgroonga.text_regexp_ops_v2` operator class][text-regexp-ops-v2]] Added.

  * [[`pgroonga.varchar_regexp_ops_v2` operator class][text-regexp-ops-v2]] Added.

  * [[`pgroonga.varchar_array_term_search_ops_v2` operator class][varchar-array-term-search-ops-v2]] Added.

  * [[`pgroonga.varchar_array_ops` operator class][varchar-array-ops]] Added the following v2 operators for forward compatibility:

    * [`&>` operator][contain-term-v2]

  * [[`pgroonga.jsonb_ops_v2` operator class][jsonb-ops-v2]] Added.

  * [[`pgroonga.jsonb_ops` operator class][jsonb-ops]] Added the following v2 operators for forward compatibility:

    * [`` &@ `` operator][match-jsonb-v2]

    * [`` &? `` operator][query-jsonb-v2]

    * [`` &` `` operator][script-jsonb-v2]

  * [[Debian][debian]][[Ubuntu][ubuntu]] Supported log rotation by logrotate.

  * [[`pgroonga.text_regexp_ops` operator class][text-regexp-ops]] Added the following v2 operators for forward compatibility:

    * [`&~` operator][regular-expression-v2]

  * [[`pgroonga.varchar_regexp_ops` operator class][varchar-regexp-ops]] Added the following v2 operators for forward compatibility:

    * [`&~` operator][regular-expression-v2]

  * [[`pgroonga.match_escalation_threshold` parameter][match-escalation-threshold]] Added. [GitHub#37][Reported by ArturFormella]

### 修正

  * Fixed a bug that removed entries may be referenced. [GitHub#36][Reported by peter-schmitz]

### 感謝

  * peter-schmitz

  * ArturFormella

## 1.2.0: 2017-04-29 {#version-1-2-0}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.2.

  * [[CentOS](../install/centos.html) 6] Supported WAL.

  * Dropped [[CentOS](../install/centos.html) 5] support.

  * [[Ubuntu](../install/ubuntu.html) 17.04] Supported. It supports WAL.

  * [[Replication](../reference/replication.html)] Supported NULL column value.

  * [[`pgroonga.score` function](../reference/functions/pgroonga-score.html)] Improved performance. This improvements makes `pgroonga.score` function 30 times faster. [GitHub#31][Reported by yongxianggao-chanjet]

  * Supported PostgreSQL 9.6.2.

  * Required Groonga 6.1.1 or later.

  * [[`pgroonga_check`][pgroonga-check]] Added. It checks PGroonga database consistency on startup. If PGroonga database is broken, it tries to recover the database.

  * Supported applying WAL on `INSERT`.

  * [[`CREATE INDEX USING pgroonga`][create-index-using-pgroonga] Supported token filters. [GitHub#32][Reported by Tim Bellefleur]

  * [[Windows][windows]] Supported PostgreSQL 9.5.6.

  * [[Windows][windows]] Supported PostgreSQL 9.6.2.

  * Added [`&@` operator](../reference/operators/match-v2.html) to `pgroonga.text_full_text_search_ops` (the current default operator class for `text` type). It means that you can use `&@` operator both with `pgroonga.text_full_text_search_ops` and `pgroonga.text_full_text_search_ops_v2` operator classes. [`%%` operator](../reference/operators/match.html) is deprecated.

  * Added [`&?` operator](../reference/operators/query-v2.html) to `pgroonga.text_full_text_search_ops` (the current default operator class for `text` type). It means that you can use `&?` operator both with `pgroonga.text_full_text_search_ops` and `pgroonga.text_full_text_search_ops_v2` operator classes. [`@@` operator](../reference/operators/query.html) is deprecated.

### 修正

  * [[CentOS](../install/centos.html)] Fixed wrong msgpack library link.

## 1.1.9: 2016-11-30 {#version-1-1-9}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 6.1.1.

  * Reduced memory usage on static index construction. You can use index construction by executing `CREATE INDEX` after inserting data to table.

  * Supported logging backtrace on SEGV. It doesn't work on Windows.

  * Supported Zstandard. If Groonga supports Zstandard, PGroonga uses Zstandard. If Groonga doesn't support Zstandard but supports LZ4, PGroonga uses LZ4. If Groonga doesn't support Zstandard nor LZ4 but supports zlib, PGroonga uses zlib.

  * Added PID to log.

  * Made the following functions optimizable for constant arguments case:

    * [`pgroonga.table_name` function](../reference/functions/pgroonga-table-name.html)

    * [`pgroonga.snippet_html` function](../reference/functions/pgroonga-snippet-html.html)

    * [`pgroonga.highlight_html` function](../reference/functions/pgroonga-highlight-html.html)

    * [`pgroonga.match_positions_byte` function][match-positions-byte]

    * [`pgroonga.match_positions_character` function][match-positions-character]

    * [`pgroonga.query_extract_keywords` function](../reference/functions/pgroonga-query-extract-keywords.html)

  * [[`pgroonga.escape` function](../reference/functions/pgroonga-escape.html)] Added a new function to escape script syntax value.

  * [[`pgroonga.query_escape` function](../reference/functions/pgroonga-query-escape.html)] Added a new function to escape query syntax value.

  * [[`pgroonga.command_escape_escape` function](../reference/functions/pgroonga-query-escape.html)] Added a new function to escape Groonga command argument value.

  * [[`pgroonga.table_name` function](../reference/functions/pgroonga-table-name.html)] Changed return type to `text` from `cstring`.

  * [[`pgroonga.command` function](../reference/functions/pgroonga-command.html)] Added arguments array style. The style is recommended for preventing Groonga command injection.

  * [[`pgroonga.query_log_path` parameter](../reference/parameters/query-log-path.html)] Added a new parameter to control path of query log.

### 修正

  * [[`pgroonga_tuple_is_alive` Groonga function](../reference/groonga-functions/pgroonga-tuple-is-alive.html)] Fixed a bug that it may always return `false`.

## 1.1.8: 2016-11-09 {#version-1-1-8}

### 改良

  * Added startup log with PGroonga version.

  * Supported index only scan availability check for 8KiB over column (TOAST-ed column).

  * Changed to use zlib compression as fallback for text column when LZ4 isn't available.

  * [[CentOS](../install/centos.html) 7] Supported WAL. It requires EPEL.

  * [[`pgroonga_tuple_is_alive` Groonga function](../reference/groonga-functions/pgroonga-tuple-is-alive.html)] Added a new Groonga function to remove invalid tuples. It can be used with [`pgroonga.command` function](../reference/functions/pgroonga-command.html).

## 1.1.7: 2016-11-03 {#version-1-1-7}

### 修正

  * Fixed build error with PostgreSQL 9.4 or earlier.

  * [[Ubuntu](../install/ubuntu.html)] Supported Yakkety Yak (16.10).

## 1.1.6: 2016-11-03 {#version-1-1-6}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 6.1.0.

  * [experimental][WAL] Supported WAL. WAL support requires PostgreSQL 9.6 or later and [MessagePack](http://msgpack.org/). WAL support means that you can use PostgreSQL's [stream replication feature]({{ site.postgresql_doc_base_url.en }}/warm-standby.html) but doesn't mean that PGroonga is crash safe. If PostgreSQL crashes while updating PGroonga data, PGroonga data may be broken. See also [replication](../reference/replication.html) and [`pgroonga.enable_wal` parameter](../reference/parameters/enable-wal.html).

  * Upgraded required Groonga version to 6.0.7 or later.

  * Supported [tablespace]({{ site.postgresql_doc_base_url.en }}/manage-ag-tablespaces.html).

  * Disabled index only scan automatically when there is one or more long records.

  * [[Ubuntu](../install.ubuntu.htmp)] Dropped Wily Werewolf (15.10) support.

### 修正

  * Fixed a bug that living PGroonga indexes are removed on `VACUUM` when PGroonga index is created at non default tablespace. [GitHub#27][Reported by pavelpopovgmail]

### 感謝

  * pavelpopovgmail

## 1.1.5: 2016-10-22 {#version-1-1-5}

### 改良

  * [[Windows][windows]] Provided PostgreSQL 9.5 package again.

### 修正

  * [`&?>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`&@>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`pgroonga.score` function](../reference/functions/pgroonga-score.html) Fixed a memory leak. [groonga-dev,04154][Reported by Takahashi]

### 感謝

  * Takahashi

## 1.1.4: 2016-10-08 {#version-1-1-4}

### 改良

  * [[Windows][windows]] Upgraded target PostgreSQL to 9.6.0.

  * [[CentOS](../install/centos.html)] Supported PostgreSQL 9.6.0.

### 修正

  * Fixed a bug that living records may be removed from index unexpectedly when you `UPDATE` or `DELETE` one or more records. [GitHub#23][Reported by yongxianggao-chanjet]

### 感謝

  * yongxianggao-chanjet

## 1.1.3: 2016-09-29 {#version-1-1-3}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.9.

  * Supported `Windows-1252` encoding.

### 修正

  * Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) function doesn't work against JSONB.

  * Fixed a bug that searching against JSONB may return wrong result.

  * [[Windows][windows]] Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) isn't found on `CREATE EXTENSION pgroonga`. [Gitter:groonga/ja?at=57e1f1cfc8af41d45f31d2b2][Reported by Truong Dinh Anh Duy]

  * [[Windows][windows]] Fixed a bug that `SELECT` may be crashed.

### 感謝

  * Truong Dinh Anh Duy

## 1.1.2: 2016-09-07 {#version-1-1-2}

### 改良

  * Supported `IN` by integer. [GitHub#21][Reported by yongxianggao-chanjet]

### 修正

  * Fixed a bug that PGroonga doesn't work with PostgreSQL 9.3. [GitHub#22][Reported by Tim Abbott]

### 感謝

  * yongxianggao-chanjet

  * Tim Abbott

## 1.1.1: 2016-08-31 {#version-1-1-1}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.8.

  * ヒット件数の見積に対応しました。これにより性能が向上します。

  * バンドルしているxxHashを0.6.2にアップデートしました。

  * Added [`pgroonga.match_positions_character`][match-positions-character] function that returns match positions in character.

  * メモリー上にバッファーされている変更を書き出す[`pgroonga.flush`](../reference/functions/pgroonga-flush.html)関数を追加しました。

### 修正

  * バックグラウンドワーカーが使われているときにクラッシュする問題を修正しました。[GitHub#17][svsoolさんが報告]

  * ビットマップヒープスキャン実行時に不必要なrecheckが走ることがある問題を修正しました。

### 感謝

  * svsoolさん

## 1.1.0: 2016-06-06 {#version-1-1-0}

### 改良

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.4.

## 1.0.9: 2016-06-02 {#version-1-0-9}

### 改良

  * Supported PostgreSQL 9.6beta1.

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix search against `text[]` by [`&^>`](../reference/operators/prefix-search-contain-v2.html).

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix RK search against `text[]` by [`&^~>`](../reference/operators/prefix-rk-search-contain-v2.html).

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.3.

## 1.0.8: 2016-05-21 {#version-1-0-8}

### 改良

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.3 from 9.5.2

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.2.

### 修正

  * Fixed a bug that [`pgroonga.match_positions_byte`][match-positions-byte] function returns wrong positions when text has 17 or more keywords. [Reported by 张建春]

### 感謝

  * 张建春

## 1.0.7: 2016-04-24 {#version-1-0-7}

### 改良

  * [Ubuntu] Supported Xenial Xerus (16.04 LTS).

  * Added [`pgroonga.highlight_html`](../reference/functions/pgroonga-highlight-html.html) function that highlight the specified keywords in the specified text.

  * Added [`pgroonga.match_positions_byte`][match-positions-byte] function that returns match positions of the specified keywords in the specified text. The unit of position is byte.

  * Added [`pgroonga.query_extract_keywords`](../reference/functions/pgroonga-query-extract-keywords.html) function that returns keywords from the specified query.

## 1.0.6: 2016-04-15 {#version-1-0-6}

### 改良

  * [[Windows][windows]] Added version information to DLL. [groonga-dev,03962] [Suggested by Naoki Takami]

  * [`pgroonga.text_full_text_search_ops_v2`] Supported similar search by [`&~?`][similar-search-v2].

  * [`pgroonga.text_term_search_ops_v2`] Supported prefix search by [`&^`][prefix-search-v2].

  * [`pgroonga.text_term_search_ops_v2`] Supported [prefix RK search](http://groonga.org/docs/reference/operations/prefix_rk_search.html) by [`&^~`][prefix-rk-search-v2].

  * [[Windows][windows]] Changed Visual Studio version to 2013 from 2015. Because PostgreSQL binary uses 2013.

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.2 from 9.5.1

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.1.

### 感謝

  * Naoki Takami

## 1.0.5: 2016-03-01 {#version-1-0-5}

### 修正

  * Added missing update SQL files.

## 1.0.4: 2016-03-01 {#version-1-0-4}

### 修正

  * [[Windows][windows]] Added a missing symbol export.

## 1.0.3: 2016-02-29 {#version-1-0-3}

### 改良

  * Supported multibyte column name in UTF-8.

  * [`pgroonga.text_full_text_search_ops_v2`] Added `` &` `` operator that accepts [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html) as condition.

  * [[Windows][windows]] Enabled LZ4.

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.1 from 9.5.0.

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.0 from 5.1.2.

### 修正

  * Added missing update SQL. [groonga-dev,03950] [Reported by Naoki Takami]

### 感謝

  * Naoki Takami

## 1.0.2: 2016-02-09 {#version-1-0-2}

### 改良

  * Required Groonga 5.1.2 or later.

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.0 from 9.4.5.

  * [[Windows][windows]] Upgraded bundled Groonga to 5.1.2.

  * [[Windows][windows]] Enabled mruby.

  * [RPM] Supported PostgreSQL 9.5.

  * [`jsonb`] Supported sequential scan.

  * Added `pgroonga.text_full_text_search_ops_v2` operator class. It's an experimental operator class. It may break backward compatibility but includes new features.

    Here are supported operators:

    * `LIKE`

    * `ILIKE`

    * `&@`: It's equal to `%%` in `pgroonga.text_full_text_search`.

    * `&?`: It's equal to `@@` in `pgroonga.text_full_text_search`.

    * `&@>`: It returns true when one of the right hand side texts returns true by `&@`.

    * `&?>`: It returns true when one of the right hand side texts returns true by `&?`.

  * Support composite primary key.

### 修正

  * Fixed a bug that valid tables and columns are removed by `VACUUM` or `ANALYZE`. It's caused after you use `REINDEX`. [groonga-dev,03850] [Reported by Naoki Takami]

### 感謝

  * Naoki Takami

## 1.0.1: 2015-12-29 {#version-1-0-1}

### 改良

  * Accepted `none` as none value for tokenizer and normalizer. [groonga-dev,03664] [Reported by Naoki Takami]

  * Supported `CREATE DATABASE TABLESPACE`. [Suggested by Hiroyuki Sato]

### 修正

  * Fixed a bug that sequential scan doesn't work for regular expression search.  [Reported by Hiroyuki Sato]

### 感謝

  * Naoki Takami

  * Hiroyuki Sato

## 1.0.0: 2015-10-29 {#version-1-0-0}

It's the first major release!!!

You need to run `DROP EXTENSION pgroonga CASCADE`, upgrade PGroonga binary, run `CREATE EXTENSION pgroonga` and create indexes again to upgrade to 1.0.0 from older versions.

### 改良

  * Propagated double initialization on failing to open database. [groonga-dev,03528] [Reported by Naoki Takami]

  * Supported index only scan.

  * Supported regular expression search by `@~`. [groonga-dev,03563] [Reported by Hiroaki Tachikawa]

  * [[Windows][windows]] Bundled MeCab.

  * Made `LIKE` with index outputs `LIKE` with sequential scan compatible outputs. It's implemented by using recheck feature provided by PostgreSQL. It means that `LIKE` is slower than `%%` operator and `@@` operator.

  * Supported `ILIKE` with index.

### 感謝

  * Naoki Takami

  * Hiroaki Tachikawa

## 0.9.0: 2015-09-29 {#version-0-9-0}

You can update to 0.9.0 from 0.8.0 by override install and executing the following SQL:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

You don't need to re-create `pgroonga` indexes.

### 改良

  * Supported `jsonb`. You can use `@>` operator like GIN index for `jsonb`. `@>` operator works like GIN index for `jsonb`. It's compatible. You can also use `@@` operator. It's PGroonga original operator. It's more flexible.

## 0.8.0: 2015-09-01

You can update to 0.8.0 from 0.7.0 by override install. You don't need to re-create `pgroonga` indexes.

### 改良

  * Reduced needless loop on `VACUUM`.
  * Reduced temporary memory usage.
  * `pgroonga.log_path`: Added a variable that changes path for Groonga log.
  * incompatible: Changed the path for Groonga log to the database directory by default. You can change it by `pgroonga.log_path`.
  * `pgroonga.log_type`: Added a variable that changes how to log.
  * Supported `TRUNCATE`-ed table. [GitHub:#1] [Reported by Hiroki Nakamura]
  * `pgroonga.snippet_html()`: Added a function that generates snippet HTML. [groonga-dev,03398] [Reported by Hiroki Nakamura]
  * Supported Ubuntu 14.04 LTS (Trusty Tahr). [Suggested by Yokoda Toshiaki]
  * `pgroonga.lock_timeout`: Added a variable that changes the number of lock retries. [groonga-dev,03419] [Suggested by Naoki Takami]

### 感謝

  * Hiroki Nakamura
  * Yokoda Toshiaki
  * Naoki Takami

## 0.7.0: 2015-07-10

You can update to 0.6.0 from 0.5.0 by override install. You don't need to re-create `pgroonga` indexes.

### 改良

  * incompatible: Changed to use Groonga's default logger. Messages for PGroonga is logged to `pgroonga.log` in database directory instead of PostgreSQL's log path.
  * `pgroonga.log_level`: Added a variable that changes log level.

### 修正

  * Fixed a bug that lexicon tables for dropped indexes aren't removed on `VACUUM`.

## 0.6.0: 2015-05-29

You can update to 0.6.0 from 0.5.0 by override install. You don't need to re-create `pgroonga` indexes.

### 改良

  * `pgroonga.score()`: Supported HOT update on PostgreSQL 9.3.
  * Supported log messages from Groonga.
  * Stopped to try opening Groonga database when Groonga database path doesn't exist.
  * Supported Debian GNU/Linux Jessie.

### 修正

  * Fixed a bug that large block number in ctid is overflowed.

## 0.5.0: 2015-04-29

You can't upgrade to 0.5.0 from 0.4.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### 改良

  * `pgroonga.score()`: Supported HOT update.
  * Supported Ubuntu 15.04 Vivid Vervet.
  * Supported Windows.

### 変更

  * `pgroonga.score()`: Required primary key.

## 0.4.0: 2015-03-29

You can't upgrade to 0.4.0 from 0.3.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### 改良

  * Supported `column LIKE '%keyword'` as a short cut of `column @@ 'keyword'`.
  * Supported range search with multi-column index.
  * Added PGroonga setup script on Travis CI. Add the following line to `install` section in your `.travis.yml`:

        curl --silent --location https://github.com/pgroonga/pgroonga/raw/master/data/travis/setup.sh | sh

  * Added `pgroonga.table_name()` that returns table name in Groonga.
  * Added `pgroonga.command()` that executes Groonga command line.
  * Added `pgroonga.score()` that returns search score in Groonga.
  * Supported `timestamp` type.
  * Supported `timestamp with time zone` type.
  * Supported `varchar[]` type.
  * Supported full-text search for `text[]` type.
  * Supported full-text search by index and other search by index in one `SELECT`.
  * Added Yum repositories for CentOS 5 and 6.

### 変更

  * Dropped `text == text` search by index. Use 4096 bytes or smaller `varchar` instead.
  * Dropped PostgreSQL 9.2 support.

## 0.3.0: 2015-02-09

You can't upgrade to 0.3.0 from 0.2.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### 改良

  * Supported encoding
  * Supported customizing tokenizer and normalizer by `WITH` such as:

    ```sql
    CREATE INDEX pgroonga_index
              ON table
           USING pgroonga (column)
            WITH (tokenizer='TokenMecab',
                  normalizer='NormalizerAuto');
    ```

  * Reduced needless locks.
  * Supported column compression by LZ4.
  * Supported non full-text search index such as text, numbers and timestamp.

### 変更

  * Changed database file base name to `pgrn` from `grn`.

## 0.2.0: 2015-01-29

The first release!!!

[centos]:../install/centos.html
[debian]:../install/debian.html
[ubuntu]:../install/ubuntu.html
[windows]:../install/windows.html

[create-index-using-pgroonga]:../reference/create-index-using-pgroonga.html

[text-regexp-ops]:../reference/#text-regexp-ops
[text-array-full-text-search-ops]:../reference/#text-array-full-text-search-ops
[varchar-full-text-search-ops]:../reference/#varchar-full-text-search-ops
[varchar-regexp-ops]:../reference/#varchar-regexp-ops
[varchar-array-ops]:../reference/#varchar-array-ops
[jsonb-ops]:../reference/#jsonb-ops

[text-full-text-search-ops-v2]:../reference/#text-full-text-search-ops-v2
[text-term-search-ops-v2]:../reference/#text-term-search-ops-v2
[text-regexp-ops-v2]:../reference/#text-regexp-ops-v2
[text-array-full-text-search-ops-v2]:../reference/#text-array-full-text-search-ops-v2
[text-array-term-search-ops-v2]:../reference/#text-array-term-search-ops-v2
[varchar-full-text-search-ops-v2]:../reference/#varchar-full-text-search-ops-v2
[varchar-regexp-ops-v2]:../reference/#varchar-regexp-ops-v2
[varchar-array-term-search-ops-v2]:../reference/#varchar-array-term-search-ops-v2
[jsonb-ops-v2]:../reference/#jsonb-ops-v2
[jsonb-full-text-search-ops-v2]:../reference/#jsonb-full-text-search-ops-v2

[contain-array]:../reference/operators/contain-array.html
[match-v2]:../reference/operators/match-v2.html
[contain-term-v2]:../reference/operators/contain-term-v2.html
[query-v2]:../reference/operators/query-v2.html
[query-in-v2]:../reference/operators/query-in-v2.html
[script-v2]:../reference/operators/script-v2.html
[similar-search-v2]:../reference/operators/similar-search-v2.html
[prefix-search-v2]:../reference/operators/prefix-search-v2.html
[prefix-rk-search-v2]:../reference/operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:../reference/operators/prefix-search-in-v2.html
[prefix-rk-search-in-v2]:../reference/operators/prefix-rk-search-in-v2.html
[not-prefix-search-in-v2]:../reference/operators/not-prefix-search-in-v2.html
[match-jsonb-v2]:../reference/operators/match-jsonb-v2.html
[query-jsonb-v2]:../reference/operators/query-jsonb-v2.html
[script-jsonb-v2]:../reference/operators/script-jsonb-v2.html
[regular-expression-v2]:../reference/operators/regular-expression-v2.html
[regular-expression-in-v2]:../reference/operators/regular-expression-in-v2.html

[command]:../reference/functions/pgroonga-command.html
[database-remove]:../reference/functions/pgroonga-database-remove.html
[escape]:../reference/functions/pgroonga-escape.html
[highlight-html]:../reference/functions/pgroonga-highlight-html.html
[index-column-name]:../reference/functions/pgroonga-index-column-name.html
[is-writable]:../reference/functions/pgroonga-is-writable.html
[match-positions-byte]:../reference/functions/pgroonga-match-positions-byte.html
[match-positions-character]:../reference/functions/pgroonga-match-positions-character.html
[normalize]:../reference/functions/pgroonga-normalize.html
[query-expand]:../reference/functions/pgroonga-query-expand.html
[result-to-jsonb-objects]:../reference/functions/pgroonga-result-to-jsonb-objects.html
[result-to-recordset]:../reference/functions/pgroonga-result-to-recordset.html
[score]:../reference/functions/pgroonga-score.html
[set-writable]:../reference/functions/pgroonga-set-writable.html
[snippet-html]:../reference/functions/pgroonga-snippet-html.html
[tokenize]:../reference/functions/pgroonga-tokenize.html
[vacuum]:../reference/functions/pgroonga-vacuum.html
[wal-apply]:../reference/functions/pgroonga-wal-aplly.html
[wal-truncate]:../reference/functions/pgroonga-wal-truncate.html

[force-match-escalation]:../reference/parameters/force-match-escalation.html
[libgroonga-version]:../reference/parameters/libgroonga-version.html
[match-escalation-threshold]:../reference/parameters/match-escalation-threshold.html

[pgroonga-check]:../reference/modules/pgroonga-check.html
[pgroonga-database]:../reference/modules/pgroonga-database.html

[travis-ci]:../how-to/travis-ci.html
