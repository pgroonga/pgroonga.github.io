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

Groongaのコマンドは結果をJSONとして返します。`pgroonga.command`はJSONを`text`型の値として返します。結果を`json`型か`jsonb`型にキャストすると[PostgreSQLが提供するJSON関数・演算](http://www.postgresql.org/docs/current/static/functions-json.html)を使うことができます。

## 使い方

[チュートリアルの例](../../tutorial/#groonga)も参照してください。

{: #attention}

## Groongaの`select`コマンドに関する注意事項

[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使うとき、不正なレコードについて注意する必要があります。

最後の`VACUUM`のあと、PGroongaのインデックス対象のテーブルに対して1回以上`DELETE`または`UPDATE`が発生すると不正なレコードが返ることがあります。この状態のとき、Groongaのテーブルには削除されたレコードまたは古いレコードが存在します。Groongaの`select`コマンドはこれらの削除されたレコード・古いレコードを返すことがあります。

このケースを例で説明します。

以下は更新前の結果です。3レコードあります。

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

1つのレコードを更新します。

```sql
UPDATE terms
   SET title = 'Mroonga',
       content = 'MroongaはGroongaをバックエンドにしたMySQLのストレージエンジンです。',
       tag = 'MySQL'
 WHERE id = 3;
```

Groongaの`select`コマンドを再度実行します。4レコード返ります。1レコード増えています。これは、更新前のレコードが残っているからです。

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

古いレコードは`VACUUM`実行時に削除されます。

明示的に`VACUUM`を実行します。その後、Groongaの`select`コマンドを再度実行します。3レコード返ってきます。ここには古いレコードはありません。

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

## 参考

  * [チュートリアルにある例](../../tutorial/#groonga)
