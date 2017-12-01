---
title: News
---

# News

## 2.0.2: 2017-10-10 {#version-2-0-2}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.7.

  * [[Ubuntu][ubuntu]] Added Ubuntu 17.10 (Artful Aardvark) support.

  * Added `INTEGER_COLUMN = ANY(ARRAY[]::integer[])` support.
    [GitHub#53][Reported by tedypranolo]

  * [[`pgroonga_query_expand` function][query-expand]] Added `text`
    type for synonym column.

  * Improved index search estimation with `IMMUTABLE` or `STABLE`
    function call.

  * Added missing empty array check for the following functions:

    * [`pgroonga_snippet_html` function][snippet-html]

    * [`pgroonga_highlight_html` function][highlight-html]

    * [`pgroonga_command` function][command]

  * Added PostgreSQL 10 packages.

### Fixes

  * Fixed build error on Windows.

  * Fixed a bug that creating index may be removed by `VACUUM`
    including `AUTO VACUUM`.

### Thanks

  * tedypranolo

## 2.0.1: 2017-08-17 {#version-2-0-1}

### Fixes

  * Fixed upgrading failure on PostgreSQL 9.5 or earlier.

## 2.0.0: 2017-08-17 {#version-2-0-0}

This is the second major release! It's upgradable from 1.X! 2.X is backward compatible with 1.X!

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.5.

  * Added PostgreSQL 10 support.

  * Added logical replication support.

  * Changed to install functions, operators and operator classes to the current schema with `pgroonga_` prefix from `pgroonga` schema without `pgroonga_` prefix. `pgroonga` schema is still used for backward compatibility. But `pgroonga` schema is deprecated.

  * Changed to the default operator classes to `_v2` operator classes.

### Fixes

  * Fixed a crash bug when primary key column isn't the first indexed column.
    [GitHub#50][Reported by tedypranolo]

  * Fixed upgrade failure from 1.2.0 on PostgreSQL 9.6 or later.

### Thanks

  * tedypranolo

## 1.2.3: 2017-07-03 {#version-1-2-3}

### Fixes

  * [[Ubuntu][ubuntu]] Fixed invalid package.

  * [[Debian][debian]] Supported Debian GNU/Linux Stretch.

## 1.2.2: 2017-07-03 {#version-1-2-2}

### Improvements

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

### Thanks

  * Hirokazu Matsuo

  * YUKI "Piro" Hiroshi

## 1.2.1: 2017-06-08 {#version-1-2-1}

### Improvements

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

### Fixes

  * Fixed a bug that removed entries may be referenced. [GitHub#36][Reported by peter-schmitz]

### Thanks

  * peter-schmitz

  * ArturFormella

## 1.2.0: 2017-04-29 {#version-1-2-0}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 7.0.2.

  * [[CentOS](../install/centos.html) 6] Supported WAL.

  * Dropped [[CentOS](../install/centos.html) 5] support.

  * [[Ubuntu](../install/ubuntu.html) 17.04] Supported. It supports WAL.

  * [[Replication](../reference/replication.html)] Supported NULL column value.

  * [[`pgroonga.score` function](../reference/functions/pgroonga-score.html)] Improved performance. This improvements makes `pgroonga.score` function 30 times faster. [GitHub#31][Reported by yongxianggao-chanjet]

  * Supported PostgreSQL 9.6.2.

  * Required Groonga 6.1.1 or later.

  * [[`pgroonga_check`](../reference/modules/pgroonga-check.html)] Added. It checks PGroonga database consistency on startup. If PGroonga database is broken, it tries to recover the database.

  * Supported applying WAL on `INSERT`.

  * [[`CREATE INDEX USING pgroonga`](../reference/create-index-using-pgroonga.html)] Supported token filters. [GitHub#32][Reported by Tim Bellefleur]

  * [[Windows][windows]] Supported PostgreSQL 9.5.6.

  * [[Windows][windows]] Supported PostgreSQL 9.6.2.

  * Added [`&@` operator](../reference/operators/match-v2.html) to `pgroonga.text_full_text_search_ops` (the current default operator class for `text` type). It means that you can use `&@` operator both with `pgroonga.text_full_text_search_ops` and `pgroonga.text_full_text_search_ops_v2` operator classes. [`%%` operator](../reference/operators/match.html) is deprecated.

  * Added [`&?` operator](../reference/operators/query-v2.html) to `pgroonga.text_full_text_search_ops` (the current default operator class for `text` type). It means that you can use `&?` operator both with `pgroonga.text_full_text_search_ops` and `pgroonga.text_full_text_search_ops_v2` operator classes. [`@@` operator](../reference/operators/query.html) is deprecated.

### Fixes

  * [[CentOS](../install/centos.html)] Fixed wrong msgpack library link.

## 1.1.9: 2016-11-30 {#version-1-1-9}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 6.1.1.

  * Reduced memory usage on static index construction. You can use index construction by executing `CREATE INDEX` after inserting data to table.

  * Supported logging backtrace on SEGV. It doesn't work on Windows.

  * Supported Zstandard. If Groonga supports Zstandard, PGroonga uses Zstandard. If Groonga doesn't support Zstandard but supports LZ4, PGroonga uses LZ4. If Groonga doesn't support Zstandard nor LZ4 but supports zlib, PGroonga uses zlib.

  * Added PID to log.

  * Made the following functions optimizable for constant arguments case:

    * [`pgroonga.table_name` function](../reference/functions/pgroonga-table-name.html)

    * [`pgroonga.snippet_html` function](../reference/functions/pgroonga-snippet-html.html)

    * [`pgroonga.highlight_html` function](../reference/functions/pgroonga-highlight-html.html)

    * [`pgroonga.match_positions_byte` function](../reference/functions/pgroonga-match-positions-byte.html)

    * [`pgroonga.match_positions_character` function](../reference/functions/pgroonga-match-positions-character.html)

    * [`pgroonga.query_extract_keywords` function](../reference/functions/pgroonga-query-extract-keywords.html)

  * [[`pgroonga.escape` function](../reference/functions/pgroonga-escape.html)] Added a new function to escape script syntax value.

  * [[`pgroonga.query_escape` function](../reference/functions/pgroonga-query-escape.html)] Added a new function to escape query syntax value.

  * [[`pgroonga.command_escape_escape` function](../reference/functions/pgroonga-query-escape.html)] Added a new function to escape Groonga command argument value.

  * [[`pgroonga.table_name` function](../reference/functions/pgroonga-table-name.html)] Changed return type to `text` from `cstring`.

  * [[`pgroonga.command` function](../reference/functions/pgroonga-command.html)] Added arguments array style. The style is recommended for preventing Groonga command injection.

  * [[`pgroonga.query_log_path` parameter](../reference/parameters/query-log-path.html)] Added a new parameter to control path of query log.

### Fixes

  * [[`pgroonga_tuple_is_alive` Groonga function](../reference/groonga-functions/pgroonga-tuple-is-alive.html)] Fixed a bug that it may always return `false`.

## 1.1.8: 2016-11-09 {#version-1-1-8}

### Improvements

  * Added startup log with PGroonga version.

  * Supported index only scan availability check for 8KiB over column (TOAST-ed column).

  * Changed to use zlib compression as fallback for text column when LZ4 isn't available.

  * [[CentOS](../install/centos.html) 7] Supported WAL. It requires EPEL.

  * [[`pgroonga_tuple_is_alive` Groonga function](../reference/groonga-functions/pgroonga-tuple-is-alive.html)] Added a new Groonga function to remove invalid tuples. It can be used with [`pgroonga.command` function](../reference/functions/pgroonga-command.html).

## 1.1.7: 2016-11-03 {#version-1-1-7}

### Fixes

  * Fixed build error with PostgreSQL 9.4 or earlier.

  * [[Ubuntu](../install/ubuntu.html)] Supported Yakkety Yak (16.10).

## 1.1.6: 2016-11-03 {#version-1-1-6}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 6.1.0.

  * [experimental][WAL] Supported WAL. WAL support requires PostgreSQL 9.6 or later and [MessagePack](http://msgpack.org/). WAL support means that you can use PostgreSQL's [stream replication feature]({{ site.postgresql_doc_base_url.en }}/warm-standby.html) but doesn't mean that PGroonga is crash safe. If PostgreSQL crashes while updating PGroonga data, PGroonga data may be broken. See also [replication](../reference/replication.html) and [`pgroonga.enable_wal` parameter](../reference/parameters/enable-wal.html).

  * Upgraded required Groonga version to 6.0.7 or later.

  * Supported [tablespace]({{ site.postgresql_doc_base_url.en }}/manage-ag-tablespaces.html).

  * Disabled index only scan automatically when there is one or more long records.

  * [[Ubuntu](../install.ubuntu.htmp)] Dropped Wily Werewolf (15.10) support.

### Fixes

  * Fixed a bug that living PGroonga indexes are removed on `VACUUM` when PGroonga index is created at non default tablespace. [GitHub#27][Reported by pavelpopovgmail]

### Thanks

  * pavelpopovgmail

## 1.1.5: 2016-10-22 {#version-1-1-5}

### Improvements

  * [[Windows][windows]] Provided PostgreSQL 9.5 package again.

### Fixes

  * [`&?>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`&@>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`pgroonga.score` function](../reference/functions/pgroonga-score.html) Fixed a memory leak. [groonga-dev,04154][Reported by Takahashi]

### Thanks

  * Takahashi

## 1.1.4: 2016-10-08 {#version-1-1-4}

### Improvements

  * [[Windows][windows]] Upgraded target PostgreSQL to 9.6.0.

  * [[CentOS](../install/centos.html)] Supported PostgreSQL 9.6.0.

### Fixes

  * Fixed a bug that living records may be removed from index unexpectedly when you `UPDATE` or `DELETE` one or more records. [GitHub#23][Reported by yongxianggao-chanjet]

### Thanks

  * yongxianggao-chanjet

## 1.1.3: 2016-09-29 {#version-1-1-3}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.9.

  * Supported `Windows-1252` encoding.

### Fixes

  * Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) function doesn't work against JSONB.

  * Fixed a bug that searching against JSONB may return wrong result.

  * [[Windows][windows]] Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) isn't found on `CREATE EXTENSION pgroonga`. [Gitter:groonga/ja?at=57e1f1cfc8af41d45f31d2b2][Reported by Truong Dinh Anh Duy]

  * [[Windows][windows]] Fixed a bug that `SELECT` may be crashed.

### Thanks

  * Truong Dinh Anh Duy

## 1.1.2: 2016-09-07 {#version-1-1-2}

### Improvements

  * Supported `IN` by integer. [GitHub#21][Reported by yongxianggao-chanjet]

### Fixes

  * Fixed a bug that PGroonga doesn't work with PostgreSQL 9.3. [GitHub#22][Reported by Tim Abbott]

### Thanks

  * yongxianggao-chanjet

  * Tim Abbott

## 1.1.1: 2016-08-31 {#version-1-1-1}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.8.

  * Supported estimation. It improves performance.

  * Updated bundled xxHash to 0.6.2.

  * Added [`pgroonga.match_positions_character`](../reference/functions/pgroonga-match-positions-character.html) function that returns match positions in character.

  * Added [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) function that flushes buffered changes in memory.

### Fixes

  * Fixed a crash bug when background worker is used. [GitHub#17][Reported by svsool]

  * Fixed a bug that needless recheck is ran on bitmap heap scan.

### Thanks

  * svsool

## 1.1.0: 2016-06-06 {#version-1-1-0}

### Improvements

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.4.

## 1.0.9: 2016-06-02 {#version-1-0-9}

### Improvements

  * Supported PostgreSQL 9.6beta1.

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix search against `text[]` by [`&^>`](../reference/operators/prefix-search-contain-v2.html).

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix RK search against `text[]` by [`&^~>`](../reference/operators/prefix-rk-search-contain-v2.html).

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.3.

## 1.0.8: 2016-05-21 {#version-1-0-8}

### Improvements

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.3 from 9.5.2

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.2.

### Fixes

  * Fixed a bug that [`pgroonga.match_positions_byte`](../reference/functions/pgroonga-match-positions-byte.html) function returns wrong positions when text has 17 or more keywords. [Reported by 张建春]

### Thanks

  * 张建春

## 1.0.7: 2016-04-24 {#version-1-0-7}

### Improvements

  * [Ubuntu] Supported Xenial Xerus (16.04 LTS).

  * Added [`pgroonga.highlight_html`](../reference/functions/pgroonga-highlight-html.html) function that highlight the specified keywords in the specified text.

  * Added [`pgroonga.match_positions_byte`](../reference/functions/pgroonga-match-positions-byte.html) function that returns match positions of the specified keywords in the specified text. The unit of position is byte.

  * Added [`pgroonga.query_extract_keywords`](../reference/functions/pgroonga-query-extract-keywords.html) function that returns keywords from the specified query.

## 1.0.6: 2016-04-15 {#version-1-0-6}

### Improvements

  * [[Windows][windows]] Added version information to DLL. [groonga-dev,03962] [Suggested by Naoki Takami]

  * [`pgroonga.text_full_text_search_ops_v2`] Supported similar search by [`&~?`][similar-search-v2].

  * [`pgroonga.text_term_search_ops_v2`] Supported prefix search by [`&^`][prefix-search-v2].

  * [`pgroonga.text_term_search_ops_v2`] Supported [prefix RK search](http://groonga.org/docs/reference/operations/prefix_rk_search.html) by [`&^~`][prefix-rk-search-v2].

  * [[Windows][windows]] Changed Visual Studio version to 2013 from 2015. Because PostgreSQL binary uses 2013.

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.2 from 9.5.1

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.1.

### Thanks

  * Naoki Takami

## 1.0.5: 2016-03-01 {#version-1-0-5}

### Fixes

  * Added missing update SQL files.

## 1.0.4: 2016-03-01 {#version-1-0-4}

### Fixes

  * [[Windows][windows]] Added a missing symbol export.

## 1.0.3: 2016-02-29 {#version-1-0-3}

### Improvements

  * Supported multibyte column name in UTF-8.

  * [`pgroonga.text_full_text_search_ops_v2`] Added `` &` `` operator that accepts [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html) as condition.

  * [[Windows][windows]] Enabled LZ4.

  * [[Windows][windows]] Upgraded base PostgreSQL to 9.5.1 from 9.5.0.

  * [[Windows][windows]] Upgraded bundled Groonga to 6.0.0 from 5.1.2.

### Fixes

  * Added missing update SQL. [groonga-dev,03950] [Reported by Naoki Takami]

### Thanks

  * Naoki Takami

## 1.0.2: 2016-02-09 {#version-1-0-2}

### Improvements

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

### Fixes

  * Fixed a bug that valid tables and columns are removed by `VACUUM` or `ANALYZE`. It's caused after you use `REINDEX`. [groonga-dev,03850] [Reported by Naoki Takami]

### Thanks

  * Naoki Takami

## 1.0.1: 2015-12-29 {#version-1-0-1}

### Improvements

  * Accepted `none` as none value for tokenizer and normalizer. [groonga-dev,03664] [Reported by Naoki Takami]

  * Supported `CREATE DATABASE TABLESPACE`. [Suggested by Hiroyuki Sato]

### Fixes

  * Fixed a bug that sequential scan doesn't work for regular expression search.  [Reported by Hiroyuki Sato]

### Thanks

  * Naoki Takami

  * Hiroyuki Sato

## 1.0.0: 2015-10-29 {#version-1-0-0}

It's the first major release!!!

You need to run `DROP EXTENSION pgroonga CASCADE`, upgrade PGroonga binary, run `CREATE EXTENSION pgroonga` and create indexes again to upgrade to 1.0.0 from older versions.

### Improvements

  * Propagated double initialization on failing to open database. [groonga-dev,03528] [Reported by Naoki Takami]

  * Supported index only scan.

  * Supported regular expression search by `@~`. [groonga-dev,03563] [Reported by Hiroaki Tachikawa]

  * [[Windows][windows]] Bundled MeCab.

  * Made `LIKE` with index outputs `LIKE` with sequential scan compatible outputs. It's implemented by using recheck feature provided by PostgreSQL. It means that `LIKE` is slower than `%%` operator and `@@` operator.

  * Supported `ILIKE` with index.

### Thanks

  * Naoki Takami

  * Hiroaki Tachikawa

## 0.9.0: 2015-09-29 {#version-0-9-0}

You can update to 0.9.0 from 0.8.0 by override install and executing the following SQL:

```sql
ALTER EXTENSION pgroonga UPDATE;
```

You don't need to re-create `pgroonga` indexes.

### Improvements

  * Supported `jsonb`. You can use `@>` operator like GIN index for `jsonb`. `@>` operator works like GIN index for `jsonb`. It's compatible. You can also use `@@` operator. It's PGroonga original operator. It's more flexible.

## 0.8.0: 2015-09-01

You can update to 0.8.0 from 0.7.0 by override install. You don't need to re-create `pgroonga` indexes.

### Improvements

  * Reduced needless loop on `VACUUM`.
  * Reduced temporary memory usage.
  * `pgroonga.log_path`: Added a variable that changes path for Groonga log.
  * incompatible: Changed the path for Groonga log to the database directory by default. You can change it by `pgroonga.log_path`.
  * `pgroonga.log_type`: Added a variable that changes how to log.
  * Supported `TRUNCATE`-ed table. [GitHub:#1] [Reported by Hiroki Nakamura]
  * `pgroonga.snippet_html()`: Added a function that generates snippet HTML. [groonga-dev,03398] [Reported by Hiroki Nakamura]
  * Supported Ubuntu 14.04 LTS (Trusty Tahr). [Suggested by Yokoda Toshiaki]
  * `pgroonga.lock_timeout`: Added a variable that changes the number of lock retries. [groonga-dev,03419] [Suggested by Naoki Takami]

### Thanks

  * Hiroki Nakamura
  * Yokoda Toshiaki
  * Naoki Takami

## 0.7.0: 2015-07-10

You can update to 0.6.0 from 0.5.0 by override install. You don't need to re-create `pgroonga` indexes.

### Improvements

  * incompatible: Changed to use Groonga's default logger. Messages for PGroonga is logged to `pgroonga.log` in database directory instead of PostgreSQL's log path.
  * `pgroonga.log_level`: Added a variable that changes log level.

### Fixes

  * Fixed a bug that lexicon tables for dropped indexes aren't removed on `VACUUM`.

## 0.6.0: 2015-05-29

You can update to 0.6.0 from 0.5.0 by override install. You don't need to re-create `pgroonga` indexes.

### Improvements

  * `pgroonga.score()`: Supported HOT update on PostgreSQL 9.3.
  * Supported log messages from Groonga.
  * Stopped to try opening Groonga database when Groonga database path doesn't exist.
  * Supported Debian GNU/Linux Jessie.

### Fixes

  * Fixed a bug that large block number in ctid is overflowed.

## 0.5.0: 2015-04-29

You can't upgrade to 0.5.0 from 0.4.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### Improvements

  * `pgroonga.score()`: Supported HOT update.
  * Supported Ubuntu 15.04 Vivid Vervet.
  * Supported Windows.

### Changes

  * `pgroonga.score()`: Required primary key.

## 0.4.0: 2015-03-29

You can't upgrade to 0.4.0 from 0.3.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### Improvements

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

### Changes

  * Dropped `text == text` search by index. Use 4096 bytes or smaller `varchar` instead.
  * Dropped PostgreSQL 9.2 support.

## 0.3.0: 2015-02-09

You can't upgrade to 0.3.0 from 0.2.0 without re-creating `pgroonga` index. You need to re-install PGroonga:

```sql
DROP EXTENSION pgroonga CASCADE;
CREATE EXTENSION pgroonga;
-- Create your pgroonga indexes again.
```

### Improvements

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

### Changes

  * Changed database file base name to `pgrn` from `grn`.

## 0.2.0: 2015-01-29

The first release!!!

[debian]:../install/debian.html
[ubuntu]:../install/ubuntu.html
[windows]:../install/windows.html

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

[match-v2]:../reference/operators/match-v2.html
[contain-term-v2]:../reference/operators/contain-term-v2.html
[query-v2]:../reference/operators/query-v2.html
[query-in-v2]:../reference/operators/query-in-v2.html
[similar-search-v2]:../reference/operators/similar-search-v2.html
[prefix-search-v2]:../reference/operators/prefix-search-v2.html
[prefix-rk-search-v2]:../reference/operators/prefix-rk-search-v2.html
[prefix-search-in-v2]:../reference/operators/prefix-search-in-v2.html
[prefix-rk-search-in-v2]:../reference/operators/prefix-rk-search-in-v2.html
[match-jsonb-v2]:../reference/operators/match-jsonb-v2.html
[query-jsonb-v2]:../reference/operators/query-jsonb-v2.html
[script-jsonb-v2]:../reference/operators/script-jsonb-v2.html
[regular-expression-v2]:../reference/operators/regular-expression-v2.html

[query-expand]:../reference/functions/pgroonga-query-expand.html
[snippet-html]:../reference/functions/pgroonga-snippet-html.html
[highlight-html]:../reference/functions/pgroonga-highlight-html.html
[command]:../reference/functions/pgroonga-command.html

[match-escalation-threshold]:../reference/parameters/match-escalation-threshold.html
