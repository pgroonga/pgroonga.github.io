---
title: pgroonga.table_name function
layout: en
---

# `pgroonga.table_name` function

TODO

You can use weight feature by `select` command.

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

`select` command in Groonga may help you when `SELECT` statement in SQL is slow.


# Attention

レコードを削除・更新している場合は、Groongaのデータベースには削除済み・
更新前のデータが残っています。

まず、更新前の状態を確認します。レコードは3つです。

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

更新します。

```sql
UPDATE terms
   SET title = 'Mroonga',
       content = 'MroongaはGroongaをバックエンドにしたMySQLのストレージエンジンです。',
       tag = 'MySQL'
 WHERE id = 3;
```

再度`select`コマンドを実行するとレコードが1つ増えて4つになっています。
これは更新前のレコードも残っているからです。

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

削除されたレコードは`VACUUM`時に削除されます。明示的に`VACUUM`を実行す
ると更新前のレコードがなくなって、レコード数は3つになります。

```sql
VACUUM
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

Groongaのデータを直接使うときは気をつけてください。
