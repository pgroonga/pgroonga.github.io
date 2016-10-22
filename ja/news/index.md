---
title: おしらせ
---

# おしらせ

## 1.1.5: 2016-10-22 {#version-1-1-5}

### 改良

  * [[Windows](../install/windows.html)] Provided PostgreSQL 9.5 package again.

### 修正

  * [`&?>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`&@>` operator](../reference/operators/query-contain-v2.html) Fixed a bug that it may return `true` even if it's not matched.

  * [`pgroonga.score` function](../reference/functions/pgroonga-score.html) Fixed a memory leak. [groonga-dev,04154][Reported by Takahashi]

### 感謝

  * Takahashi

## 1.1.4: 2016-10-08 {#version-1-1-4}

### 改良

  * [[Windows](../install/windows.html)] Upgraded target PostgreSQL to 9.6.0.

  * [[CentOS](../install/centos.html)] Supported PostgreSQL 9.6.0.

### 修正

  * Fixed a bug that living records may be removed from index unexpectedly when you `UPDATE` or `DELETE` one or more records. [GitHub#23][Reported by yongxianggao-chanjet]

### 感謝

  * yongxianggao-chanjet

## 1.1.3: 2016-09-29 {#version-1-1-3}

### 改良

  * [[Windows](../install/windows.html)] Upgraded bundled Groonga to 6.0.9.

  * Supported `Windows-1252` encoding.

### 修正

  * Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) function doesn't work against JSONB.

  * Fixed a bug that searching against JSONB may return wrong result.

  * [[Windows](../install/windows.html)] Fixed a bug that [`pgroonga.flush`](../reference/functions/pgroonga-flush.html) isn't found on `CREATE EXTENSION pgroonga`. [Gitter:groonga/ja?at=57e1f1cfc8af41d45f31d2b2][Reported by Truong Dinh Anh Duy]

  * [[Windows](../install/windows.html)] Fixed a but that `SELECT` may be crashed.

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

### 改良

  * [[Windows](../install/windows.html)] Upgraded bundled Groonga to 6.0.8.

  * ヒット件数の見積に対応しました。これにより性能が向上します。

  * バンドルしているxxHashを0.6.2にアップデートしました。

  * 文字単位でのマッチした位置を返す[`pgroonga.match_positions_character`](../reference/functions/pgroonga-match-positions-character.html)関数を追加しました。

  * メモリー上にバッファーされている変更を書き出す[`pgroonga.flush`](../reference/functions/pgroonga-flush.html)関数を追加しました。

### 修正

  * バックグラウンドワーカーが使われているときにクラッシュする問題を修正しました。[GitHub#17][svsoolさんが報告]

  * ビットマップヒープスキャン実行時に不必要なrecheckが走ることがある問題を修正しました。

### 感謝

  * svsoolさん

## 1.1.0: 2016-06-06 {#version-1-1-0}

### 改良

  * [[Windows](../install/windows.html)] Upgraded bundled Groonga to 6.0.4.

## 1.0.9: 2016-06-02 {#version-1-0-9}

### 改良

  * Supported PostgreSQL 9.6beta1.

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix search against `text[]` by [`&^>`](../reference/operators/prefix-search-contain-v2.html).

  * [`pgroonga.text_array_term_search_ops_v2`] Supported prefix RK search against `text[]` by [`&^~>`](../reference/operators/prefix-rk-search-contain-v2.html).

  * [Windows] Upgraded bundled Groonga to 6.0.3.

## 1.0.8: 2016-05-21 {#version-1-0-8}

### 改良

  * [Windows] Upgraded base PostgreSQL to 9.5.3 from 9.5.2

  * [Windows] Upgraded bundled Groonga to 6.0.2.

### 修正

  * Fixed a bug that [`pgroonga.match_positions_byte`](../reference/functions/pgroonga-match-positions-byte.html) function returns wrong positions when text has 17 or more keywords. [Reported by 张建春]

### 感謝

  * 张建春

## 1.0.7: 2016-04-24 {#version-1-0-7}

### 改良

  * [Ubuntu] Supported Xenial Xerus (16.04 LTS).

  * Added [`pgroonga.highlight_html`](../reference/functions/pgroonga-highlight-html.html) function that highlight the specified keywords in the specified text.

  * Added [`pgroonga.match_positions_byte`](../reference/functions/pgroonga-match-positions-byte.html) function that returns match positions of the specified keywords in the specified text. The unit of position is byte.

  * Added [`pgroonga.query_extract_keywords`](../reference/functions/pgroonga-query-extract-keywords.html) function that returns keywords from the specified query.

## 1.0.6: 2016-04-15 {#version-1-0-6}

### 改良

  * [Windows] Added version information to DLL. [groonga-dev,03962] [Suggested by Naoki Takami]

  * [`pgroonga.text_full_text_search_ops_v2`] Supported similar search by [`&~?`](../reference/operators/similar-search-v2.html).

  * [`pgroonga.text_term_search_ops_v2`] Supported prefix search by [`&^`](../reference/operators/prefix-search-v2.html).

  * [`pgroonga.text_term_search_ops_v2`] Supported [prefix RK search](http://groonga.org/docs/reference/operations/prefix_rk_search.html) by [`&^~`](../reference/operators/prefix-rk-search-v2.html).

  * [Windows] Changed Visual Studio version to 2013 from 2015. Because PostgreSQL binary uses 2013.

  * [Windows] Upgraded base PostgreSQL to 9.5.2 from 9.5.1

  * [Windows] Upgraded bundled Groonga to 6.0.1.

### 感謝

  * Naoki Takami

## 1.0.5: 2016-03-01 {#version-1-0-5}

### 修正

  * Added missing update SQL files.

## 1.0.4: 2016-03-01 {#version-1-0-4}

### 修正

  * [Windows] Added a missing symbol export.

## 1.0.3: 2016-02-29 {#version-1-0-3}

### 改良

  * Supported multibyte column name in UTF-8.

  * [`pgroonga.text_full_text_search_ops_v2`] Added `` &` `` operator that accepts [script syntax](http://groonga.org/docs/reference/grn_expr/script_syntax.html) as condition.

  * [Windows] Enabled LZ4.

  * [Windows] Upgraded base PostgreSQL to 9.5.1 from 9.5.0.

  * [Windows] Upgraded bundled Groonga to 6.0.0 from 5.1.2.

### 修正

  * Added missing update SQL. [groonga-dev,03950] [Reported by Naoki Takami]

### 感謝

  * Naoki Takami

## 1.0.2: 2016-02-09 {#version-1-0-2}

### 改良

  * Required Groonga 5.1.2 or later.

  * [Windows] Upgraded base PostgreSQL to 9.5.0 from 9.4.5.

  * [Windows] Upgraded bundled Groonga to 5.1.2.

  * [Windows] Enabled mruby.

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

  * [Windows] Bundled MeCab.

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
