---
title: pgroonga.command function
layout: en
---

# `pgroonga.command` function

## Summary

`pgroonga.command` function executes a [Groonga command](http://groonga.org/docs/reference/command.html) and returns the result as `text` type value.

## Syntax

Here is the syntax of this function:

```text
text pgroonga.command(command)
```

`command` is a `text` type value. `pgroonga.command` executes `command` as a Groonga command.

Groonga command returns result as JSON. `pgroonga.command` returns the JSON as `text` type value. You can use [JSON functions and operations provided by PostgreSQL](http://www.postgresql.org/docs/current/static/functions-json.html) by casting the result to `json` or `jsonb` type.

## Usage

See [examples in tutorial](../../tutorial/#groonga).

{: #attention}

## Attention for `select` Groonga command

You need to take care about invalid records when you use [`select` Groonga command](http://groonga.org/docs/reference/commands/select.html).

You may get invalid records when PGroonga index target table processed one or more `DELETE` or `UPDATE` after last `VACUUM`. There are deleted and/or old records exist in Groonga table for the case. If there are deleted or old records, `select` Groonga command may return them.

The followings show this case by example.

Here is the result before updating. There are 3 records:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_terms_index')
                         )::json->1->0);
--                                                    value                                                   
-- -----------------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["_key","UInt64"],["content","LongText"],["tag","ShortText"],["title","LongText"]]
--  [1,1,"PostgreSQLはリレーショナル・データベース管理システムです。","PostgreSQL","PostgreSQL"]
--  [2,2,"Groongaは日本語対応の高速な全文検索エンジンです。","Groonga","Groonga"]
--  [3,3,"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","PostgreSQL","PGroonga"]
-- (5 行)
```

Update 1 record:

```sql
UPDATE terms
   SET title = 'Mroonga',
       content = 'MroongaはGroongaをバックエンドにしたMySQLのストレージエンジンです。',
       tag = 'MySQL'
 WHERE id = 3;
```

Executes `select` Groonga command again. It returns 4 records. 1 record is added because there is the record before updating:

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_terms_index')
                         )::json->1->0);
--                                                    value                                                   
-- -----------------------------------------------------------------------------------------------------------
--  [4]
--  [["_id","UInt32"],["_key","UInt64"],["content","LongText"],["tag","ShortText"],["title","LongText"]]
--  [1,1,"PostgreSQLはリレーショナル・データベース管理システムです。","PostgreSQL","PostgreSQL"]
--  [2,2,"Groongaは日本語対応の高速な全文検索エンジンです。","Groonga","Groonga"]
--  [3,3,"PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。","PostgreSQL","PGroonga"]
--  [4,4,"MroongaはGroongaをバックエンドにしたMySQLのストレージエンジンです。","MySQL","Mroonga"]
-- (6 行)
```

The old record is deleted when `VACUUM` is executed.

Execute `VACUUM` explicitly. And then execute `select` Groonga command again. It returns 3 records. There isn't the old record:

```sql
VACUUM;
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_terms_index')
                         )::json->1->0);
--                                                 value                                                 
-- ------------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["_key","UInt64"],["content","LongText"],["tag","ShortText"],["title","LongText"]]
--  [1,1,"PostgreSQLはリレーショナル・データベース管理システムです。","PostgreSQL","PostgreSQL"]
--  [2,2,"Groongaは日本語対応の高速な全文検索エンジンです。","Groonga","Groonga"]
--  [4,4,"MroongaはGroongaをバックエンドにしたMySQLのストレージエンジンです。","MySQL","Mroonga"]
-- (5 行)
```

## See also

  * [Examples in tutorial](../../tutorial/#groonga)
