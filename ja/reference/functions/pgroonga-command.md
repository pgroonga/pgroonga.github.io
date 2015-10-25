---
title: pgroonga.command関数
layout: ja
---

# `pgroonga.command`関数

## 概要

`pgroonga.command`関数は[Groongaのコマンド](http://groonga.org/ja/docs/reference/command.html)を実行して`text`型の値として結果を返します。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.command(command)
```

`command`は`text`型の値です。`pgroonga.command`は`command`をGroongaのコマンドとして実行します。

Groongaのコマンドは結果をJSONとして返します。`pgroonga.command`はJSONを`text`型の値として返します。結果を`json`型か`jsonb`型にキャストすると[PostgreSQLが提供するJSON関数・演算](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-json.html)を使うことができます。

## 使い方

[チュートリアルの例](../../tutorial/#groonga)も参照してください。

{: #attention}

## Groongaの`select`コマンドに関する注意事項

[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使うとき、不正なレコードについて注意する必要があります。

最後の`VACUUM`のあと、PGroongaのインデックス対象のテーブルに対して1回以上`DELETE`または`UPDATE`が発生すると不正なレコードが返ることがあります。この状態のとき、Groongaのテーブルには削除されたレコードまたは古いレコードが存在します。Groongaの`select`コマンドはこれらの削除されたレコード・古いレコードを返すことがあります。

このケースを例で説明します。

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE posts (
  id integer PRIMARY KEY,
  title text,
  content text
);

CREATE INDEX pgroonga_posts_index
          ON posts
       USING pgroonga (id, title, content);

INSERT INTO posts VALUES (1, 'PostgreSQL', 'PostgreSQL is a relational database management system.');
INSERT INTO posts VALUES (2, 'Groonga', 'Groonga is a fast full text search engine that supports all languages.');
INSERT INTO posts VALUES (3, 'PGroonga', 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
```

以下は更新前の結果です。3レコードあります。

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"PGroonga is a PostgreSQL extension that uses Groonga as index.",3,3,"PGroonga"]
-- (5 rows)
```

1つのレコードを更新します。

```sql
UPDATE posts
   SET title = 'Mroonga',
       content = 'Mroonga is a MySQL storage engine that uses Groonga as backend.'
 WHERE id = 3;
```

Groongaの`select`コマンドを再度実行します。4レコード返ります。1レコード増えています。これは、更新前のレコードが残っているからです。

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [4]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"PGroonga is a PostgreSQL extension that uses Groonga as index.",3,3,"PGroonga"]
--  [4,"Mroonga is a MySQL storage engine that uses Groonga as backend.",4,3,"Mroonga"]
-- (6 rows)
```

古いレコードは`VACUUM`実行時に削除されます。

明示的に`VACUUM FULL`を実行します。その後、Groongaの`select`コマンドを再度実行します。3レコード返ってきます。ここには古いレコードはありません。

```sql
VACUUM FULL;
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index')
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [3,"Mroonga is a MySQL storage engine that uses Groonga as backend.",3,3,"Mroonga"]
-- (5 rows)
```

## 参考

  * [チュートリアルにある例](../../tutorial/#groonga)
