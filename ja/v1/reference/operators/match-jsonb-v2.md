---
title: "jsonb型用の&@演算子"
upper_level: ../
---

# `jsonb`型用の`&@`演算子

1.2.1で追加。

## 概要

`&@`演算子は`jsonb`内のすべてのテキストに対して1つのキーワードで全文検索を実行します。

## 構文

```sql
column &@ keyword
```

`column`は検索対象のカラムです。型は`jsonb`型です。

`keyword`は全文検索で使うキーワードです。`text`型です。

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

`&@`演算子を使うと1つのキーワードで全文検索できます。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数][postgresql-jsonb-pretty]を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &@ 'server';
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

## 参考

  * [`jsonb`サポート][jsonb]

  * [`&?`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

[jsonb]:../jsonb.html

[query-jsonb-v2]:query-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
