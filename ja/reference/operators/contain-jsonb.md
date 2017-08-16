---
title: "@>演算子"
upper_level: ../
---

# `@>`演算子

## 概要

PGroongaは`@>`演算子の検索をインデックスを使って高速に実現できます。

[`@>`演算子はPostgreSQL組み込みの演算子][postgresql-jsonb-operators]です。`@>`演算子は右辺の`jsonb`型の値が左辺の`jsonb`型の値のサブセットなら真を返します。


## 構文

この演算子の構文は次の通りです。

```sql
column @> query
```

`column`は検索対象のカラムです。型は`jsonb`型です。

`query`はクエリーに使う`jsonb`型の値です。

この演算子は`query`が`column`の値のサブセットなら`true`を返し、それ以外の時は`false`を返します。

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

マッチする例は次の通りです。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数][postgresql-jsonb-pretty]を使っています。）

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

マッチしない例は次の通りです。

検索条件の`jsonb`型の値で配列を使った場合、検索対象の`jsonb`型の値にすべての要素が含まれていなければいけません。要素の順番は問いません。もし、検索条件の`jsonb`型の値の要素のうち、1つでも検索対象の`jsonb`型の値に含まれていない要素があればそのレコードはマッチしません。

以下の例では、`"mail"`または`"web"`を含むレコードはありますが、`"mail"`と`"web"`両方を含むレコードはありません。そのため、次の`SELECT`は1つもレコードを返しません。

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record @> '{"tags": ["mail", "web"]}'::jsonb;
--  jsonb_pretty 
-- --------------
-- (0 rows)
```

## 参考

  * [`jsonb`サポート][jsonb]

  * [`&@~`演算子][query-jsonb-v2]：`jsonb`内のすべてのテキストデータを便利なクエリー言語を使った全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

[jsonb]:../jsonb.html

[query-jsonb-v2]:query-jsonb-v2.html

[script-jsonb-v2]:script-jsonb-v2.html

[postgresql-jsonb-operators]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html#FUNCTIONS-JSONB-OP-TABLE

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
