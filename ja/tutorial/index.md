---
title: チュートリアル
layout: ja
---

# チュートリアル

このドキュメントはPGroongaの使い方を段階を追って説明します。まだPGroongaをインストールしていない場合は、このドキュメントを読む前にPGroongaを[インストール](../install/)してください。

PGroongaは高速な全文検索インデックスを提供します。さらに、等価条件（`=`）・比較条件（`<`や`>=`など）用の一般的なインデックスも提供します。

PostgreSQLは組み込みのインデックスとしてGiSTとGINを提供しています。PGroongaはGiST・GINの代わりに使うことができます。PGroongaとGiST・GINの違いは[PGroonga対GiST・GIN](../reference/pgroonga-versus-gist-and-gin.html)を参照してください。

このドキュメントは次のことを説明します。

  * PGroongaを全文検索用インデックスとして使う方法

  * PGroongaを正規表現用インデックスとして使う方法

  * PGroongaを等価条件・比較条件用インデックスとして使う方法

  * PGroongaを配列用インデックスとして使う方法

  * PGroongaをJSON用インデックスとして使う方法

  * PGroonga経由でGroongaを使う方法（高度な話題）


## 全文検索

このセクションでは次のことを説明します。

  * PGroongaベースの全文検索システムの準備方法
  * 全文検索用の演算子
  * スコアー

### PGroongaベースの全文検索システムの準備方法

このセクションはPGroongaベースの全文検索システムの準備方法を説明します。

全文検索をしたいカラムを`text`型のカラムとして作ります。

```sql
CREATE TABLE memos (
  id integer,
  content text
);
```

`memos.content`カラムが全文検索対象のカラムです。

このカラムに対して`pgroonga`インデックスを作ります。

```
CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

詳細は[CREATE INDEX USING pgroonga](../reference/create-index-using-pgroonga.html)を参照してください。

テストデータを挿入します。

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

確実に`pgroonga`インデックスを使うためにシーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

注意：本番環境ではシーケンシャルスキャンを無効にするべきではありません。これはテスト用の設定です。

### 全文検索用演算子

全文検索をする場合は次の演算子を使います。

  * `%%`
  * `@@`
  * `LIKE`
  * `ILIKE`

#### `%%`演算子

1語で全文検索を実行する場合は`%%`演算子を使います。

```sql
SELECT * FROM memos WHERE content %% '全文検索';

--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

詳細は[`%%` operator](../reference/operators/match.html)を参照してください。

#### `@@`演算子

`キーワード1 OR キーワード2`というようなクエリー構文を使って全文検索を実行する場合は`@@`演算子を使います。

```sql
SELECT * FROM memos WHERE content @@ 'PGroonga OR PostgreSQL';
--  id |                                  content
-- ----+---------------------------------------------------------------------------
--   3 | PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
-- (2 rows)
```

クエリー構文はWeb検索エンジンの構文と似ています。たとえば、`OR`を使うと複数のキーワードでの全文検索結果をマージできます。上の例ではマージされた結果が返ってきています。`PGroonga`または`PostgreSQL`を含むレコードがマージされた結果になります。

クエリー構文の詳細は[Groongaのドキュメント](http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html)を参照してください。

詳細は[`@@`演算子](../reference/operators/query.html)を参照してください。

#### `LIKE`演算子 {#like}

PGroongaは`LIKE`演算子をサポートしています。既存のSQLを変更しなくてもPGroongaを使った高速な全文検索を実現できます。

`column LIKE '%キーワードd%'`は`column %% 'キーワード'`と等価です。

```sql
SELECT * FROM memos WHERE content %% '全文検索';

--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

詳細は[`LIKE`演算子](../reference/operators/like.html)を参照してください。

`LIKE`演算子のように`ILIKE`演算子を使うこともできます。

### スコアー {#score}

`pgroonga.score`関数を使うとマッチした度合いを数値で取得することができます。検索したクエリーに対してよりマッチしているレコードほど高い数値になります。

`pgroonga.score`関数を使うためにはプライマリーキーカラムを`pgroonga`インデックスに入れる必要があります。もし、プライマリーキーカラムが`pgroonga`インデックスに入っていない場合は、`pgroonga.score`関数は常に`0`を返します。

以下はインデックス対象のカラムにプライマリーキーが入っているスキーマの例です。

```sql
CREATE TABLE score_memos (
  id integer PRIMARY KEY,
  content text
);

CREATE INDEX pgroonga_score_memos_content_index
          ON score_memos
       USING pgroonga (id, content);
```

テストデータを挿入します。

```sql
INSERT INTO score_memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO score_memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO score_memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO score_memos VALUES (4, 'groongaコマンドがあります。');
```

確実に`pgroonga`インデックスを使うためにシーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

全文検索を実行してスコアーを取得します。

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

`ORDER BY`節で`pgroonga.score`関数を使うことでスコアー順にマッチしたレコードをソートできます。

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

マッチした度合いの計算方法など詳細は[`pgroonga.score`関数](../reference/functions/pgroonga-score.html)を参照してください。

### スニペット（KWIC、keyword in context） {#snippet}

`pgroonga.snippet_html`関数を使うと検索対象のテキストからキーワード周辺のテキストを抽出できます。この処理を[KWIC](https://ja.wikipedia.org/wiki/KWIC)（keyword in context）とも言います。Webの検索エンジンの検索結果でみたことがある人も多いでしょう。

説明用のサンプルテキストは次の通りです。なお、これはGroongaの説明文です。

> Groonga is a fast and accurate full text search engine based on inverted index. One of the characteristics of Groonga is that a newly registered document instantly appears in search results. Also, Groonga allows updates without read locks. These characteristics result in superior performance on real-time applications.


この中には`fast`というキーワードがいくつか出現しています。`pgroonga.snippet_html`は`fast`周辺のテキストを抽出します。抽出されたテキスト内のキーワードは`<span class="keyword">`と`</span>`で囲まれています。

`pgroonga.snippet_html`という関数名の中の`html`は、この関数はHTML出力用の結果を返す、という意味です。

上述のテキストに対して`pgroonga.snippet_html`を実行した結果は次の通りです。

> Groonga is a <span class="keyword">fast</span> and accurate full text search engine based on inverted index. One of the characteristics of Groonga is that a newly registered document instantly appears in search results. Also, Gro

この関数はすべてのテキストに対して使うことができます。PGroongaでの検索結果以外にも使えるということです。

この挙動を説明するサンプルSQLは次の通りです。`FROM`がない次の`SELECT`でもこの関数を使えます。[`unnest`](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-array.html)は配列を列に変換するPostgreSQLの関数であることに注意してください。

```sql
SELECT unnest(pgroonga.snippet_html(
  'Groonga is a fast and accurate full text search engine based on ' ||
  'inverted index. One of the characteristics of Groonga is that a ' ||
  'newly registered document instantly appears in search results. ' ||
  'Also, Groonga allows updates without read locks. These characteristics ' ||
  'result in superior performance on real-time applications.' ||
  '\n' ||
  '\n' ||
  'Groonga is also a column-oriented database management system (DBMS). ' ||
  'Compared with well-known row-oriented systems, such as MySQL and ' ||
  'PostgreSQL, column-oriented systems are more suited for aggregate ' ||
  'queries. Due to this advantage, Groonga can cover weakness of ' ||
  'row-oriented systems.',
  ARRAY['fast', 'PostgreSQL']));
                                                                                 --                                unnest                                                                                                                 
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Groonga is a <span class="keyword">fast</span> and accurate full text search engine based on inverted index. One of the characteristics of Groonga is that a newly registered document instantly appears in search results. Also, Gro
--  ase management system (DBMS). Compared with well-known row-oriented systems, such as MySQL and <span class="keyword">PostgreSQL</span>, column-oriented systems are more suited for aggregate queries. Due to this advantage, Groonga
-- (2 rows)
```

詳細は[`pgroonga.snippet_html`関数](../reference/functions/pgroonga-snippet-html.html)を参照してください。

## 正規表現

TODO

## 等価条件と比較条件 {#equal}

等価条件と比較条件にもPGroongaを使うことができます。この使い方をする場合、文字列型と他の型でインデックスの作り方が異なります。条件の書き方は文字列型でも他の型でも違いはありません。

このセクションでは次のことを説明します。

  * 文字列型以外の型に対してPGroongaを使う方法
  * 文字列型に対してPGroongaを使う方法


### 文字列型以外にの型に対してPGroongaを使う方法 {#equal-not-string}

数値型のように文字列型以外の型にPGroongaを使うことができます。対象の型に対して等価条件と比較条件を使うことができます。

`USING pgroonga`付きでインデックスを作成します。

```sql
CREATE TABLE ids (
  id integer
);

CREATE INDEX pgroonga_id_index ON ids USING pgroonga (id);
```

PGroongaを使うために必要になる特別なSQLの書き方は`CREATE INDEX`の書き方だけです。PGroongaを使うときはBツリーのインデックスを使うときのSQLと同じSQLを使えます。

テストデータを挿入します。

```sql
INSERT INTO ids VALUES (1);
INSERT INTO ids VALUES (2);
INSERT INTO ids VALUES (3);
```

シーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

検索します。

```sql
SELECT * FROM ids WHERE id <= 2;
--  id
-- ----
--   1
--   2
-- (2 rows)
```

### 文字列型に対してPGroongaを使う方法 {#equal-string}

文字列に対する等価条件・比較条件用のインデックスとしてPGroongaを使うためには`varchar`型を使う必要があります。

`varchar`型の最大文字数は最大バイト数が4096バイト以下になるように指定する必要があります。たとえば、UTF-8エンコーディングを使う場合は最大文字数は1023文字以下にする必要があります。なぜなら、UTF-8エンコーディングの`varchar`は1文字あたり4バイト確保し、PostgreSQLはメタデータ用に4バイトを確保するからです。

`USING pgroonga`付きでインデックスを作成します。

```sql
CREATE TABLE tags (
  id integer,
  tag varchar(1023)
);

CREATE INDEX pgroonga_tag_index ON tags USING pgroonga (tag);
```

PGroongaを使うために必要になる特別なSQLの書き方は`CREATE INDEX`の書き方だけです。PGroongaを使うときはBツリーのインデックスを使うときのSQLと同じSQLを使えます。

テストデータを挿入します。

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
-- (2 rows)
--
```

## 配列に対してPGroongaを使う方法

`text`型の配列または`varchar`型の配列のインデックスとしてPGroongaを使うことができます。

`text`型の配列に対して全文検索することができます。配列の中の1つ以上の要素がマッチしたらそのレコードはマッチしたことになります。

`varchar`型の配列に対して等価条件で検索することができます。配列の中の1つ以上の要素がマッチしたらそのレコードはマッチしたことになります。これはタグ検索で有用です。

  * `text`型の配列に対してPGroongaを使う方法
  * `varchar`型の配列に対してPGroongaを使う方法

### `text`型の配列に対してPGroongaを使う方法

`USING pgroonga`付きでインデックスを作成します。

```sql
CREATE TABLE docs (
  id integer,
  sections text[]
);

CREATE INDEX pgroonga_sections_index ON docs USING pgroonga (sections);
```

テストデータを挿入します。

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

全文検索には`%%`演算子または`@@`演算子を使えます。全文検索では何番目の要素かは考慮しません。

```sql
SELECT * FROM docs WHERE sections %% '全文検索';
--  id |                                                          sections                                                          
-- ----+----------------------------------------------------------------------------------------------------------------------------
--   1 | {PostgreSQLはリレーショナル・データベース管理システムです。,PostgreSQLは部分的に全文検索をサポートしています。}
--   2 | {Groongaは日本語対応の高速な全文検索エンジンです。,Groongaは他のシステムに組み込むことができます。}
--   3 | {PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。,PostgreSQLに高機能な全文検索機能を追加します。}
-- (3 rows)
```

### `varchar`型の配列に対してPGroongaを使う方法

`USING pgroonga`付きでインデックスを作成します。

```sql
CREATE TABLE products (
  id integer,
  name text,
  tags varchar(1023)[]
);

CREATE INDEX pgroonga_tags_index ON products USING pgroonga (tags);
```

テストデータを挿入します。

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

指定した要素を含んだレコードを見つけるには`%%`演算子を使います。もし、要素の値が指定した値と等しければその要素はマッチしたことになります。

```sql
SELECT * FROM products WHERE tags %% 'PostgreSQL';
--  id |    name    |                  tags                   
-- ----+------------+-----------------------------------------
--   1 | PostgreSQL | {PostgreSQL,RDBMS}
--   3 | PGroonga   | {PostgreSQL,Groonga,"full-text search"}
-- (2 rows)
```

## JSONに対してPGroongaを使う方法 {#json}

PGroongaは`jsonb`型にも対応しています。PGroongaを使うとJSON中のキー・値に対して検索することができます。

JSON中のすべてのテキスト値に対して全文検索することもできます。これはPGroonga独自の機能です。PostgreSQL組み込みの機能でも[JsQuery](https://github.com/postgrespro/jsquery)でもこの機能はサポートしていません。

次のJSONを考えてください。

```json
{
  "message": "Server is started.",
  "host": "www.example.com",
  "tags": [
    "web",
  ]
}
```

`search`、`example`、`web`のどれで全文検索してもこのJSONを見つけることができます。なぜなら、すべてのテキスト値が全文検索対象だからです。

PGroongaは`jsonb`に対して検索するために次の2つの演算子を提供しています。

  * `@>`演算子
  * `@@`演算子

[`@>`演算子はPostgreSQL組み込みの演算子](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/functions-json.html#FUNCTIONS-JSONB-OP-TABLE)です。`@>`は右辺の`jsonb`が左辺の`jsonb`のサブセットなら真を返します。

PGroongaを使うことで高速に`@>`を実行出来ます。

`@@`演算子はPGroonga独自の演算子です。`@>`演算子では記述することができない範囲検索のような複雑な条件も使えます。

### サンプルスキーマとデータ

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE logs (
  record jsonb
);

CREATE INDEX pgroonga_logs_index ON logs USING pgroonga (record);

INSERT INTO logs
     VALUES ('{
                "message": "Server is started.",
                "host":    "www.example.com",
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "GET /",
                "host":    "www.example.com",
                "code":    200,
                "tags": [
                  "web",
                  "example.com"
                ]
              }');
INSERT INTO logs
     VALUES ('{
                "message": "Send to <info@example.com>.",
                "host":    "mail.example.net",
                "tags": [
                  "mail",
                  "example.net"
                ]
              }');
```

シーケンシャルスキャンを無効にします。

```sql
SET enable_seqscan = off;
```

### `@>`演算子 {#jsonb-contain}

`@>`演算子は`jsonb`の値で検索条件を指定します。もし、条件に指定した`jsonb`の値が検索対象の`jsonb`の値のサブセットなら`@>`演算子は`true`を返します。

例です。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数](http://www.postgresql.jp/document/current/html/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE)を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"host": "www.example.com"}'::jsonb;
--             jsonb_pretty             
-- -------------------------------------
--  {                                  +
--      "host": "www.example.com",     +
--      "tags": [                      +
--          "web",                     +
--          "example.com"              +
--      ],                             +
--      "message": "Server is started."+
--  }
--  {                                  +
--      "code": 200,                   +
--      "host": "www.example.com",     +
--      "tags": [                      +
--          "web",                     +
--          "example.com"              +
--      ],                             +
--      "message": "GET /"             +
--  }
-- (2 rows)
```

詳細は[`@>`演算子](../reference/operators/jsonb-contain.html)を参照してください。

### `@@`演算子

`@@`演算子はPGroonga独自の演算子です。`@>`演算子では記述することができない範囲検索のような複雑な条件も使えます。

範囲検索をする例です。この`SELECT`は次の条件にマッチするレコードを返します。

  * トップレベルのオブジェクトに`code`というキーが存在する
  * その`code`の値が`200`以上`300`未満である

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数](http://www.postgresql.jp/document/current/html/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE)を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @@ 'paths @ ".code" && number >= 200 && number < 300';
--           jsonb_pretty          
-- --------------------------------
--  {                             +
--      "code": 200,              +
--      "host": "www.example.com",+
--      "tags": [                 +
--          "web",                +
--          "example.com"         +
--      ],                        +
--      "message": "GET /"        +
--  }
-- (1 row)
```

詳細は[`jsonb`用の`@@`演算子](../reference/operators/jsonb-query.html)を参照してください。

## PGroonga経由でGroongaを使う方法 {#groonga}

これは上級者向けの内容です。

多くの場合、GroongaはPostgreSQLより高速です。

たとえば、Groongaの[ドリルダウン機能](http://groonga.org/ja/docs/reference/commands/select.html#drilldown)はPostgreSQLで`SELECT`1回と複数の`GROUP BY`（または1回の`GROUP BY GROUPING SET`）を実行するよりも速いです。なぜならGroongaでは1回のクエリーで必要な結果をすべて返すからです。

別の例も紹介します。レコード中の一部のカラムしか使わないクエリーの実行はPostgreSQLよりGroongaの方が速いです。なぜなら、Groongaはカラム指向（列指向）のデータストアを実装しているからです。カラム指向のデータストア（Groonga）は行指向のデータストア（PostgreSQL）よりも一部のカラムにアクセスするのが速いのです。行指向のデータストアは一部のカラムにアクセスするだけでよい場合でもすべてのカラムを読み込む必要があります。一方、カラム指向のデータストアは必要なカラムだけを読み込むことができます。

GroongaそのものはSQLのインターフェイスを提供していません。これはPostgreSQLユーザーには使いづらいです。しかし、PGroongaはSQL経由でGroongaを使う機能を提供しています。

### `pgroonga.command`関数

`pgroonga.command`関数を使うと[Groongaのコマンド](http://groonga.org/ja/docs/reference/command.html)を実行し、その結果を文字列で取得できます。

以下は[`status`コマンド](http://groonga.org/ja/docs/reference/commands/status.html)を実行する例です。

```sql
SELECT pgroonga.command('status');
--                                   command                                                                                                                  
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  [[0,1423911561.69344,6.15119934082031e-05],{"alloc_count":164,"starttime":1423911561,"uptime":0,"version":"5.0.0-6-g17847c9","n_queries":0,"cache_hit_rate":0.0,"command_version":1,"default_command_version":1,"max_command_version":2}]
-- (1 row)
```

Groongaから返ってくる結果はJSONです。Groongaから返ってくる結果にアクセスするためにPostgreSQLが提供するJSON関連の関数を使うことができます。

以下は`status`コマンドの結果のキーと値のペアそれぞれを列に変換する例です。

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

詳細は[`pgroonga.command`関数](../reference/functions/pgroonga-command.html)を参照してください。

### `pgroonga.table_name`関数 {#pgroonga-table-name}

PGroongaはインデックス対象のカラムの値を保存しています。これらの値を[Groongaの`select`コマンド](http://groonga.org/ja/docs/reference/commands/select.html)で検索・出力するために使うことができます。

Groongaの`select`コマンドを使うにはテーブル名が必要です。`pgroonga.table_name`関数を使うとPostgreSQLでのインデックス名をGroongaでのテーブル名に変換できます。

以下は`pgroonga.table_name`関数を使って`select`コマンドを実行する例です。

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

詳細は[`pgroonga.table_name`関数](../reference/functions/pgroonga-table-name.html)を参照してください。

## 次のステップ

これでPGroongaのすべての機能を知ったことになります！各機能を理解したい場合は各機能の[リファレンスマニュアル](../reference/)を参照しくてください。

[ハウツー](../how-to/)は特定用途向けのPGroongaの使い方を紹介しています。

なにか問題にぶつかった、有用な情報を持っている、そんな方は[PGroongaのコミュニティー](../community/)に参加してください。
