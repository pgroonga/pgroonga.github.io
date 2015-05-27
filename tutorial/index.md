---
title: Tutorial
layout: en
---

# Tutorial

This document describes how to use PGroonga step by step. If you don't install PGroonga yet, [install](../install/) PGroonga before you read this document.

You can use PGroonga as fast full text search index. You can also use PGroonga as more general index for equality condition (`=`) and comparison conditions ('<', '>=' and so on).

PostgreSQL provides GiST and GIN as bundled indexes. You can use PGroonga as alternative of GiST and GIN. See [PGroonga versus GiST and GIN](../reference/pgroonga-versus-gist-and-gin.html) for differences of them.

This document describes about the followings:

  * How to use PGroonga as full text search index
  * How to use PGroonga as index for equality condition and comparison conditions
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

See [%% operator](../reference/match-operator.html) for more details.

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

See [@@ operator](../reference/query-operator.html) for more details.

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

See [LIKE operator](../reference/like-operator.html) for more details.

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

See [pgroonga.score function](../reference/pgroonga-score-function.html) for more details such as how to compute precision.

## Equality condition and comparison conditions

You can use PGroonga for equality condition and comparison conditions. There are some differences between how to create index for string types and other types. There is no difference between how to write condition for string types and other types.

This section describes about the following:

  * How to use PGroonga for not string types
  * How to use PGroonga for string types

### How to use PGroonga for not string types

You can use PGroonga for not string types such as number.

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

### How to use PGroonga for not string types

TODO

文字列型に対して等価・比較条件を使う場合は`varchar`型に対してインデッ
クスを作成してください。最大バイト数が4096バイト以下になるように
`varchar`に最大文字数を指定してください。エンコーディングによって文字
数とバイト数の関係が変わることに注意してください。UTF-8を使っている場
合は最大文字数は1023になります。

```sql
CREATE TABLE tags (
  id integer,
  tag varchar(1023)
);

CREATE INDEX pgroonga_tag_index ON tags USING pgroonga (tag);
```

あとはB-treeを使ったインデックスなどのときと同じです。

データを投入します。

```sql
INSERT INTO tags VALUES (1, 'PostgreSQL');
INSERT INTO tags VALUES (2, 'Groonga');
INSERT INTO tags VALUES (3, 'Groonga');
```

シーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

検索します。

```sql
SELECT * FROM tags WHERE tag = 'Groonga';
--  id |   tag
-- ----+---------
--   2 | Groonga
--   3 | Groonga
-- (2 行)
--
```

### 配列を使う

PGroongaでは`text`型または`varchar`型の配列に対するインデックスを作成
することもできます。

`text`型の配列の場合はそれぞれの要素に対して全文検索できます。

`varchar`型の配列の場合はそれぞれの要素に対して完全一致検索できます。
タグ検索などで有用です。

#### `text`型の配列

インデックスを作成するときに`USING pgroonga`を指定します。

```sql
CREATE TABLE docs (
  id integer,
  sections text[]
);

CREATE INDEX pgroonga_sections_index ON docs USING pgroonga (sections);
```

データを投入します。

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

`%%`演算子または`@@`演算子を使って全文検索できます。キーワードが何番目
の要素にあっても全文検索できます。

```sql
SELECT * FROM docs WHERE sections %% '全文検索';
--  id |                                                          sections                                                          
-- ----+----------------------------------------------------------------------------------------------------------------------------
--   1 | {PostgreSQLはリレーショナル・データベース管理システムです。,PostgreSQLは部分的に全文検索をサポートしています。}
--   2 | {Groongaは日本語対応の高速な全文検索エンジンです。,Groongaは他のシステムに組み込むことができます。}
--   3 | {PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。,PostgreSQLに高機能な全文検索機能を追加します。}
-- (3 行)
```

#### `varchar`型の配列

インデックスを作成するときに`USING pgroonga`を指定します。

```sql
CREATE TABLE products (
  id integer,
  name text,
  tags varchar(1023)[]
);

CREATE INDEX pgroonga_tags_index ON products USING pgroonga (tags);
```

データを投入します。

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

`%%`演算子を使うと、配列の中に完全一致した要素があるかを検索できます。

```sql
SELECT * FROM products WHERE tags %% 'PostgreSQL';
--  id |    name    |                  tags                   
-- ----+------------+-----------------------------------------
--   1 | PostgreSQL | {PostgreSQL,RDBMS}
--   3 | PGroonga   | {PostgreSQL,Groonga,"full-text search"}
-- (2 行)
```

### Groongaの機能を使う

多くの場合、PostgreSQLよりGroongaの方が高速に処理できます。たとえば、
ドリルダウン機能を使うことにより検索結果の取得と複数の`GROUP BY`結果の
取得を1つのクエリーで実行することができるため、複数の`SELECT`文を実行
するよりも高速です。他にも、Groongaは列指向のデータストアを使っている
ため、一部のカラムだけを検索・取得する場合は行指向のデータストアの
PostgreSQLよりも高速です。

しかし、直接Groongaで検索するとSQLとは違うAPIになり、使い勝手がよくあ
りません。それでもGroongaを使いたい場合のためにSQL経由でGroongaを使う
機能を用意しています。

#### `pgroonga.command`関数

`pgroonga.command`関数を使うと
[Groongaのコマンド](http://groonga.org/ja/docs/reference/command.html)
を実行してその結果を文字列で取得できます。

次は
[statusコマンド](http://groonga.org/ja/docs/reference/commands/status.html)
を実行する例です。

```sql
SELECT pgroonga.command('status');
--                                   command                                                                                                                  
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  [[0,1423911561.69344,6.15119934082031e-05],{"alloc_count":164,"starttime":1423911561,"uptime":0,"version":"5.0.0-6-g17847c9","n_queries":0,"cache_hit_rate":0.0,"command_version":1,"default_command_version":1,"max_command_version":2}]
-- (1 行)
```

Groongaのコマンドの実行結果はJSONなのでPostgreSQLのJSON関数を使って扱
いやすくすることができます。

たとえば、`status`コマンドの結果は次のようにするとそれぞれの値を1行と
して扱うことができます。

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
-- (9 行)
```

#### `pgroonga.table_name`関数

PGroongaのインデックス対象のカラムの値はGroongaのデータベースにも保存
されています。そのため、Groongaの
[selectコマンド](http://groonga.org/ja/docs/reference/commands/select.html)
を使って検索し、値を出力することができます。

`select`コマンドを使うにはGroongaでのテーブル名が必要です。インデック
ス名をGroongaでのテーブル名に変換するには`pgroonga.table_name`関数を使
います。

`pgroonga.table_name`関数を使うと次のように`select`コマンドを使うこと
ができます。

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
-- (6 行)
```

`select`コマンドを使うとカラムに重みをつけることもできます。

例として次のようなスキーマとデータを使います。検索したいデータと出力し
たいデータを両方インデックス対象にしています。

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

[match_columnsオプション](http://groonga.org/ja/docs/reference/commands/select.html#select-match-columns)で重みを指定できます。

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
-- (5 行)
```

[drilldownオプション](http://groonga.org/ja/docs/reference/commands/select.html#select-drilldown)
を加えるとドリルダウン結果も取得できます。

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
-- (2 行)
```

SQLの`SELECT`文でどうにもならなくなったときに、もしかしたらGroongaの
`select`コマンドを使えるかもしれません。

#### 注意

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
