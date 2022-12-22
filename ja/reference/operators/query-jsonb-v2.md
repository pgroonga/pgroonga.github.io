---
title: "jsonb型用の&@~演算子"
upper_level: ../
---

# `jsonb`型用の`&@~`演算子

1.2.1で追加。

`&?`演算子は1.2.2から非推奨です。代わりに`&@~`演算子を使ってください。

## 概要

`&@~`は`jsonb`内のすべてのテキストに対してクエリーを使って全文検索を実行します。

クエリーの構文はWeb検索エンジンで使われている構文と似ています。たとえば、クエリーで`キーワード1 OR キーワード2`と書くとOR検索できます。

## 構文

```sql
column &@~ query
```

`column`は検索対象のカラムです。型は`jsonb`型です。

`query`は全文検索で使うクエリーです。`text`型です。

`qeury`では[Groongaのクエリー構文][groonga-query-syntax]を使います。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_jsonb_ops_v2`：`jsonb`型のデフォルト

  * `pgroonga_jsonb_ops`：`jsonb`型用

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

`&@~`演算子を使うと`キーワード1 キーワード2`のように複数のキーワードを指定して全文検索できます。`キーワード1 OR キーワード2`のようにOR検索することもできます。

（読みやすくするためにPostgreSQL 9.5以降で使える[`jsonb_pretty()`関数][postgresql-jsonb-pretty]を使っています。）

```sql
SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'server OR mail';
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

## PGroongaのパフォーマンス向上のための注意事項: jsonbカラム内にある特定のキーの値を検索したい場合、検索対象となるすべてのキーに対してインデックス作成が必要

`&@~`演算子を用いてjsonbカラム内にある特定のキーの値を検索する時には、先の例で実施されてるようなjsonbカラム全体をインデックス対象にするのではなく、検索対象のそれぞれのキーに対してインデックスを作成する必要があります。それらのインデックスが存在しない場合は  `&@~`演算子はシーケンシャル検索のみを実行するため、パフォーマンスは極めて低速となります。

こちらに前例の`logs`テーブルを用いたサンプルデモを記載します:

```sql
-- このクエリはPGroongaのインデックスを使うのでパフォーマンスは最高です
SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'get';
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


-- このクエリはPGroongaインデックスを使用しないので、単なるシーケンシャル検索になります(遅いです)
SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
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

-- EXPLAIN ANALYZEを実行して、ご自身でパフォーマンスを比較してみてください
-- jsonbカラム全体を検索する時はインデックスが使われます
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record &@~ 'get';
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on public.logs  (cost=0.00..21.03 rows=1 width=32) (actual time=1.577..1.578 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Recheck Cond: (logs.record &@~ 'get'::text)
--    Heap Blocks: exact=1
--    ->  Bitmap Index Scan on pgroonga_logs_index  (cost=0.00..0.00 rows=14 width=0) (actual time=1.566..1.566 rows=1 loops=1)
--          Index Cond: (logs.record &@~ 'get'::text)
--  Planning Time: 0.680 ms
--  Execution Time: 1.631 ms
-- (8 rows)


-- しかし、jsonbカラム内の特定のキーの値を検索する際には、インデックスは使われません
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
--                                                QUERY PLAN                                                
-- ---------------------------------------------------------------------------------------------------------
--  Seq Scan on public.logs  (cost=0.00..1047.00 rows=1 width=32) (actual time=0.422..0.566 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Filter: ((logs.record -> 'message'::text) &@~ 'get'::text)
--    Rows Removed by Filter: 2
--  Planning Time: 0.035 ms
--  Execution Time: 0.576 ms
-- (6 rows)
```

さて、ここでjsonbカラム内にある`message`キーのインデックスを作成するとどうなるでしょう:

```sql
-- jsonbカラム内の"message"キーのインデックスを作成します
CREATE INDEX pgroonga_message_index ON logs USING pgroonga ((record->'message'));

-- EXPLAIN ANALYZEを実行前にPGroongaが確実にインデックスを利用するようシーケンシャルスキャンをOFFにします
-- 注意: 本番環境では SET enable_seqscan = off を実施しないようにしてください
SET enable_seqscan = off;

-- クエリーを分析すると確実にインデックスが使われているのが分かります
EXPLAIN ANALYZE verbose SELECT jsonb_pretty(record) FROM logs WHERE record->'message' &@~ 'get';
--                                                               QUERY PLAN                                                               
-- ---------------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgroonga_message_index on public.logs  (cost=0.00..4.01 rows=1 width=32) (actual time=2.389..2.393 rows=1 loops=1)
--    Output: jsonb_pretty(record)
--    Index Cond: ((logs.record -> 'message'::text) &@~ 'get'::text)
--  Planning Time: 0.201 ms
--  Execution Time: 2.496 ms
-- (5 rows)

```


## もし事前に検索対象となるjsonbカラム内のキーが分からない場合には、代わりに `` &` `` 演算子を使いましょう

未定義のデータを格納するようなjson/jsonbカラムを利用する際の常として、検索対象となる項目が事前に分からないことが時々発生します。（例えばユーザから様々なデータを保存しておく場所が欲しいと頼まれ、jsonbで格納場所を準備したものの、後日それらのデータを検索対象にしたいと言われることもあります）。
そうしたケースにおいて `` &` `` 演算子を用いることで、事前にjsonbカラム内のキーをインデックス対象に含めていなくとも`pgroonga_jsonb_ops_v2` インデックスを使って高速な検索を実現することができます。

具体的な例を見てみましょう:

```sql
CREATE TABLE logs (
  record jsonb
);

-- jsonbカラム全体にインデックスを作成します(特定のキーに対してではありません)
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

-- &` 演算子を用いることで、特定のキーにインデックスを作成せずともPGroongaの高性能さを利用することができます
EXPLAIN ANALYZE VERBOSE SELECT * FROM logs WHERE record &` '(paths @ "message") && query("string", "get")';
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on public.logs  (cost=0.00..21.03 rows=1 width=32) (actual time=1.020..1.022 rows=1 loops=1)
--    Output: record
--    Recheck Cond: (logs.record &` '(paths @ "message") && query("string","get")'::text)
--    Heap Blocks: exact=1
--    ->  Bitmap Index Scan on pgroonga_logs_index  (cost=0.00..0.00 rows=14 width=0) (actual time=1.012..1.013 rows=1 loops=1)
--          Index Cond: (logs.record &` '(paths @ "message") && query("string","get")'::text)
--  Planning Time: 0.379 ms
--  Execution Time: 1.077 ms
-- (8 rows)
```

これらの説明や使用例が、皆さんの素晴らしいアプリケーションを作る手助けになれれば幸いです 😄

## 参考

  * [`jsonb`サポート][jsonb]

  * [`&@`演算子][match-jsonb-v2]：`jsonb`内のすべてのテキストデータをキーワード1つで全文検索

  * [`` &` ``演算子][script-jsonb-v2]：ECMAScriptのようなクエリー言語を使った高度な検索

  * [`@>`演算子][contain-jsonb]：`jsonb`データを使った検索

  * [Groongaのクエリーの構文][groonga-query-syntax]

[jsonb]:../jsonb.html

[match-jsonb-v2]:match-jsonb-v2.html
[script-jsonb-v2]:script-jsonb-v2.html
[contain-jsonb]:contain-jsonb.html

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[postgresql-jsonb-pretty]:{{ site.postgresql_doc_base_url.ja }}/functions-json.html#FUNCTIONS-JSON-PROCESSING-TABLE
