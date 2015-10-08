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

{: #score}

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

See [`pgroonga.score` function](../reference/functions/pgroonga-score.html) for more details such as how to compute precision.

{: #snippet}

### Snippet (KWIC, keyword in context)

You can use `pgroonga.snippet_html` function to get texts around keywords from search target text. It's also known as [KWIC](https://en.wikipedia.org/wiki/Key_Word_in_Context) (keyword in context). You can see it in search result on Web search engine.

Here is a sample text for description. It's a description about Groonga.

> Groonga is a fast and accurate full text search engine based on inverted index. One of the characteristics of Groonga is that a newly registered document instantly appears in search results. Also, Groonga allows updates without read locks. These characteristics result in superior performance on real-time applications.


There are some `fast` keywords. `pgroonga.snippet_html` extracts texts around `fast`. Keywords in extracted texts are surround with `<span class="keyword">` and `</span>`.

`html` in `pgroonga.snippet_html` means that this function returns result for HTML output.

Here is the result of `pgroonga.snippet_html` against the above text:

> Groonga is a <span class="keyword">fast</span> and accurate full text search engine based on inverted index. One of the characteristics of Groonga is that a newly registered document instantly appears in search results. Also, Gro

This function can be used for all texts. It's not only for search result by PGroonga.

Here is a sample SQL that describe about it. You can use the function in the following `SELECT` that doesn't have `FROM`. Note that [`unnest`](http://www.postgresql.org/docs/current/static/functions-array.html) is a PostgreSQL function that converts an array to rows.

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

See [`pgroonga.snippet_html` function](../reference/functions/pgroonga-snippet-html.html) for more details.

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

{: #json}

## How to use PGroonga for JSON

TODO: Split details to reference/

PGroongaは`jsonb`型のデータもサポートしています。PGroongaのインデック
スを作成することにより高速に検索できます。

PGroongaは`jsonb`の検索のために次の2つの演算子を提供しています。

  * `@>`演算子
  * `@@`演算子

[`@>`演算子はPostgreSQLが標準で提供している演算子](http://www.postgresql.org/docs/current/static/functions-json.html#FUNCTIONS-JSONB-OP-TABLE)
です。右辺が左辺のサブセットなら真になります。

`@>`演算子はGINでも高速化できる演算子です。インデックス作成時間は
PGroongaとGINでそれほど変わりませんが、検索時間はPGroongaの方が少し速
いです。

`@@`演算子はPGroonga独自の演算子です。GINではインデックスを使えない複
雑な検索条件も記述できます。もし、
[JsQuery](https://github.com/postgrespro/jsquery)を知っているなら
構文が違うJsQueryのようなものと考えてください。

JsQueryができる検索とPGroongaができる検索はほぼ同じですが、PGroongaだ
けができる特徴的な検索は全文字列値に対しての全文検索です。

たとえば、次のJSONがあるとします。

```json
{
  "message": "Server is started.",
  "host": "www.example.com",
  "tags": [
    "web",
  ]
}
```

すべての文字列値に対して全文検索ができるので、「`server`」でも
「`example`」でも「`web`」でもヒットします。

#### サンプル用テーブル定義とサンプルデータ

例を示すために使うサンプル用のテーブル定義とサンプルデータを次に示します。

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

少ないデータでもインデックスを使うようにシーケンシャルスキャンを無効に
します。

```sql
SET enable_seqscan = off;
```

#### `@>`演算子

`@>`演算子は`jsonb`で条件を指定します。カラムの値が条件として指定した
`jsonb`を含んでいればマッチします。

マッチする例です。（結果を見やすくするためにPostgreSQL 9.5から使える
`jsonb_pretty()`関数を使っています。）

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

マッチしない例です。

条件の`jsonb`で配列を指定した場合、すべての要素が含まれていればマッチ
します。（配列の要素の順序は関係ありません。）しかし、1つでも含まれて
いない要素があればマッチしません。次の`tags`に`"mail"`を含むレコードも
`"web"`を含むレコードもありますが、両方含むレコードはないのでヒットし
ません。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"tags": ["mail", "web"]}'::jsonb;
--  jsonb_pretty 
-- --------------
-- (0 rows)
```

#### `@@`演算子

`@@`演算子は
[Groongaのスクリプト構文](http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html)
で条件を指定します。条件をどのように指定すればよいかわかるためには、
PGroongaがどのように`jsonb`のデータに対してインデックスを作成している
かを理解する必要があります。

PGroongaは`jsonb`の値を分解し、それぞれの値に対してインデックスを張っ
ています。SQLでいうと次のスキーマがあると考えてください。

```sql
CREATE TABLE values (
  key text PRIMARY KEY,
  path text,
  paths text[],
  type text,
  boolean boolean,
  number double,
  string text,
  size numeric
);
```

それぞれ次の値が入っています。

  * `key`: 同じ値では同一になる値。フォーマットは「`${パス}|${種類}|${値}`」。条件で使うことはない。
  * `path`: その値の位置を示すルートからのパス。[jq](https://stedolan.github.io/jq/)と互換で、オブジェクトは`["${要素名}"]`、配列は`[]`となる。たとえば、`{"tags": ["web"]}`の`"web"`を示すパスは`.["tags"][]`。パスが完全にわかっている場合は条件でこの値を使う。
  * `paths`: その値の位置を示すパスが複数入っている。絶対パス、サブパス、`.${要素名1}.${要素名2}`表記のパス、配列なしのパスが入っているので条件で指定するときに便利。たとえば、`{"a": {"b": "c": ["x"]}}`の`"x"`の場合は次のパスが入っている。
     * `.a.b.c`
     * `.["a"]["b"]["c"]`
     * `.["a"]["b"]["c"][]`
     * `a.b.c`
     * `["a"]["b"]["c"]`
     * `["a"]["b"]["c"][]`
     * `b.c`
     * `["b"]["c"]`
     * `["b"]["c"][]`
     * `c`
     * `["c"]`
     * `["c"][]`
     * `[]`
  * `type`: そのパスの値の種類。種類によって値がどのカラムに入るかが変わる。次のうちのどれか。
    * `object`: オブジェクト。値はない。
    * `array`: 配列。`size`に要素数が入る。
    * `boolean`: 真偽値。`boolean`に値が入る。
    * `number`: 数値。`number`に値が入る。
    * `string`: 文字列。`string`に値が入る。
  * `boolean`: `type`が`boolean`のとき有効な値が入っている。それ以外のときは`false`が入っている。
  * `number`: `type`が`number`のとき有効な値が入っている。それ以外のときは`0`が入っている。
  * `string`: `type`が`string`のとき有効な値が入っている。それ以外のときは空文字列が入っている。
  * `size`: `type`が`array`のとき配列の要素数が入っている。それ以外のときは`0`が入っている。

たとえば、次のJSONを考えます。

```json
{
  "message": "GET /",
  "host":    "www.example.com",
  "code":    200,
  "tags": [
    "web",
    "example.com"
  ]
}
```

このJSONは次のように分解されます。（一部です。）

| key | path | paths | type | boolean | number | string | size |
| --- | ---- | ----- | ---- | ------- | ------ | ------ | ---- |
| `.|object` | `.` | `[.]` | `object` | | | | |
| `.["message"]|string|GET /` | `.["message"]` | `[.message, .["message"], message, ["message"]]` | `string` | | | `GET /` | |
| `.["tags"][]|string|web` | `.["tags"]` | `[.tags, .["tags"], .["tags"][], tags, ["tags"], ["tags"][], []]` | `string` | | | `web` | |

`@`演算子の条件では分解した個々の値を特定する条件を指定します。指定した条件すべてを含んだ`jsonb`がマッチした`jsonb`になります。

`www.example.com`という文字列を含んだ`jsonb`を検索する場合は次のようにします。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @@ 'string == "www.example.com"';
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

`code`が`200`台のレコードを検索する場合は次のようにします。省略記法（`.code`）でパスを指定したいので`paths @ "..."`という条件指定をしています。

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

全文検索をする場合は次のように`string @ "..."`を使います。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @@ 'string @ "started"';
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
-- (1 row)
```

クエリー構文（`a OR b`のような書き方）を使って全文検索をしたい場合は
`query("string", "...")`を使います。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @@ 'query("string", "send OR server")';
--                  jsonb_pretty                 
-- ----------------------------------------------
--  {                                           +
--      "host": "www.example.com",              +
--      "tags": [                               +
--          "web",                              +
--          "example.com"                       +
--      ],                                      +
--      "message": "Server is started."         +
--  }
--  {                                           +
--      "host": "mail.example.net",             +
--      "tags": [                               +
--          "mail",                             +
--          "example.net"                       +
--      ],                                      +
--      "message": "Send to <info@example.com>."+
--  }
-- (2 rows)
```


{: #groonga}

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

See [`pgroonga.command` function](../reference/functions/pgroonga-command.html) for more details.

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
