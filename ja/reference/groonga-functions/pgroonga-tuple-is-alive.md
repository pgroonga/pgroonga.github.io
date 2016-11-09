---
title: pgroonga_tuple_is_alive Groonga関数
---

# `pgroonga_tuple_is_alive` Groonga関数

1.1.8で追加。

## 概要

`pgroonga_tuple_is_alive` Groonga関数は対象レコードに関連づいたタプルが有効かどうかを返します。

PostgreSQLは`VACUUM`を実行するまで`DELETE`・`UPDATE`された無効なタプルを消さずに持っています。PostgreSQLは検索時にこれらの無効なタプルを除外しています。

PGroongaが使っているGroongaのデータベースにも無効なタプルに関連づいたレコードが残っています。これらは`VACUUM`が実行されるまで残っています。残っているということは、`SELECT pgroonga.command('select ' || pgroonga.table_name('INDEX_NAME'))`の結果には無効なタプルに関連づいたレコードが含まれるということです。なぜなら、[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)はPostgreSQLで無効なタプルかどうか知らないからです。

`pgroonga_tuple_is_alive`はGroongaのレコードに関連づいたタプルが有効か（無効になっていないか）をチェックします。[`--filter`パラメーター](http://groonga.org/ja/docs/reference/commands/select.html#select-filter)の値に`pgroonga_tuple_is_alive(ctid)`を追加すると`VACUUM`を実行していなくても有効なレコードのみ取得できます。

## 構文

このGroonga関数の構文は次の通りです。

```text
pgroonga_tuple_is_alive(ctid)
```

`ctid`は`ctid`カラムのことです。このカラムはPGroongaが自動的に作成します。これを変更してはいけません。

## 使い方

Groongaの`select`コマンドを使うときは不正なタプルについて注意する必要があります。

最後の`VACUUM`のあと、PGroongaのインデックス対象のテーブルに対して1回以上`DELETE`または`UPDATE`が発生すると不正なレコードが返ることがあります。この状態のとき、Groongaのテーブルには削除されたタプルまたは古いタプルに関連づいたレコードが存在します。Groongaの`select`コマンドはこれらの削除されたタプル・古いタプルに関連づいたレコードを返すことがあります。<

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

`--filter`パラメーターの値に`pgroonga_tuple_is_alive(ctid)`を指定すると古いタプルに関連づいたレコードを取り除けます。

```sql
SELECT *
  FROM json_array_elements(
         pgroonga.command('select ' ||
                          pgroonga.table_name('pgroonga_posts_index') ||
                          ' --filter "pgroonga_tuple_is_alive(ctid)"'
                         )::json->1->0);
--                                               value                                              
-- -------------------------------------------------------------------------------------------------
--  [3]
--  [["_id","UInt32"],["content","LongText"],["ctid","UInt64"],["id","Int32"],["title","LongText"]]
--  [1,"PostgreSQL is a relational database management system.",1,1,"PostgreSQL"]
--  [2,"Groonga is a fast full text search engine that supports all languages.",2,2,"Groonga"]
--  [4,"Mroonga is a MySQL storage engine that uses Groonga as backend.",4,3,"Mroonga"]
-- (5 rows)
```

古いタプルに関連づいたレコードはありません。

古いタプルに関連づいたレコードは`VACUUM`実行時に削除されます。

明示的に`VACUUM FULL`を実行します。その後、`pgroonga_tuple_is_alive(ctid)`なしでGroongaの`select`コマンドを再度実行します。3レコード返ってきます。ここには古いタプルに関連づいたレコードはありません。

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

  * [`pgroonga.command`関数](../functions/pgroonga-command.html)
