---
title: "jsonb型用の&?演算子"
upper_level: ../
---

# `jsonb`型用の`&?`演算子

1.2.1で追加。

## 概要

`&?`は`jsonb`内のすべてのテキストに対してクエリーを使って全文検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column &? query
```

`column`は検索対象のカラムです。型は`jsonb`型です。

`query`は全文検索で使うクエリーです。`text`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga.jsonb_ops`：`jsonb`型のデフォルト

  * `pgroonga.jsonb_ops_v2`：`jsonb`型用

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

`@?`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して全文検索できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数][postgresql-jsonb-pretty]を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &? 'server OR mail';
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

  * [`&@` operator][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

  * [Groongaのクエリーの構文][groonga-query-syntax]

[jsonb]:../jsonb.html

[match-jsonb-v2]:match-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html

[groonga-query-syntax]:http://groonga.org/docs/reference/grn_expr/query_syntax.html
[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.en }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
