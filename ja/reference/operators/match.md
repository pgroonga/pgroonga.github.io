---
title: "%%演算子"
upper_level: ../
---

# `%%`演算子

## 概要

この演算子は1.2.0から非推奨です。代わりに[`&@`演算子][match-v2]を使ってください。

`%%`は1つのキーワードで全文検索を実行します。

## 構文

```sql
column %% keyword
```

`column`は検索対象のカラムです。型は`text`型、`text[]`型、`varchar`型のどれかです。

`keyword`は全文検索で使うキーワードです。`column`が`text`型または`text[]`型なら`keyword`は`text`型です。`column`が`varchar`型なら`keyword`は`varchar`型です。

## 演算子クラス

この演算子を使うには次のどれかの演算子クラスを指定する必要があります。

  * `pgroonga_text_full_text_search_ops_v2`：`text`型のデフォルト

  * `pgroonga_text_array_full_text_search_ops_v2`：`text[]`型のデフォルト

  * `pgroonga_varchar_full_text_search_ops_v2`：`varchar`用

  * `pgroonga_text_full_text_search_ops`：`text`用

  * `pgroonga_text_array_full_text_search_ops`：`text[]`用

  * `pgroonga_varchar_full_text_search_ops`：`varchar`用

## 使い方

例に使うサンプルスキーマとデータは次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

```sql
INSERT INTO memos VALUES (1, 'PostgreSQLはリレーショナル・データベース管理システムです。');
INSERT INTO memos VALUES (2, 'Groongaは日本語対応の高速な全文検索エンジンです。');
INSERT INTO memos VALUES (3, 'PGroongaはインデックスとしてGroongaを使うためのPostgreSQLの拡張機能です。');
INSERT INTO memos VALUES (4, 'groongaコマンドがあります。');
```

`%%`演算子を使うと1つキーワードで全文検索できます。

```sql
SELECT * FROM memos WHERE content %% '全文検索';
--  id |                      content
-- ----+---------------------------------------------------
--   2 | Groongaは日本語対応の高速な全文検索エンジンです。
-- (1 row)
```

複数のキーワードで全文検索したいときやAND/ORを使った検索をしたいときは[`&@~`演算子][query-v2]を使います。

複数のキーワードでOR全文検索をしたいときは[`&@|`演算子][match-in-v2]を使います。

## 参考

  * [`&@~`演算子][query-v2]：便利なクエリー言語を使った全文検索

  * [`&@|`演算子][match-in-v2]：キーワードの配列での全文検索

[match-v2]:match-v2.html
[query-v2]:query-v2.html
[match-in-v2]:match-in-v2.html
