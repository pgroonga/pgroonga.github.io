---
title: "jsonb型用の&`演算子"
upper_level: ../
---

# `jsonb`型用の`` &` ``演算子

1.2.1で追加。

## 概要

`` &` ``演算子はPGroonga独自の演算子です。[`@>`演算子][contain-jsonb]では書けない範囲検索のような複雑な条件を書くことができます。

もし[JsQuery][jsquery]を知っているなら、「PGroongaはJsQueryが提供しているような`jsonb`型用の検索機能を違う構文で提供している」と理解してください。

## 構文

この演算子の構文は次の通りです。

```sql
jsonb_column &` condition
```

`jsonb_column`は`jsonb`型のカラムです。

`condition`はクエリーとして使う`text`型の値です。[Groongaのスクリプト構文][groonga-script-syntax]を使います。

この演算子は`condition`が`jsonb_column`の値にマッチしたら`true`を返し、マッチしなかったら`false`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_jsonb_ops_v2`：`jsonb`型のデフォルト

  * `pgroonga_jsonb_ops`：`jsonb`用

## 使い方

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

検索条件を作るためにはPGroongaが`jsonb`型のデータ用のインデックスをどのように作るかを理解する必要があります。

PGroongaは`jsonb`型の値を複数の値に分割し、それらの分割した値に対してインデックスを作成します。SQLで言うと次のスキーマを作っていると考えてください。

```sql
CREATE TABLE values (
  key text PRIMARY KEY,
  path text,
  paths text[],
  type text,
  boolean boolean,
  number double precision,
  string text,
  size numeric
);
```

各カラムの説明は次の通りです。

  * `key`：値のIDです。値が違うパスで違う内容なら`key`は違う値になります。キーのフォーマットは`'${パス}|${種類}|${値}'`です。このカラムは検索条件には使いません。

  * `path`：値がある位置へのルートからのパスです。[jq][jq]互換のフォーマットです。オブジェクトは`["${要素名}"]`で配列は`[]`です。たとえば、`{"tags": ["web"]}`の中の`"web"`のパスは`.["tags"][]`です。もし、値の絶対パスを知っているなら検索条件でこの値を使えます。

  * `paths`: 値を示すパスです。値を示すパスは複数あります。絶対パス、サブパス、`.${要素名1}.${要素名2}`というフォーマットのパス、配列部分を省略したパスがあります。このカラムは検索条件の指定を便利にするために用意されています。検索時にはこの中のパスのどれでも使うことができます。以下はどれも`{"a": {"b": "c": ["x"]}}`の中の`"x"`を指定するパスです。

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

  * `type`：値の種類です。このカラムの値は次のどれかになります。

    * `"object"`：オブジェクト。値はありません。

    * `"array"`：配列。`size`カラムに要素数が入っています。

    * `"boolean"`：真偽値。`boolean`カラムに値が入っています。

    * `"number"`：数値。`number`カラムに値が入っています。

    * `"string"`：文字列。`string`カラムに値が入っています。

  * `boolean`：`type`カラムの値が`"boolean"`なら値が入っています。それ以外のときは`false`が入っています。

  * `number`：`type`カラムの値が`"number"`なら値が入っています。それ以外のときは`0`が入っています。

  * `string`：`type`カラムの値が`"string"`なら値が入っています。それ以外のときは`""`が入っています。

  * `size`：`type`カラムの値が`"array"`なら要素数が入っています。それ以外のときは`0`が入っています。

以下はサンプルJSONです。

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

このJSONを次の値に分割します。（これは分割した値の一部です。）

| key | path | paths | type | boolean | number | string | size |
| --- | ---- | ----- | ---- | ------- | ------ | ------ | ---- |
| `.|object` | `.` | `[.]` | `object` | | | | |
| `.["message"]|string|GET /` | `.["message"]` | `[.message, .["message"], message, ["message"]]` | `string` | | | `GET /` | |
| `.["tags"][]|string|web` | `.["tags"]` | `[.tags, .["tags"], .["tags"][], tags, ["tags"], ["tags"][], []]` | `string` | | | `web` | |

`` &` ``演算子を使って、分割した値にマッチする条件を指定します。もし、`jsonb`型の値の中に条件にマッチする分割した値が1つ以上ある場合はその`jsonb`型の値はマッチしたことになります。

次は`www.example.com`という文字列値を含む`jsonb`型の値を検索する条件です。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数][postgresql-jsonb-pretty]を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'string == "www.example.com"';
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

以下は`code`カラムの値として`200`から`299`の間の数値を持っている`jsonb`型の値を検索する条件です。この条件はパスの指定に簡易パスフォーマット（`.code`）を使うため、`paths @ "..."`という構文を使っています。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'paths @ ".code" && number >= 200 && number < 300';
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

`jsonb`型の値の中のすべてのテキスト値に対して全文検索をする条件は次の通りです。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'string @ "started"';
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

全文検索用に[Groongaのクエリー構文][groonga-query-syntax]（`a OR b`という構文を使えます）を使うには`query("string", "...")`という構文を使います。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &` 'query("string", "send OR server")';
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

## 参考

  * [`jsonb`サポート][jsonb]

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

[jsonb]:../jsonb.html

[contain-jsonb]:contain-jsonb.html

[jsquery]:https://github.com/postgrespro/jsquery

[jq]:https://stedolan.github.io/jq/

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[groonga-script-syntax]:http://groonga.org/ja/docs/reference/grn_expr/script_syntax.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
