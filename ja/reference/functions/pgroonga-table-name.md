---
title: pgroonga.table_name関数
upper_level: ../
---

# `pgroonga.table_name`関数

## 概要

`pgroonga.table_name`関数はPGroongaのインデックス名をGroongaのテーブル名に変換します。Groongaのテーブル名は[`pgroonga.command`関数](pgroonga-command.html)で[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)を使うときに便利です。

Groongaの`select`コマンドを使うと重み機能を使えます。

## 構文

この関数の構文は次の通りです。

```text
text pgroonga.table_name(pgroonga_index_name)
```

`pgroonga_index_name`は`text`型の値です。このインデックス名をGroongaのテーブル名に指定します。このインデックスは`USING pgroonga`で作ったインデックスでなければいけません。

`pgroonga.table_name`は`pgroonga_index_name`に対応するGroongaのテーブル名を`text`型の値として返します。もし、`pgroonga_index_name`が存在していない、または、PGroongaのインデックスでない場合は、`pgroonga.table_name`はエラーにします。

## 使い方

以下はサンプルのスキーマとデータです。このスキーマでは、検索対象のデータと出力対象のデータはどちらもインデックス対象のカラムです。

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

[`match_columns`オプション](http://groonga.org/ja/docs/reference/commands/select.html#select-match-columns)を使うと重みを使えます。

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

[`drilldown`オプション](http://groonga.org/ja/docs/reference/commands/select.html#select-drilldown)を使うとドリルダウン機能を使えます。

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

Groongaの`select`コマンドはSQLの`SELECT`分が遅いときの手段として使えます。

## 参考

  * [チュートリアルの`pgroonga.table_name`関数の説明](../../tutorial/#pgroonga-table-name)
  * [Groongaの`select`コマンドを使う時の注意](pgroonga-command.html#attention)
