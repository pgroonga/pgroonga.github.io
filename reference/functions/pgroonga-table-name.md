---
title: pgroonga.table_name function
layout: en
---

# `pgroonga.table_name` function

## Summary

`pgroonga.table_name` function converts PGroonga index name to Groonga table name. Groonga table name is useful [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html) by [`pgroonga.command` function](pgroonga-command.html).

You can use weight feature by `select` Groonga command.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.table_name(pgroonga_index_name)
```

`pgroonga_index_name` is a `text` type value. It's an index name to be converted to Groonga table name. The index should be created with `USING pgroonga`.

`pgroonga.table_name` returns Groonga table name for `pgroonga_index_name` as `text` type value. If `pgroonga_index_name` doesn't exist or isn't a PGroonga index, `pgroonga.table_name` raises an error.

## Usage

Here are sample schema and data. In the schema, both search target data and output data are index target columns:

```sql
CREATE TABLE terms (
  id integer,
  title text,
  content text,
  tag varchar(256)
);

CREATE INDEX pgroonga_terms_index
          ON terms
       USING pgroonga (title, content, tag);

INSERT INTO terms
     VALUES (1,
             'PostgreSQL',
             'PostgreSQLはリレーショナル・データベース管理システムです。',
             'PostgreSQL');
INSERT INTO terms
     VALUES (2,
             'Groonga',
             'Groongaは日本語対応の高速な全文検索エンジンです。',
             'Groonga');
INSERT INTO terms
     VALUES (3,
             'PGroonga',
             'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。',
             'PostgreSQL');
```

You can use [match_columns option](http://groonga.org/docs/reference/commands/select.html#select-match-columns) to use weight:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_terms_index') || ' ' ||
                          '--match_columns "title * 10 || content" ' ||
                          '--query "Groonga OR PostgreSQL OR 全文検索" ' ||
                          '--output_columns "_score, title, content" ' ||
                          '--sortby "-_score"'
                         )::json->1->0);
--                                            value                                            
-- --------------------------------------------------------------------------------------------
--  [3]
--  [["_score","Int32"],["title","LongText"],["content","LongText"]]
--  [12,"Groonga","Groongaは日本語対応の高速な全文検索エンジンです。"]
--  [11,"PostgreSQL","PostgreSQLはリレーショナル・データベース管理システムです。"]
--  [2,"PGroonga","PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。"]
-- (5 rows)
```

You can use drilldown feature by [drilldown option](http://groonga.org/docs/reference/commands/select.html#select-drilldown):

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_terms_index') || ' ' ||
                          '--match_columns "title * 10 || content" ' ||
                          '--query "Groonga OR PostgreSQL OR 全文検索" ' ||
                          '--output_columns "_score, title" ' ||
                          '--sortby "-_score" ' ||
                          '--drilldown "tag"'
                         )::json->1);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [[3],[["_score","Int32"],["title","LongText"]],[12,"Groonga"],[11,"PostgreSQL"],[2,"PGroonga"]]
--  [[2],[["_key","ShortText"],["_nsubrecs","Int32"]],["Groonga",1],["PostgreSQL",2]]
-- (2 rows)
```

`select` Groonga command may help you when `SELECT` statement in SQL is slow.

## See also

  * [`pgroonga.table_name` function description in tutorial](../../tutorial/#pgroonga-table-name)
  * [Attention when you use `select` Groonga command](pgroonga-command.html#attention)
