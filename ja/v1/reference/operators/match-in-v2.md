---
title: "&@|演算子"
upper_level: ../
---

# `&@|`演算子

1.2.1で追加。

## 概要

1.2.1から`&@>`は非推奨になりました。代わりに`&@|`演算子を使ってください。

`&@|`演算子はキーワードの配列で全文検索を実行します。1つ以上のキーワードが見つかった場合、そのレコードはマッチしたことになります。

## 構文

```sql
column &@| keywords
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`keywords`は全文検索で使うキーワードの配列です。`column`の型が`text`型か`text[]`型の場合は型は`text[]`型です。`column`が`varchar`型の場合は型は`varchar[]`型です。

この演算子は`keywords`中の1つ以上のキーワードが`column`の中に含まれていると`true`を返します。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga.text_full_text_search_ops_v2`：`text`用

  * `pgroonga.text_array_full_text_search_ops_v2`：`text[]`用

  * `pgroonga.varchar_full_text_search_ops_v2`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos
  USING pgroonga (content pgroonga.text_full_text_search_ops_v2);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`&@|`演算子を使うと複数のキーワードで全文検索できます。

```sql
SELECT * FROM memos WHERE content &@> ARRAY['全文検索', 'データベース'];
--  id |                          content                           
-- ----+------------------------------------------------------------
--   1 | PostgreSQLはリレーショナル・データベース管理システムです。
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (2 rows)
```


column &@| ARRAY['キーワード1', 'キーワード2']`は`column &@~ 'キーワード1 OR キーワード2'`と同じです。

## 参考

  * [`&@`演算子][match-v2]：キーワード1つでの全文検索

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&@~|`演算子][query-in-v2]：便利なクエリー言語を使ったクエリーの配列での全文検索

[match-v2]:match-v2.html
[query-v2]:query-v2.html
[query-in-v2]:query-in-v2.html
