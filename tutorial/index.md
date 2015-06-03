---
title: Tutorial
layout: en
---

# Tutorial

This document describes how to use PGroonga step by step. If you don't install PGroonga yet, [install](../install/) PGroonga before you read this document.

You can use PGroonga as fast full text search index. You can also use PGroonga as more general index for equality condition (`=`) and comparison conditions (`<`, `>=` and so on).

PostgreSQL provides GiST and GIN as bundled indexes. You can use PGroonga as alternative of GiST and GIN. See [PGroonga versus GiST and GIN](../reference/pgroonga-versus-gist-and-gin.html) for differences of them.

This document describes about the followings:

  * How to use PGroonga as full text search index
  * How to use PGroonga as index for equality condition and comparison conditions
  * How to use PGroonga as index for array
  * How to use Groonga throw PGroonga (advanced topic)

## Full text search

This section describes about the followings:

  * How to prepare PGroonga based CJK ready full text search system
  * Operators for full text search
  * Score

### How to prepare PGroonga based CJK ready full text search system

This section describes about how to prepare PGroonga based CJK ready full text search full text search system.

Create a column that you want to enable full text search as `text` type:

```sql
CREATE TABLE memos (
  id integer,
  content text
);
```

`memos.content` column is a full text search target column.

Create a `pgroonga` index against the column:

```
CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

See [CREATE INDEX USING pgroonga](../reference/create-index-using-pgroonga.html) for more details.

Insert test data:

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

Disable sequential scan to ensure using `pgroonga` index:

```sql
SET enable_seqscan = off;
```

NOTE: You should not disable sequential scan on production environment. This is only for test.

### Operators for full text search

There are the following operators to perform full text search:

  * `%%`
  * `@@`
  * `LIKE`

#### `%%` operator

You can use `%%` operator to perform full text search by one word:

```sql
SELECT * FROM memos WHERE content %% '全文検索';

--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

See [%% operator](../reference/operators/match.html) for more details.

#### `@@` operator

You can use `@@` operator to perform full text search by query syntax such as `keyword1 OR keyword2`:

```sql
SELECT * FROM memos WHERE content @@ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 rows)
```

Query syntax is similar to syntax of Web search engine. For example, you can use `OR` to merge result sets of performing full text search by two or more words. In the above example, you get a merged result set. The merged result set has records that includes `PGroonga` or `PostgreSQL`.

See [Groonga document](http://groonga.org/docs/reference/grn_expr/query_syntax.html) for full query syntax.

See [@@ operator](../reference/operators/query.html) for more details.

#### `LIKE` operator

PGroonga supports `LIKE` operator. You can perform fast full text search by PGroonga without changing existing SQL.

`column LIKE '%keyword%'` equals to `column %% 'keyword'`:

```sql
SELECT * FROM memos WHERE content %% '全文検索';

--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

See [LIKE operator](../reference/operators/like.html) for more details.

### Score

You can use `pgroonga.score` function to get precision as a number. If a record is more precision against searched query, the record has more higher number.

You need to add primary key column into `pgroonga` index to use `pgroonga.score` function. If you don't add primary key column into `pgroonga` index, `pgroonga.score` function always returns `0`.

Here is a sample schema that includes primary key into indexed columns:

```sql
CREATE TABLE score_memos (
  id integer PRIMARY KEY,
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (id, content);
```

Insert test data:

```sql
INSERT INTO score_memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO score_memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO score_memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO score_memos VALUES (4, 'groongaコマンドがあります。');
```

Disable sequential scan to ensure using `pgroonga` index:

```sql
SET enable_seqscan = off;
```

Perform full text search and get score.

```sql
SELECT *, pgroonga.score(score_memos)
  FROM score_memos
 WHERE content %% 'PGroonga' OR content %% 'PostgreSQL';
--  id |                                  content                                  | score 
-- ----+---------------------------------------------------------------------------+-------
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。                |     1
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     2
-- (2 rows)
```

You can sort matched records by precision ascending by using `pgroonga.score` function in `ORDER BY` clause:

```sql
SELECT *, pgroonga.score(score_memos)
  FROM score_memos
 WHERE content %% 'PGroonga' OR content %% 'PostgreSQL'
 ORDER BY pgroonga.score(score_memos) DESC;
--  id |                                  content                                  | score 
-- ----+---------------------------------------------------------------------------+-------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。 |     2
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。                |     1
-- (2 rows)
```

See [pgroonga.score function](../reference/functions/pgroonga-score.html) for more details such as how to compute precision.

## Equality condition and comparison conditions

You can use PGroonga for equality condition and comparison conditions. There are some differences between how to create index for string types and other types. There is no difference between how to write condition for string types and other types.

This section describes about the followings:

  * How to use PGroonga for not string types
  * How to use PGroonga for string types

### How to use PGroonga for not string types

You can use PGroonga for not string types such as number. You can use equality condition and comparison conditions against these types.

Create index with `USING pgroonga`:

```sql
CREATE TABLE ids (
  id integer
);

CREATE INDEX pgroonga_id_index ON ids USING pgroonga (id);
```

The special SQL to use PGroonga is only `CREATE INDEX`. You can use SQL for B-tree index to use PGroonga.

Insert test data:

```sql
INSERT INTO ids VALUES (1);
INSERT INTO ids VALUES (2);
INSERT INTO ids VALUES (3);
```

Disable sequential scan:

```sql
SET enable_seqscan = off;
```

Search:

```sql
SELECT * FROM ids WHERE id <= 2;
--  id
-- ----
--   1
--   2
-- (2 rows)
```

### How to use PGroonga for string types

You need to use `varchar` type to use PGroonga as an index for equality condition and comparison conditions against string.

You must to specify the maximum number of characters of `varchar` to satisfy that the maximum byte size of the column is equal to 4096 byte or smaller. Relation between the maximum number of characters and the maximum byte size is related to encoding. For example, you must to specify 1023 or smaller as the maximum number of characters for UTF-8 encoding. Because UTF-8 encoding `varchar` keeps 4 byte for one character.

Create index with `USING pgroonga`:

```sql
CREATE TABLE tags (
  id integer,
  tag varchar(1023)
);

CREATE INDEX pgroonga_tag_index ON tags USING pgroonga (tag);
```

The special SQL to use PGroonga is only `CREATE INDEX`. You can use SQL for B-tree index to use PGroonga.

Insert test data:

```sql
INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'Groonga');
```

Disable sequential scan:

```sql
SET enable_seqscan = off;
```

Search:

```sql
SELECT * FROM tags WHERE tag = 'Groonga';
--  id |   tag
-- ----+---------
--   2 | Groonga
--   3 | Groonga
-- (2 rows)
--
```

## How to use PGroonga for array

You can use PGroonga as an index for array of `text` type or array of `varchar`.

You can perform full text search against array of `text` type. If one or more elements in an array are matched, the record is matched.

You can perform equality condition against array of `varchar` type. If one or more elements in an array are matched, the record is matched. It's useful for tag search.

  * How to use PGroonga for `text` type of array
  * How to use PGroonga for `varchar` type of array

### How to use PGroonga for `text` type of array

Create index with `USING pgroonga`:

```sql
CREATE TABLE docs (
  id integer,
  sections text[]
);

CREATE INDEX pgroonga_sections_index ON docs USING pgroonga (sections);
```

Insert test data:

```sql
INSERT INTO docs
     VALUES (1,
             ARRAY['PostgreSQLはリレーショナル・データベース管理システムです。',
                   'PostgreSQLは部分的に全文検索をサポートしています。']);
INSERT INTO docs
     VALUES (2,
             ARRAY['Groongaは日本語対応の高速な全文検索エンジンです。',
                   'Groongaは他のシステムに組み込むことができます。']);
INSERT INTO docs
     VALUES (3,
             ARRAY['PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。',
                   'PostgreSQLに高機能な全文検索機能を追加します。']);
```

You can use `%%` operator or `@@` operator for full text search. The full text search doesn't care about the position of element.

```sql
SELECT * FROM docs WHERE sections %% '全文検索';
--  id |                                                          sections                                                          
-- ----+----------------------------------------------------------------------------------------------------------------------------
--   1 | {PostgreSQLはリレーショナル・データベース管理システムです。,PostgreSQLは部分的に全文検索をサポートしています。}
--   2 | {Groongaは日本語対応の高速な全文検索エンジンです。,Groongaは他のシステムに組み込むことができます。}
--   3 | {PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。,PostgreSQLに高機能な全文検索機能を追加します。}
-- (3 rows)
```

### How to use PGroonga for `varchar` type of array

Create index with `USING pgroonga`:

```sql
CREATE TABLE products (
  id integer,
  name text,
  tags varchar(1023)[]
);

CREATE INDEX pgroonga_tags_index ON products USING pgroonga (tags);
```

Insert test data:

```sql
INSERT INTO products
     VALUES (1,
             'PostgreSQL',
             ARRAY['PostgreSQL', 'RDBMS']);
INSERT INTO products
     VALUES (2,
             'Groonga',
             ARRAY['Groonga', 'full-text search']);
INSERT INTO products
     VALUES (3,
             'PGroonga',
             ARRAY['PostgreSQL', 'Groonga', 'full-text search']);
```

You can use `%%` operator to find records that have one or more matched elements. If element's value equals to queried value, the element is treated as matched.

```sql
SELECT * FROM products WHERE tags %% 'PostgreSQL';
--  id |    name    |                  tags                   
-- ----+------------+-----------------------------------------
--   1 | PostgreSQL | {PostgreSQL,RDBMS}
--   3 | PGroonga   | {PostgreSQL,Groonga,"full-text search"}
-- (2 行)
```

## How to use Groonga throw PGroonga

This is an advanced topic.

In most cases, Groonga is faster than PostgreSQL.

For example, [drilldown feature](http://groonga.org/docs/reference/commands/select.html#drilldown) in Groonga is faster than one `SELECT` and multiple `GROUP BY`s (or one `GROUP BY GROUPING SET`) by PostgreSQL. Because all needed results can be done by one query in Groonga.

In another instance, Groonga can perform query that doesn't use all columns in record faster than PostgreSQL. Because Groonga has column oriented data store. Column oriented data store (Groonga) is faster than row oriented data store (PostgreSQL) for accessing some columns. Row oriented data store needs to read all columns in record to access only partial columns. Column oriented data store just need to read only target columns in record.

You can't use SQL to use Groonga directory. It's not PostgrSQL user friendly. But PGroonga provides a feature to use Groonga directly throw SQL.

### `pgroonga.command` function

You can execute [Groonga commands](http://groonga.org/docs/reference/command.html) and get the result of the execution as string by `pgroonga.command` function.

Here is an example that executes [status command](http://groonga.org/docs/reference/commands/status.html):

```sql
SELECT pgroonga.command('status');
--                                   command                                                                                                                  
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  [[0,1423911561.69344,6.15119934082031e-05],{"alloc_count":164,"starttime":1423911561,"uptime":0,"version":"5.0.0-6-g17847c9","n_queries":0,"cache_hit_rate":0.0,"command_version":1,"default_command_version":1,"max_command_version":2}]
-- (1 row)
```

Result from Groonga is JSON. You can use JSON related functions provided by PostgreSQL to access result from Groonga.

Here is an example to map one key value pair in the result of `status` command to one row:

```sql
SELECT * FROM json_each(pgroonga.command('status')::json->1);
--            key           |       value        
-- -------------------------+--------------------
--  alloc_count             | 168
--  starttime               | 1423911561
--  uptime                  | 221
--  version                 | "5.0.0-6-g17847c9"
--  n_queries               | 0
--  cache_hit_rate          | 0.0
--  command_version         | 1
--  default_command_version | 1
--  max_command_version     | 2
-- (9 rows)
```

See [pgroonga.command function](../reference/functions/pgroonga-command.html) for more details.

### `pgroonga.table_name` function

PGroonga stores values of index target columns. You can use these values to search and output by Groonga's [select command](http://groonga.org/docs/reference/commands/select.html).

`select` command table name in Groonga. You can use `pgroonga.table_name` function to convert index name in PostgreSQL to table name in Groonga.

Here is an example to use `select` command with `pgroonga.table_name` function:

```sql
SELECT *
  FROM json_array_elements(pgroonga.command('select ' || pgroonga.table_name('pgroonga_content_index'))::json->1->0);
--                                        value                                       
-- -----------------------------------------------------------------------------------
--  [4]
--  [["_id","UInt32"],["_key","UInt64"],["content","LongText"]]
--  [1,1,"PostgreSQLはリレーショナル・データベース管理システムです。"]
--  [2,2,"Groongaは日本語対応の高速な全文検索エンジンです。"]
--  [3,3,"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。"]
--  [4,4,"groongaコマンドがあります。"]
-- (6 rows)
```
See [pgroonga.table_name function](../reference/functions/pgroonga-table-name.html) for more details.
